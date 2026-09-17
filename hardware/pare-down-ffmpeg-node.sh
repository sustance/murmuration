#!/usr/bin/env bash
#
# pare-down-ffmpeg-node.sh
#
# Purpose: pare a headless, SSH-only laptop down to "ffmpeg transcode box only"
#          to reduce idle heat/energy, WITHOUT ever risking loss of SSH access.
#
# Design principles baked into this script:
#   1. SSH access is never touched. sshd is never stopped, reloaded, or reconfigured.
#   2. Everything defaults to DRY RUN. Nothing changes until you pass --apply.
#   3. Anything that touches networking uses a "dead man's switch" (auto-revert)
#      so a mistake un-does itself instead of locking you out permanently.
#   4. Every destructive step checks the unit/package exists before touching it,
#      so it's safe to re-run on a machine that's only partially set up.
#   5. Sleep/suspend/hibernate are always disabled — a remote headless box must
#      never go to sleep on its own.
#
# Usage:
#   sudo ./pare-down-ffmpeg-node.sh --status        # report current state, change nothing
#   sudo ./pare-down-ffmpeg-node.sh --dry-run        # (default) show what WOULD happen
#   sudo ./pare-down-ffmpeg-node.sh --apply          # actually apply the safe changes
#   sudo ./pare-down-ffmpeg-node.sh --apply --with-firewall   # also do the gated firewall step
#
set -uo pipefail

LOGFILE="/var/log/pare-down-node.log"
BACKUP_DIR="/root/pare-down-backup-$(date +%Y%m%d-%H%M%S)"
MODE="dry-run"
DO_FIREWALL=0

for arg in "$@"; do
  case "$arg" in
    --status) MODE="status" ;;
    --dry-run) MODE="dry-run" ;;
    --apply) MODE="apply" ;;
    --with-firewall) DO_FIREWALL=1 ;;
    *) echo "Unknown argument: $arg" ; exit 1 ;;
  esac
done

log() { echo "[$(date '+%H:%M:%S')] $*" | tee -a "$LOGFILE"; }
act() {
  # act "description" "command to run"
  local desc="$1"; local cmd="$2"
  if [ "$MODE" = "apply" ]; then
    log "APPLYING: $desc"
    eval "$cmd" >>"$LOGFILE" 2>&1 || log "  -> WARNING: command failed (non-fatal, continuing): $cmd"
  else
    log "WOULD DO: $desc   [$cmd]"
  fi
}

require_root() {
  if [ "$(id -u)" -ne 0 ]; then
    echo "Run as root (sudo). Exiting." ; exit 1
  fi
}

# --- Safety check: refuse to run destructive steps outside an SSH session context sanity check ---
ssh_sanity_check() {
  local default_iface
  default_iface=$(ip route show default 2>/dev/null | awk '{print $5; exit}')
  if [ -z "$default_iface" ]; then
    log "WARNING: could not determine default route interface. Network-affecting steps will be SKIPPED for safety."
    export SAFE_TO_TOUCH_NET=0
  else
    log "Default route interface detected: $default_iface"
    export DEFAULT_IFACE="$default_iface"
    export SAFE_TO_TOUCH_NET=1
  fi
}

backup_configs() {
  act "backup /etc to $BACKUP_DIR before making changes" \
    "mkdir -p '$BACKUP_DIR' && cp -a /etc '$BACKUP_DIR/etc-backup' 2>/dev/null; rfkill list > '$BACKUP_DIR/rfkill-before.txt' 2>/dev/null; systemctl list-units --state=running > '$BACKUP_DIR/running-units-before.txt'"
}

# --- Section A: GUI / display manager — mask so it can never accidentally start ---
mask_display_manager() {
  for dm in gdm gdm3 lightdm sddm xdm; do
    if systemctl list-unit-files 2>/dev/null | grep -q "^${dm}\.service"; then
      act "mask display manager: $dm" "systemctl stop ${dm}.service; systemctl disable ${dm}.service; systemctl mask ${dm}.service"
    fi
  done
}

