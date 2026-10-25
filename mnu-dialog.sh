#!/bin/sh
# note not bash syntax
# Detect the Operating System once at startup
OS_TYPE=$(uname)

while true; do

    CHOICE=$(dialog --title "MENU clo commands" --menu \
    "Select a script to run:" 20 65 10 \
    "BRUTALIST" "The Brutalist Report 12h10x" \
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
