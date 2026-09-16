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
  -o /home/identity2/.local/bin/murmuration.sh

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
    echo "No commands at this time 'X'..."
    # Specific commands for 'x'

fi

if [ "$MURMURATION" = "u" ]; then
    echo "Running commands for Server 'u'..."
    
fi

if [ "$MURMURATION" = "g" ]; then
    echo "Running secondary commands for Server 'g'..."

fi

echo "[$(date)] Script completed."
