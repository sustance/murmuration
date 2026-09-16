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

if [ "$MURMURATION" = "x" ]; then
    echo "Running commands for Server 'X'..."
    curl https://raw.githubusercontent.com/sustance/murmuration/refs/heads/main/x-index.html \
       -o /home/$USER/public_html/index.html
    # Specific commands for 'x'

fi

if [ "$MURMURATION" = "u" ]; then
    echo "Running commands for Server 'u'..."
    
fi

if [ "$MURMURATION" = "g" ]; then
    echo "Running secondary commands for Server 'g'..."

fi

echo "[$(date)] Script completed."
