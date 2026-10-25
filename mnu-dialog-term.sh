#!/bin/sh
# note not bash syntax
# Detect the Operating System once at startup
OS_TYPE=$(uname)

while true; do

    CHOICE=$(dialog --title "MENU cli commands" --menu \
    "Select a script to run:" 20 65 10 \
    "POWER_CHG_100" "Enable battery to charge to 100%" \
    "POWER_RESET"   "Restore battery to charge to defaults" \
    "POWER_AUDIT"   "mnu-power-audit.sh realtime details" \
    "QEMU_FREEBSD"  "mnu-qemu-fbsd.sh iso freebsd" \
    "QEMU_WIN_PE"   "mnu-qemu-winpe.sh iso windows PE" \
    "AUDIO_MIXER"   "Open system audio mixer" \
    "NETWORK_TUI"   "Network configuration" \
    "CONSOLE_SETUP" "Reconfigure console settings" \
    "CUSTOM"        "Enter a custom URL manually" \
    3>&1 1>&2 2>&3)

    # POSIX shell uses single '=' for checking the exit status safely
    if [ $? -ne 0 ]; then
        echo "Navigation cancelled."
        exit 0
    fi
    

    case "$CHOICE" in

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
            
        POWER_AUDIT)
            ~/.local/bin/mnu-qemu-winpe.sh
            ;;
            
#        QEMU_S_RESCUE)
#            ~/.local/bin/mnu-qemu-srescue.sh
#            ;;
            
        QEMU_WIN_PE)
            ~/.local/bin/mnu-qemu-winpe.sh
            ;;
            
        AUDIO_MIXER)
            if [ "$OS_TYPE" = "Linux" ]; then
                if [ -n "$DISPLAY" ]; then
                    xfce4-terminal -e "alsamixer"
                else
                    clear && "alsamixer"
                fi
            elif [ "$OS_TYPE" = "FreeBSD" ]; then
                if [ -n "$DISPLAY" ]; then
                    xfce4-terminal -e "mixer"
                else
                    clear && "mixer"
                fi
            fi
            ;;

        NETWORK_TUI)
            if [ "$OS_TYPE" = "Linux" ]; then
                if [ -n "$DISPLAY" ]; then
                    xfce4-terminal -e "nmtui"
                else
                    clear && "nmtui"
                fi
            elif [ "$OS_TYPE" = "FreeBSD" ]; then
                if [ -n "$DISPLAY" ]; then
                    xfce4-terminal -e "bsdconfig networking"
                else
                    clear && "bsdconfig networking"
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
                    clear && "bsdconfig console"
                fi
            fi
            ;;

        CUSTOM)
            URL=$(dialog --inputbox "Enter complete URL:" 8 60 "https://" 3>&1 1>&2 2>&3)
            if [ -n "$URL" ]; then
                ~/w3m-read.sh "$URL"
            fi
            ;;

        *)
            exit 0
            ;;
    esac

done
