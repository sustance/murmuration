#!/bin/sh
# note not bash syntax
# Detect the Operating System once at startup
OS_TYPE=$(uname)

while true; do

    CHOICE=$(dialog --title "MENU cli commands" --menu \
    "Select a script to run:" 20 65 10 \
    "SHEETS_CSV"    "Lict cli csv spreadsheet" \
    "BRIGHTNESS_25P" "A" \
    "BRIGHTNESS_50P" "A" \
    "BRIGHTNESS_75P" "A" \
    "BRIGHTNESS_100P" "A" \
    "BRIGHTNESS_SLIDER" "A" \
    "POWER_CHG_100" "Enable battery to charge to 100%" \
    "POWER_RESET"   "Restore battery to charge to defaults" \
    "POWER_AUDIT"   "mnu-power-audit.sh realtime details" \
    "QEMU_FREEBSD"  "mnu-qemu-fbsd.sh iso freebsd" \
    "QEMU_WIN_PE"   "mnu-qemu-winpe.sh iso windows PE" \
    "AUDIO_MIXER"   "Open system audio mixer" \
    "NETWORK_TUI"   "Network configuration" \
    "CONSOLE_SETUP" "Reconfigure console settings" \
    "SNAPFORM_VIEWER" "European govt form system GUI" \
    "MULTI_KITTY_PUBNIX" "Open all the pubnix sites in TMUX" \
    "CUSTOM"        "Enter a custom URL manually" \
    "REBOOT_TO_BIOS" "CAREFULL, reboots system" \
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
        BRIGHTNESS_SLIDER)
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
        SNAPFORM_VIEWER)
            # Assuming snapform viewer binary or script placement:
            snapform-viewer 2>/dev/null || xfce4-terminal -e "snapform-viewer"
            ;;
        MULTI_KITTY_PUBNIX)
            kitty sh -c "/home/aaa/.local/bin/pubnix;exec bash"
            ;;
        CUSTOM)
            URL=$(dialog --inputbox "Enter complete URL:" 8 60 "https://" 3>&1 1>&2 2>&3)
            if [ -n "$URL" ]; then
                ~/w3m-read.sh "$URL"
            fi
            ;;
        REBOOT_TO_BIOS|SHEETS)
            xfce4-terminal --hold -e "sudo systemctl reboot --firmware-setup"
            ;;
        *)
            exit 0
            ;;
    esac
done
