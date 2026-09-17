#!/usr/bin/env bash
#
# monitor-node.sh — snapshot thermal/power/CPU state for before/after comparison.
#
# Usage:
#   ./monitor-node.sh              # single snapshot, printed to terminal
#   ./monitor-node.sh --log        # append a CSV row to /var/log/node-metrics.csv
#   ./monitor-node.sh --watch 5    # repeat every 5s until Ctrl-C (terminal only)
#
CSV="/var/log/node-metrics.csv"

snapshot_human() {
  echo "=== $(date) ==="
  echo "-- Temps --"
  if command -v sensors >/dev/null 2>&1; then
    sensors
  else
    for z in /sys/class/thermal/thermal_zone*/temp; do
      [ -f "$z" ] && echo "$z: $(( $(cat "$z") / 1000 ))C"
    done
  fi
  echo "-- CPU frequency (per core, kHz) --"
  for f in /sys/devices/system/cpu/cpu[0-9]*/cpufreq/scaling_cur_freq; do
    [ -f "$f" ] && echo "$f: $(cat "$f")"
  done
  echo "-- Load average --"
  cat /proc/loadavg
  echo "-- Memory / swap --"
  free -h
  echo "-- Memory pressure (PSI, if available) --"
  cat /proc/pressure/memory 2>/dev/null || echo "not available (older kernel)"
  echo "-- Power source --"
  for p in /sys/class/power_supply/*/online /sys/class/power_supply/*/status; do
    [ -f "$p" ] && echo "$p: $(cat "$p")"
  done
  echo "-- Battery instantaneous draw (only meaningful if NOT on AC) --"
  for p in /sys/class/power_supply/BAT*/power_now; do
    [ -f "$p" ] && echo "$p: $(( $(cat "$p") / 1000 )) mW"
  done
  echo "-- Top 5 CPU processes --"
  ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -6
  echo "-- GPU / hardware encode availability --"
  if command -v vainfo >/dev/null 2>&1; then
    vainfo 2>&1 | grep -E "VAProfile|Driver version" | head -20
  else
    echo "vainfo not installed — install with: apt-get install vainfo  (to confirm VAAPI hw-encode is actually usable)"
  fi
}

snapshot_csv_row() {
  local ts temp_max freq_avg load1 mem_used_mb swap_used_mb
  ts=$(date -Iseconds)
  temp_max=0
  for z in /sys/class/thermal/thermal_zone*/temp; do
    [ -f "$z" ] || continue
    v=$(( $(cat "$z") / 1000 ))
    [ "$v" -gt "$temp_max" ] && temp_max=$v
  done
  freq_sum=0; freq_n=0
  for f in /sys/devices/system/cpu/cpu[0-9]*/cpufreq/scaling_cur_freq; do
    [ -f "$f" ] || continue
    freq_sum=$((freq_sum + $(cat "$f")))
    freq_n=$((freq_n + 1))
  done
  freq_avg=0
  [ "$freq_n" -gt 0 ] && freq_avg=$((freq_sum / freq_n))
  load1=$(awk '{print $1}' /proc/loadavg)
  mem_used_mb=$(free -m | awk '/^Mem:/{print $3}')
  swap_used_mb=$(free -m | awk '/^Swap:/{print $3}')
  if [ ! -f "$CSV" ]; then
    echo "timestamp,max_temp_c,avg_freq_khz,load1,mem_used_mb,swap_used_mb" > "$CSV"
  fi
  echo "${ts},${temp_max},${freq_avg},${load1},${mem_used_mb},${swap_used_mb}" >> "$CSV"
}

if [ "${1:-}" = "--log" ]; then
  snapshot_csv_row
  echo "Logged to $CSV"
elif [ "${1:-}" = "--watch" ]; then
  interval="${2:-5}"
  while true; do clear; snapshot_human; sleep "$interval"; done
else
  snapshot_human
fi
