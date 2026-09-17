#!/usr/bin/env sh
#!/bin/sh
# murmururation.sh - Sourced from GitHub, MAKE IT EXECUTABLE

# ==========================================
# COMMON COMMANDS (Runs on ALL servers)
# ==========================================
echo "[$(date)] Running common commands..."

curl https://raw.githubusercontent.com/sustance/murmuration/refs/heads/main/starling.py \
  -o /home/$USER/.local/bin/starling.py
/home/$USER/.local/bin/starling.py

curl https://raw.githubusercontent.com/sustance/murmuration/refs/heads/main/mm \
  -o /home/$USER/.local/bin/murmuration.sh
  
curl https://raw.githubusercontent.com/sustance/murmuration/refs/heads/main/hello.php \
  -o /home/$USER/public_html/hello.php

# ==========================================
# SERVER SPECIFIC COMMANDS
# ==========================================

# Fail safely if MURMURATION isn't set
if [ -z "$MURMURATION" ]; then
    echo "Error: MURMURATION is not set!" >&2
    exit 1
fi



if [ "$MURMURATION" = "o" ]; then
    echo "Running commands for Server 'o'..."
    
fi

if [ "$MURMURATION" = "p" ]; then
    echo "Running commands for Server 'p'..."
    
fi

if [ "$MURMURATION" = "r" ]; then
    echo "Running commands for Server 'r'..."
    
fi

if [ "$MURMURATION" = "t" ]; then
    echo "Running secondary commands for Server 't'..."

fi

if [ "$MURMURATION" = "u" ]; then
    echo "Running secondary commands for Server 'u'..."

fi

if [ "$MURMURATION" = "v" ]; then
    echo "Running secondary commands for Server 'v'..."
    curl https://raw.githubusercontent.com/sustance/murmuration/refs/heads/main/u-index.html \
       -o /home/$USER/public_html/index.html
fi

if [ "$MURMURATION" = "x" ]; then
    echo "Running commands for Server 'X'..."
    curl https://raw.githubusercontent.com/sustance/murmuration/refs/heads/main/x-index.html \
       -o /home/$USER/public_html/index.html
fi

echo "[$(date)] Script completed."
