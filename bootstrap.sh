#!/usr/bin/sh
# this may not be correct over all linux and bsd, but is it aliased everywhere?
# curl or python3 bay not always work without path

curl https://raw.githubusercontent.com/sustance/murmuration/refs/heads/main/status_slaves.py \
  -o /home/$USER/public_html/status_slaves.py
python3 /home/$USER/public_html/status_slaves.py

curl https://raw.githubusercontent.com/sustance/configs/refs/heads/main/ mm -o /home/$USER/.local/bin/mm 

#Note
# This is pulled by chron each day at the same UTC time on every computer in the swarm then 
# The computers are mostly set to their local time