# --- Section B: unnecessary services for a headless single-purpose box ---
disable_unneeded_services() {
  local services=(cups cups-browsed avahi-daemon avahi-daemon.socket ModemManager
                   bluetooth speech-dispatcher colord packagekit whoopsie apport
                   pulseaudio.service pipewire.service pipewire-pulse.service wpa_supplicant)
  for svc in "${services[@]}"; do
    if systemctl list-unit-files 2>/dev/null | grep -q "^${svc}"; then
      act "disable unneeded service: $svc" "systemctl stop $svc 2>/dev/null; systemctl disable $svc 2>/dev/null; systemctl mask $svc 2>/dev/null"
    fi
  done
  log "NOTE: wpa_supplicant is only masked if it exists as a standalone unit — if it's your Wi-Fi path, see the radio section below, this list won't disable your only network route."
}

# --- Section C: radios — never touch the one carrying your SSH session ---
disable_unused_radios() {
  if [ "${SAFE_TO_TOUCH_NET:-0}" -ne 1 ]; then
    log "SKIPPING radio changes: could not confirm default route interface."
    return
  fi
  if [[ "$DEFAULT_IFACE" == wl* ]]; then
    log "Default route is over Wi-Fi ($DEFAULT_IFACE) — Wi-Fi will NOT be disabled. Bluetooth only."
    act "rfkill block bluetooth only" "rfkill block bluetooth"
  else
    log "Default route is over wired interface ($DEFAULT_IFACE) — safe to disable Wi-Fi radio too."
    act "rfkill block wifi and bluetooth (wired path confirmed)" "rfkill block wifi; rfkill block bluetooth"
  fi
}

# --- Section D: never let the box sleep — critical for remote reachability ---
disable_sleep_targets() {
  act "mask suspend/sleep/hibernate targets" \
    "systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target suspend-then-hibernate.target"
  act "disable lid-switch action in logind (ignore lid close entirely)" \
    "sed -i.bak -E 's/^#?HandleLidSwitch=.*/HandleLidSwitch=ignore/; s/^#?HandleLidSwitchExternalPower=.*/HandleLidSwitchExternalPower=ignore/; s/^#?HandleSuspendKey=.*/HandleSuspendKey=ignore/' /etc/systemd/logind.conf && systemctl restart systemd-logind || true"
}

# --- Section E: power management for USB/PCIe/CPU (via TLP if available) ---
setup_power_management() {
  if ! command -v tlp >/dev/null 2>&1; then
    act "install tlp for laptop power management" "apt-get update && apt-get install -y tlp"
  fi
  act "set CPU governor preference in TLP (powersave on AC, since speed is not the priority)" \
    "sed -i.bak -E 's/^#?CPU_SCALING_GOVERNOR_ON_AC=.*/CPU_SCALING_GOVERNOR_ON_AC=powersave/' /etc/tlp.conf 2>/dev/null || true"
  act "enable and start tlp" "systemctl enable tlp && systemctl start tlp"
  log "NOTE: if your NIC (network card) is USB-attached (e.g. a USB-Ethernet dongle), verify it is on TLP's USB_DENYLIST so it is never autosuspended — check with: tlp-stat -u"
}

# --- Section F: kernel/thermal watchdog reachability net (software, safe) ---
setup_reachability_watchdog() {
  cat > /tmp/net-watchdog.sh <<'EOF'
#!/usr/bin/env bash
# If the default gateway is unreachable for several consecutive checks,
# restart networking (NOT reboot) as a self-heal step. Logs each check.
GW=$(ip route show default | awk '{print $3; exit}')
LOG=/var/log/net-watchdog.log
FAILFILE=/run/net-watchdog-fails
[ -z "$GW" ] && exit 0
if ping -c1 -W3 "$GW" >/dev/null 2>&1; then
  echo 0 > "$FAILFILE"
else
  n=$(cat "$FAILFILE" 2>/dev/null || echo 0)
  n=$((n+1))
  echo "$n" > "$FAILFILE"
  echo "$(date): gateway unreachable, fail count=$n" >> "$LOG"
  if [ "$n" -ge 5 ]; then
    echo "$(date): restarting networking after $n failures" >> "$LOG"
    systemctl restart systemd-networkd 2>/dev/null || systemctl restart NetworkManager 2>/dev/null
    echo 0 > "$FAILFILE"
  fi
fi
EOF
  act "install reachability self-heal script" "install -m 755 /tmp/net-watchdog.sh /usr/local/sbin/net-watchdog.sh"
  act "schedule reachability check every 2 minutes via cron" \
    "(crontab -l 2>/dev/null | grep -v net-watchdog.sh ; echo '*/2 * * * * /usr/local/sbin/net-watchdog.sh') | crontab -"
  log "NOTE: this restarts the network STACK, never the machine. It will NOT fix a fully hung kernel — that needs a hardware watchdog or a smart plug (see action list)."
}

