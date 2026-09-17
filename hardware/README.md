Good use case — old hardware with a decent iGPU is genuinely well-suited to becoming 
a dedicated transcode node, and the "don't lock myself out" constraint is the right 
thing to design around first. 

I'll give you a script, but it's built conservative-by-default (dry-run unless you 
explicitly confirm) specifically because it's remote.

Reality check on the two biggest levers

Before the script — two things matter more than anything else, so I'll flag them up front:

Codec/encoder choice dwarfs OS-level tuning. 
If ffmpeg is currently using software libx264/libx265 on the CPU, switching to hardware 
encode via VAAPI (Intel) or QSV will very likely cut power draw and heat during the 
actual job by somewhere in the 40–70% range, often while also finishing faster. 
This is almost certainly your biggest win — bigger than every idle-power tweak below combined.
OS/idle tuning (disabling radios, services, GUI, USB/PCIe power management) 
typically nets 15–30% off idle draw on a laptop that hasn't been tuned — a few watts, 
not a game-changer, but free and cumulative, and it directly reduces baseline heat 
when the machine is between jobs.

I can't give you exact watts for your specific Huawei model without measuring — that's 
what the monitor script is for. Treat the numbers above as ballpark expectations to validate, 
not promises.

The script

I've split it into a tuning script (safety-gated, dry-run by default) and a monitor script (before/after measurement).

How to use them
Copy both to the laptop, then run sudo ./pare-down-ffmpeg-node.sh --status first — changes 
nothing, just reports current state.
Run sudo ./monitor-node.sh --log a few times over an hour to get a baseline CSV row (idle, 
and once during a real ffmpeg job).
Run sudo ./pare-down-ffmpeg-node.sh --dry-run and read the "WOULD DO" output line by line — 
nothing is applied yet.
Only when you're happy: sudo ./pare-down-ffmpeg-node.sh --apply. Firewall is left 
out unless you add --with-firewall, and even then it self-disables after 5 minutes unless 
you manually cancel the revert (atq / atrm <id>) once you've confirmed you can still SSH in.
Re-run monitor-node.sh --log after, at idle and during a job, and diff the CSV.

It assumes Debian/Ubuntu with systemd + ufw + apt. If it's Fedora/RHEL-based, tell me and 
I'll swap in dnf/firewalld equivalents.

Things that can't be safely scripted — do these by hand, once
BIOS: "Restore on AC power loss" → ON. If mains power blips, the laptop must boot itself 
back up unattended. 
This is the single most important physical check for a headless remote box and can only 
be set in firmware.
A smart plug (or similar remote-switchable power) on the charger. 
Laptops have no IPMI/iDRAC equivalent. If the OS ever wedges completely, a remote power-cycle 
is your only recovery path — the network self-heal in the script can't fix a hung kernel, 
only a dead network stack.
Check for Huawei-specific battery charge-threshold support: 
cat /sys/class/power_supply/BAT0/charge_control_end_threshold (needs the huawei-wmi kernel 
module). If present, cap it around 60–80% — running a laptop plugged in 24/7 at 100% charge 
shortens battery life and adds heat from the charge circuit for no benefit on a device that 
never runs on battery anyway.
Discrete GPU disable in BIOS, if your model has a dGPU option (some MateBooks let you force 
integrated-only). 
If ffmpeg only needs the iGPU's Quick Sync block, a discrete GPU sitting idle-but-powered can 
be several extra watts for nothing — worth checking once via lspci | grep -i vga and 
nvidia-smi (if applicable).
Physical dust/vent cleaning. On old hardware this affects thermal throttling more than 
almost any software setting, and throttling under a sustained encode job will hurt both 
speed and efficiency.
Confirm the actual SSH path (wired vs Wi-Fi) before running --apply. The script tries to 
detect this automatically and won't touch Wi-Fi if it's your route, but a manual ip route 
check first costs nothing.
On the RAM upgrade

Before buying anything, check whether you're actually RAM-constrained: run free -h and 
cat /proc/pressure/memory during a real transcode job. 
If swap usage is near zero and PSI shows near-zero pressure, more RAM likely won't move 
the needle — ffmpeg's working set for a single transcode (even 4K) is usually a few 
hundred MB to low GB, not something slow secondhand DDR3/4 will bottleneck. 
RAM upgrades pay off mainly if you plan to run multiple concurrent jobs or heavy filters 
(denoise, interpolation), or if the monitor data shows real swap thrashing today. 
If it does, even slow RAM beats swapping to disk, but zram (compressed RAM-backed swap, 
cheap to add via the script's TLP step's neighbor — ask if you want it added) is often a 
bigger win than a modest RAM upgrade for a box this size.

