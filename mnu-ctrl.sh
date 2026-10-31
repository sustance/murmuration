#!/bin/sh

# Fixed: avoid nested shell quoting in tmux windows 5+.
# tmux handles direct commands more reliably than a full quoted `sh -c` payload.

# Safely kill any existing session named "control" before starting a fresh one
# (silence any "no server running on /tmp/tmux-..." noise)
tmux kill-session -t control 2>/dev/null

# Start a new tmux session named "control" and run alsamixer in the first window
tmux new-session -d -s control -n 'Alsa ' alsamixer

# --- WINDOWS IN SEQUENTIAL ORDER ---

tmux new-window -t control:2 -n 'Network' nmtui
tmux new-window -t control:3 -n 'Bluetooth' bluetoothctl
tmux new-window -t control:4 -n 'W3M' w3m

# Use a real shell process with explicit args instead of a single quoted sh -c blob.
# This avoids shell-escaping edge cases that break on later windows.
tmux new-window -t control:5 -n 'DnsTest' /bin/sh -lc '(
  /home/aaa/.local/bin/dnsperftest/dnstest.sh 2>&1 | sort -k 22 -n
) || true
printf "\nScript crashed or finished. Press Enter to close...\n"
read _
'

tmux new-window -t control:6 -n 'Chg>100' /bin/sh -lc '
  /home/aaa/.local/bin/mnu-tlp-charge-full.sh
  printf "\nScript finished. Press Enter to close...\n"
  read _
'

tmux new-window -t control:7 -n 'ChgRstre' /bin/sh -lc '
  /home/aaa/.local/bin/mnu-tlp-restore.sh
  printf "\nScript finished. Press Enter to close...\n"
  read _
'

tmux new-window -t control:8 -n 'PingAll' /bin/sh -lc '(
  /usr/bin/php /home/aaa/public_html/simple_parallel_ping.php 2>&1
) || true
printf "\nScript crashed or finished. Press Enter to close...\n"
read _
'

# --- PANE SPLITTING & FOCUS ---

tmux split-window -h -t control:1 btop

tmux select-window -t control:1

# Attach to the session
tmux attach-session -t control
