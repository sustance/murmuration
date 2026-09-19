#!/usr/bin/env sh
#!/bin/sh
# murmururation.sh - Sourced from GitHub, MAKE IT EXECUTABLE
# AI collaboration links
# https://raw.githubusercontent.com/sustance/murmuration/refs/heads/main/README.md
# https://raw.githubusercontent.com/sustance/murmuration/refs/heads/main/murmuration.sh

# ==========================================
# COMMON COMMANDS (Runs on ALL servers)
# ==========================================
echo "[$(date)] Running common commands..."


curl https://raw.githubusercontent.com/sustance/murmuration/refs/heads/main/starling.py \
  -o /home/$(id -un)/.local/bin/starling.py
/home/$(id -un)/.local/bin/starling.py
echo "Done starling.py"

curl https://raw.githubusercontent.com/sustance/murmuration/refs/heads/main/mm \
  -o /home/$(id -un)/.local/bin/mm
echo "Done mm"

curl https://raw.githubusercontent.com/sustance/murmuration/refs/heads/main/hello.php \
  -o /home/$(id -un)/public_html/hello.php
echo "Done hello.php"

# ==========================================
# SERVER SPECIFIC COMMANDS
# ==========================================

homedir=$(eval echo ~"$(id -un)")

# Try standard location first, then the known non-standard one
if [ -r "$homedir/.murmuration_id" ]; then
    id_file="$homedir/.murmuration_id"
elif [ -r "$homedir/i/.murmuration_id" ]; then
    id_file="$homedir/i/.murmuration_id"
else
    echo "murmuration id file not found for $(id -un)" >&2
    exit 1
fi


if [ ! -r "$id_file" ]; then
    echo "murmuration id file missing/unreadable: $id_file" >&2
    exit 1
fi

MURMURATION=$(cat "$id_file")
echo "[$MURMURATION] Running machine specific commands...

# ==========================================
# PHYSICAL ACCESS. NO INTERACTION
# Longer term soverign replacemebt for github. meanwhile parellel function
# these machines are typically repurposed hubs like wifi routers with attached ssd storage. 
# They feature true 1G network and high resilience/recovery to power failure. 
# Local/low latency to terminal machines
# They lose their config on crash and need to seek or receive reconfiguration.
#    They will duplicate github functions for soverignity purposes
#    They will additionally be writable for bachup purposes

# they lose their config on crash and need to seek or receive  new config from github on power on.
if [ "$MURMURATION" = "3" ]; then
    echo "Running commands for Server '3'..."
    # (Asus_RT-AX3000/Asus_RT-AX3000.md) ASUSWRT-Merlin RT-AX58U_V2 3004.388.11_1-gnuton1 
    curl https://raw.githubusercontent.com/sustance/murmuration/refs/heads/main/test.txt \
       -o /home/$(id -un)/.local/bin/test.txt
fi


# ==========================================
# THESE ARE TERMINALS and/or TASK OPTOMISED
# ==========================================
# PHYSICAL ACCESS. KEYBOARD & SCREEN

if [ "$MURMURATION" = "4" ]; then
    echo "Running commands for Server '4'..."
    curl https://raw.githubusercontent.com/sustance/murmuration/refs/heads/main/test.txt \
       -o /home/$(id -un)/.local/bin/test.txt
    # May be dedicated to GPU and Video tasks
fi

if [ "$MURMURATION" = "2" ]; then
    echo "Running commands for Server '2'..."
    curl https://raw.githubusercontent.com/sustance/murmuration/refs/heads/main/test.txt \
       -o /home/$(id -un)/.local/bin/test.txt
fi

# ==========================================
# THESE MACHINES ARE THE DOWNSTREAM SWARM
# ==========================================
# NO ACCESS EXCEPT SSH WEB GOPHER

if [ "$MURMURATION" = "f" ]; then
    echo "Running commands for Server 'f'..."
    curl https://raw.githubusercontent.com/sustance/murmuration/refs/heads/main/f-index.html \
       -o /home/$(id -un)/public_html/index.html
    # 
fi

if [ "$MURMURATION" = "i" ]; then
    echo "Running commands for Server 'i'..."
    curl https://raw.githubusercontent.com/sustance/murmuration/refs/heads/main/i-index.html \
       -o /home/$(id -un)/public_html/index.html
    # web seems down
fi

# Skip j for now

if [ "$MURMURATION" = "n" ]; then
    echo "Running commands for Server 'n'..."
    curl https://raw.githubusercontent.com/sustance/murmuration/refs/heads/main/n-index.html \
       -o /home/$(id -un)/public_html/index.html
    # Seems limited service, no SSH for now
fi

if [ "$MURMURATION" = "o" ]; then
    echo "Running commands for Server 'o'..."
    curl https://raw.githubusercontent.com/sustance/murmuration/refs/heads/main/o-index.html \
       -o /home/$(id -un)/public_html/index.html
    # no PHP or HTML served on web  (local PHP ok)
fi

if [ "$MURMURATION" = "p" ]; then
    echo "Running commands for Server 'p'..."
    curl https://raw.githubusercontent.com/sustance/murmuration/refs/heads/main/p-index.html \
       -o /home/$(id -un)/public_html/index.html
    # NO PHP SERVICE (local PHP ok)
fi

if [ "$MURMURATION" = "r" ]; then
    echo "Running commands for Server 'r'..."
    curl https://raw.githubusercontent.com/sustance/murmuration/refs/heads/main/r-index.html \
       -o /home/$(id -un)/public_html/index.html
    # WORKING PHP SERVICE, CURRENT AND DEFAULT PAGE IS HTML
fi

if [ "$MURMURATION" = "t" ]; then
    echo "Running secondary commands for Server 't'..."
    curl https://raw.githubusercontent.com/sustance/murmuration/refs/heads/main/t-index.html \
       -o /home/$(id -un)/public_html/index.html
   # WORKING PHP SERVICE, BUT SSH CURRENTLY DOWN SO CANT CONFIGURE
fi

if [ "$MURMURATION" = "u" ]; then
    echo "Running secondary commands for Server 'u'..."
    curl https://raw.githubusercontent.com/sustance/murmuration/refs/heads/main/u-index.html \
       -o /home/$(id -un)/public_html/index.html
    # NO PHP SERVICE
fi

if [ "$MURMURATION" = "v" ]; then
    echo "Running secondary commands for Server 'v'..."
    curl https://raw.githubusercontent.com/sustance/murmuration/refs/heads/main/v-index.html \
       -o /home/$(id -un)/public_html/index.html
    # server completely down (common problem)
fi

if [ "$MURMURATION" = "x" ]; then
    echo "Running commands for Server 'X'..."
    curl https://raw.githubusercontent.com/sustance/murmuration/refs/heads/main/x-index.html \
       -o /home/$(id -un)/public_html/index.html
    # MOSTLY DOWN, ssh OK, No PHP, web. Lynx local only
fi


echo "[$(date)] Script completed."
