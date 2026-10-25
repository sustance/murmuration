#!/bin/sh
# note not bash syntax
# Detect the Operating System once at startup
OS_TYPE=$(uname)

while true; do

    CHOICE=$(dialog --title "MENU clo commands" --menu \
    "Select a script to run:" 20 65 10 \
    "DNS_TEST" "Compare all DNS targets for performance" \
    "CUSTOM" "Enter a custom URL manually" \
    3>&1 1>&2 2>&3)

    # POSIX shell uses single '=' for checking the exit status safely
    if [ $? -ne 0 ]; then
        echo "Navigation cancelled."
        exit 0
    fi

    case "$CHOICE" in
        DNS_TEST)
            xfce4-terminal -e "/home/aaa/.local/bin/dnsperftest/dnstest.sh | sort -k 22 -n"
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
