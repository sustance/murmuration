#!/usr/bin/sh
# this #! may not be correct over all linux and bsd, but is it aliased everywhere?
# curl or python3 may not always work without path ...test

curl https://raw.githubusercontent.com/sustance/murmuration/refs/heads/main/.local/bin/starling.py \
     -o /home/$USER/.local/bin/starling.py
python3 /home/$USER/.local/bin/starling.py  
# this creates a system summary called starling.json, later colleted as snapshot of the murmuration

curl https://sustance.github.io/bookmark.html -o /home/$USER/.w3m/bookmark.html 


# either select different file for each server by $HOST, or, create and edit index file on each server
#curl https://raw.githubusercontent.com/sustance/murmuration/refs/heads/main/public_html/index$HOST.php 
#     -o /home/$USER/public_html/index.php 
#curl https://raw.githubusercontent.com/sustance/murmuration/refs/heads/main/public_html/index$HOST.html 
#     -o /home/$USER/public_html/bin/index.html 


curl https://raw.githubusercontent.com/sustance/configs/refs/heads/main/mm -o /home/$USER/.local/bin/mm 

#Notes
# This is pulled by chron each day (optomistically at the same UTC time) on every computer in the swarm then 
# The computers are mostly set to their local time 
# as cron cannot do this timing perhaps maybe tolerat the time spread from HK to sanfrancisco
