#!/bin/sh
# note not bash syntax
# Detect the Operating System once at startup
OS_TYPE=$(uname)

while true; do
    # CHOICE=$(dialog --title "MENU cli commands" --menu \
    CHOICE=$(dialog --menu \
    "Select a script to run:" 20 65 10 \
    "SHEETS_CSV"      "Cli spreadsheet" \
    "NEOMUTT"         "Open Gmail" \
    "OPEN_BB"         "Open Bloomberg" \
    "GLOOMBERB"       "Gloomberb" \
    "W3M_COOKIE"      "With  cookies" \
    "NEOMUTT"         "Open email" \
    "BRIGHT_SLIDER"   "Brightness" \
    "POWER_CHG_100"   "Batt charge 100%" \
    "POWER_RESET"     "Batt chg default" \
    "POWER_AUDIT"     "Power realtime" \
    "QEMU_FREEBSD"    "ISO freebsd" \
    "QEMU_WIN_PE"     "ISO iso winPE" \
    "AUDIO_MIXER"     "Open  alsamixer" \
    "BLUETOOTHCTL"    "BT Control" \
    "BLUEMAN_MGR"     "BT Manager" \
    "NETWORK_TUI"     "Network config." \
    "XFCE4_SETTING"   "Settings-manager" \
    "CONSOLE_SETUP"   "Reconfig console" \
    "SNAPFORM_VIEW"   "EU govt form GUI" \
    "KITTY_PUBNIX"    "Tmux all pubnix " \
    "REBOOT_BIOS"     "Reboots to BIOS" \
    3>&1 1>&2 2>&3)

    # POSIX shell uses single '=' for checking the exit status safely
    if [ $? -ne 0 ]; then
        echo "Navigation cancelled."
        exit 0
    fi

    case "$CHOICE" in
        SHEETS_CSV)
            xfce4-terminal --hold -e "bash -c '/home/aaa/store/Applications/sheets_Linux_x86_64/sheets /home/aaa/md/MATURITY.csv'"
            ;;

        OPEN_BB)
             xfce4-terminal --hold -e "bash -c 'source /home/aaa/openbb-env/bin/activate; openbb'"
             ;;
             
        GLOOMBERB)
            kitty --hold -e ".local/bin/gloomberb"
            ;;

        W3M_COOKIE)
            xfce4-terminal --hold -e "/usr/bin/w3m -s -cookie -N"
            ;;
        
         NEOMUTT)
            xfce4-terminal --hold -e "neomutt"
            ;;

         PARALLEL_PING)
            xfce4-terminal --hold -e "/usr/bin/php /home/aaa/public_html/simple_parallel_ping.php"
            ;;
         
        BRIGHTNESS_25P)
            brightnessctl set 25%
            ;;
        BRIGHTNESS_50P)
            brightnessctl set 50%
            ;;
        BRIGHTNESS_75P)
            brightnessctl set 57%
            ;;
        BRIGHTNESS_100P)
            brightnessctl set 100%
            ;;
        BRIGHT_SLIDER)
            sh -c "brightnessctl set \$(yad --scale --value=\$(brightnessctl g) --max-value=100 --title='Brightness' --width=300 --height=100 2>/dev/null)%"
            ;;
        POWER_CHG_100)
            xfce4-terminal -e "/home/aaa/.local/bin/mnu-tlp-charge-full.sh"
            ;;
        POWER_RESET)
            xfce4-terminal -e "/home/aaa/.local/bin/mnu-tlp-restore.sh"
            ;;
        POWER_AUDIT)
            xfce4-terminal -e "/home/aaa/.local/bin/mnu-power-audit.sh"
            ;;
        QEMU_FREEBSD)
            ~/.local/bin/mnu-qemu-fbsd.sh
            ;;
        QEMU_WIN_PE)
            ~/.local/bin/mnu-qemu-winpe.sh
            ;;
        AUDIO_MIXER)
            if [ "$OS_TYPE" = "Linux" ]; then
                if [ -n "$DISPLAY" ]; then
                    xfce4-terminal -e "alsamixer"
                else
                    clear && alsamixer
                fi
            elif [ "$OS_TYPE" = "FreeBSD" ]; then
                if [ -n "$DISPLAY" ]; then
                    xfce4-terminal -e "mixer"
                else
                    clear && mixer
                fi
            fi
            ;;
        BLUETOOTHCTL)
            xfce4-terminal -e bluetoothctl
            ;;
        BLUEMAN_MGR)
            blueman-manager
            ;;
        NETWORK_TUI)
            if [ "$OS_TYPE" = "Linux" ]; then
                if [ -n "$DISPLAY" ]; then
                    xfce4-terminal -e "nmtui"
                else
                    clear && nmtui
                fi
            elif [ "$OS_TYPE" = "FreeBSD" ]; then
                if [ -n "$DISPLAY" ]; then
                    xfce4-terminal -e "bsdconfig networking"
                else
                    clear && bsdconfig networking
                fi
            fi
            ;;
        XFCE4_SETTING)
            xfce4-settings-manager
        ;;  
        CONSOLE_SETUP)
            if [ "$OS_TYPE" = "Linux" ]; then
                if [ -n "$DISPLAY" ]; then
                    xfce4-terminal -e "sudo dpkg-reconfigure console-setup"
                else
                    clear && sudo dpkg-reconfigure console-setup
                fi
            elif [ "$OS_TYPE" = "FreeBSD" ]; then
                if [ -n "$DISPLAY" ]; then
                    xfce4-terminal -e "bsdconfig console"
                else
                    clear && bsdconfig console
                fi
            fi
            ;;  
        SNAPFORM_VIEW)
            # Assuming snapform viewer binary or script placement:
            snapform-viewer 2>/dev/null || xfce4-terminal -e "snapform-viewer"
            ;;
        KITTY_PUBNIX)
            kitty sh -c "/home/aaa/.local/bin/pubnix;exec bash"
            ;;
        REBOOT_BIOS|SHEETS)
            xfce4-terminal --hold -e "sudo systemctl reboot --firmware-setup"
            ;;
        *)
            exit 0
            ;;
    esac
done
