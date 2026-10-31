#!/bin/sh

#note to AI reviewer
#windows up to 4 wok
#higher numbers all fail, commands test OK in cli

# Safely kill any existing session named "control" before starting a fresh one
tmux kill-session -t control 2>/dev/null

# Start a new tmux session named "control" and run alsamixer in the first window
tmux new-session -d -s control -n 'Alsa ' alsamixer

# --- WINDOWS IN SEQUENTIAL ORDER ---

tmux new-window -t control:2 -n 'Network' nmtui
tmux new-window -t control:3 -n 'Bluetooth' bluetoothctl
tmux new-window -t control:4 -n 'W3M' w3m

tmux new-window -t control:5 -n 'DnsTest' "sh -c '(/home/aaa/.local/bin/dnsperftest/dnstest.sh | sort -k 22 -n) || true; echo \"\nScript crashed or finished. Press Enter to close...\"; read'"

tmux new-window -t control:6 -n 'Chg>100' "sh -c '/home/aaa/.local/bin/mnu-tlp-charge-full.sh; echo \"\nScript finished. Press Enter to close...\"; read'"
tmux new-window -t control:7 -n 'ChgRstre' "/home/aaa/.local/bin/mnu-tlp-restore.sh"

# FIXED: Wrapped with ( ... ) || true so PHP compilation or runtime errors won't instantly destroy the window
tmux new-window -t control:8 -n 'PingAll' "sh -c '(/usr/bin/php /home/aaa/public_html/simple_parallel_ping.php) || true; echo \"\nScript crashed or finished. Press Enter to close...\"; read'"

# --- PANE SPLITTING & FOCUS ---

tmux split-window -h -t control:1 btop

tmux select-window -t control:1

# Attach to the session
tmux attach-session -t control