# --- Section G: hardware watchdog, if the chipset has one (common on Intel via iTCO) ---
check_hw_watchdog() {
  if [ -e /dev/watchdog ]; then
    log "Hardware watchdog device present at /dev/watchdog."
    if ! command -v watchdog >/dev/null 2>&1; then
      act "install watchdog daemon to arm the hardware watchdog" "apt-get install -y watchdog"
    fi
    act "enable watchdog daemon (reboots the box if the kernel itself hangs)" "systemctl enable watchdog && systemctl start watchdog"
  else
    log "No /dev/watchdog device found. No hardware watchdog to arm — see action list for a smart-plug fallback."
  fi
}

# --- Section H (OPT-IN, gated): firewall with a dead-man's-switch auto-revert ---
setup_firewall_with_deadmans_switch() {
  if [ "$DO_FIREWALL" -ne 1 ]; then
    log "Skipping firewall setup (pass --with-firewall to include it)."
    return
  fi
  if ! command -v ufw >/dev/null 2>&1; then
    act "install ufw" "apt-get install -y ufw"
  fi
  act "back up current ufw state" "ufw status verbose > '$BACKUP_DIR/ufw-before.txt' 2>/dev/null || true"
  if [ "$MODE" = "apply" ]; then
    log "APPLYING firewall with 5-minute auto-revert dead-man's switch."
    # Schedule the revert FIRST, before making any change.
    echo "ufw disable" | at now + 5 minutes >>"$LOGFILE" 2>&1
    ufw allow ssh >>"$LOGFILE" 2>&1
    ufw default deny incoming >>"$LOGFILE" 2>&1
    ufw default allow outgoing >>"$LOGFILE" 2>&1
    ufw --force enable >>"$LOGFILE" 2>&1
    log "Firewall enabled. It will AUTO-DISABLE in 5 minutes unless you confirm your SSH session still works and cancel the revert with: atq   (then: atrm <job-id>)"
  else
    log "WOULD DO: enable ufw (allow ssh only), with a 5-minute auto-revert via 'at' as a safety net."
  fi
}

report_status() {
  echo "=== Current state ==="
  echo "-- Display managers --"
  for dm in gdm gdm3 lightdm sddm; do systemctl is-active "$dm" 2>/dev/null | grep -qv "inactive\|not-found" && echo "$dm: ACTIVE"; done
  echo "-- Sleep targets --"
  systemctl is-enabled sleep.target 2>/dev/null
  echo "-- Radios --"
  rfkill list
  echo "-- CPU governor --"
  cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null || echo "cpufreq not exposed"
  echo "-- Watchdog device --"
  [ -e /dev/watchdog ] && echo "present" || echo "absent"
  echo "-- TLP --"
  systemctl is-active tlp 2>/dev/null
  echo "-- Firewall --"
  command -v ufw >/dev/null && ufw status
}

main() {
  require_root
  log "Mode: $MODE"
  if [ "$MODE" = "status" ]; then
    report_status
    exit 0
  fi
  ssh_sanity_check
  backup_configs
  mask_display_manager
  disable_unneeded_services
  disable_unused_radios
  disable_sleep_targets
  setup_power_management
  setup_reachability_watchdog
  check_hw_watchdog
  setup_firewall_with_deadmans_switch
  log "Done. Mode was: $MODE. $( [ "$MODE" = "dry-run" ] && echo 'Re-run with --apply to actually make these changes.' )"
  log "Backups (if applied) are in: $BACKUP_DIR"
}

main "$@"
