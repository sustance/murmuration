#!/usr/bin/env sh
#!/bin/sh
# murmururation.sh - Sourced from GitHub, MAKE IT EXECUTABLE

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
id_file="$homedir/.murmuration_id"

if [ ! -r "$id_file" ]; then
    echo "murmuration id file missing/unreadable: $id_file" >&2
    exit 1
fi

MURMURATION=$(cat "$id_file")


if [ "$MURMURATION" = "o" ]; then
    echo "Running commands for Server 'o'..."
    curl https://raw.githubusercontent.com/sustance/murmuration/refs/heads/main/o-index.html \
       -o /home/$(id -un)/public_html/index.html
fi

if [ "$MURMURATION" = "p" ]; then
    echo "Running commands for Server 'p'..."
    curl https://raw.githubusercontent.com/sustance/murmuration/refs/heads/main/p-index.html \
       -o /home/$(id -un)/public_html/index.html
fi

if [ "$MURMURATION" = "r" ]; then
    echo "Running commands for Server 'r'..."
    curl https://raw.githubusercontent.com/sustance/murmuration/refs/heads/main/r-index.html \
       -o /home/$(id -un)/public_html/index.html
fi

if [ "$MURMURATION" = "t" ]; then
    echo "Running secondary commands for Server 't'..."
    curl https://raw.githubusercontent.com/sustance/murmuration/refs/heads/main/t-index.html \
       -o /home/$(id -un)/public_html/index.html
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
fi

if [ "$MURMURATION" = "x" ]; then
    echo "Running commands for Server 'X'..."
    curl https://raw.githubusercontent.com/sustance/murmuration/refs/heads/main/x-index.html \
       -o /home/$(id -un)/public_html/index.html
fi


echo "[$(date)] Script completed."