Before the script — two things matter more than anything else, so I'll flag them up front:

Codec/encoder choice dwarfs OS-level tuning. If ffmpeg is currently using software 
libx264/libx265 on the CPU, switching to hardware encode via VAAPI (Intel) or QSV 
will very likely cut power draw and heat during the actual job by somewhere in the 
40–70% range, often while also finishing faster. This is almost certainly your biggest 
win — bigger than every idle-power tweak below combined.
OS/idle tuning (disabling radios, services, GUI, USB/PCIe power management) typically 
nets 15–30% off idle draw on a laptop that hasn't been tuned — a few watts, not a 
game-changer, but free and cumulative, and it directly reduces baseline heat when 
the machine is between jobs.

I can't give you exact watts for your specific Huawei model without measuring — 
that's what the monitor script is for. Treat the numbers above as ballpark expectations 
to validate, not promises.

The script

I've split it into a tuning script (safety-gated, dry-run by default) and a monitor 
script (before/after measurement).

How to use them
Copy both to the laptop, then run sudo ./pare-down-ffmpeg-node.sh --status first — 
changes nothing, just reports current state.
Run sudo ./monitor-node.sh --log a few times over an hour to get a baseline CSV 
row (idle, and once during a real ffmpeg job).
Run sudo ./pare-down-ffmpeg-node.sh --dry-run and read the "WOULD DO" output 
line by line — nothing is applied yet.
Only when you're happy: sudo ./pare-down-ffmpeg-node.sh --apply. Firewall is 
left out unless you add --with-firewall, and even then it self-disables after 
5 minutes unless you manually cancel the revert (atq / atrm <id>) once you've 
confirmed you can still SSH in.
Re-run monitor-node.sh --log after, at idle and during a job, and diff the CSV.

It assumes Debian/Ubuntu with systemd + ufw + apt. If it's Fedora/RHEL-based, 
tell me and I'll swap in dnf/firewalld equivalents.

Things that can't be safely scripted — do these by hand, once
BIOS: "Restore on AC power loss" → ON. If mains power blips, the laptop must boot 
itself back up unattended. 
This is the single most important physical check for a headless remote box 
and can only be set in firmware.
A smart plug (or similar remote-switchable power) on the charger. 
Laptops have no IPMI/iDRAC equivalent. 
If the OS ever wedges completely, a remote power-cycle is your only recovery 
path — the network self-heal in the script can't fix a hung kernel, only a 
dead network stack.
Check for Huawei-specific battery charge-threshold support: 
cat /sys/class/power_supply/BAT0/charge_control_end_threshold (needs the huawei-wmi 
kernel module). If present, cap it around 60–80% — running a laptop plugged in 24/7 
at 100% charge shortens battery life and adds heat from the charge circuit for no 
benefit on a device that never runs on battery anyway.
Discrete GPU disable in BIOS, if your model has a dGPU option (some MateBooks let 
you force integrated-only). If ffmpeg only needs the iGPU's Quick Sync block, a 
discrete GPU sitting idle-but-powered can be several extra watts for nothing — 
worth checking once via lspci | grep -i vga and nvidia-smi (if applicable).
Physical dust/vent cleaning. On old hardware this affects thermal throttling 
more than almost any software setting, and throttling under a sustained encode 
job will hurt both speed and efficiency.
Confirm the actual SSH path (wired vs Wi-Fi) before running --apply. 
The script tries to detect this automatically and won't touch Wi-Fi if it's your 
route, but a manual ip route check first costs nothing.
On the RAM upgrade

Before buying anything, check whether you're actually RAM-constrained: run free -h and cat /proc/pressure/memory during a real transcode job. If swap usage is near zero and PSI shows near-zero pressure, more RAM likely won't move the needle — ffmpeg's working set for a single transcode (even 4K) is usually a few hundred MB to low GB, not something slow secondhand DDR3/4 will bottleneck. RAM upgrades pay off mainly if you plan to run multiple concurrent jobs or heavy filters (denoise, interpolation), or if the monitor data shows real swap thrashing today. If it does, even slow RAM beats swapping to disk, but zram (compressed RAM-backed swap, cheap to add via the script's TLP step's neighbor — ask if you want it added) is often a bigger win than a modest RAM upgrade for a box this size.
