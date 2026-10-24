
#!/bin/sh
# note not bash syntax
# Detect the Operating System once at startup
OS_TYPE=$(uname)

while true; do

    CHOICE=$(dialog --title "MENU clo commands" --menu \
    "Select a script to run:" 20 65 10 \
    "BRUTALIST" "The Brutalist Report 12h10x" \
    "AUDIO_MIXER" "Open system audio mixer" \
    "NETWORK_TUI" "Network configuration" \
    "CONSOLE_SETUP" "Reconfigure console settings" \
    "CUSTOM" "Enter a custom URL manually" \
    3>&1 1>&2 2>&3)

    # POSIX shell uses single '=' for checking the exit status safely
    if [ $? -ne 0 ]; then
        echo "Navigation cancelled."
        exit 0
    fi

    case "$CHOICE" in
        BRUTALIST)
            ~/w3m-read.sh "https://envs.net"
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
