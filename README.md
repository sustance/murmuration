# murmuration
---
name: murmuration
entry point file: murmuration.sh
execution model: cron-pulled, no push
host-identity: ~/.local/bin/murmuration_id
objective: manage existing computers as a simple swarm

code:
  - Sh  (plus Bash)
  - Python
  - YAML
  - PHP
  - 
geography of fixed servers:
  - Hong Kong
  - East Asia
  - North America
  - Europe Mostly DE
  - 
common roaming of the users laptop:
  - Hong Kong
  - East Asia
  - Western Eupope
  - 
sophistication:
  - currently primordial, limited error checking ok for now
  - concentrating on assigning code flows /roles to machines
  - still determining logical functional groupings
    
data-hub:
  - Initially github
  - Aspiration, the system is hub-less
...

One mind, many machines.

Personal environment and tooling for a small swarm/fleet — three Debian 
laptops, some re-puposed routers with attached storage and a
dozen Linux/BSD servers — shared as a single public repository. No root
anywhere, no orchestrator, nothing pushed.

A murmuration is a flock of starlings: thousands of birds, no leader, no
central controller. Each bird follows the same simple rules, senses only its
immediate surroundings — and from that, coherent flock-scale behaviour
emerges. This repository works the same way. Every machine carries identical
code, reads its own local environment, and assembles itself.

## Philosophy: a swarm, not a fleet

- **Pull, never push.** No orchestrator, no dashboard, no control channel.
Each machine wakes on cron, pulls this repo, and applies it locally. There
is no single point of failure because there is no point of control.
- **The repo is the machine; a host is a body.** Everything that makes a
machine *yours* lives here, not on its disk. A fresh mini# murmuration

## How a host joins

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/USER/murmuration/main/murmuration.sh)"
```

`murmuration.sh` needs only `sh` plus`curl`, FreeBSD `fetch`, or `python3`, plus `tar`. 

## Layout

```
murmuration/
├── README.md               # this file
├── LICENSE                 # MIT (or BSD-2)
├── murmuration.sh            # the only file ever curl-piped
├── .local/bin/             # portable tools, symlinked into ~/bin
├── tmux/tmux.conf          # status line reads the monitor state file
├── cron/crontab.example    # installed per-host with: crontab cron/crontab.example
```

## Host profiles

This project is in public domain and I don't want to expose real identities so i 
declared in murmuration_id by a my own name system.

Some hosts have user accounts sub directoried by username first letter therefore 
id-file fallback (.murmuration_id vs i/.murmuration_id). 

The objective later is to segment the servers into peer groups based on latency/reliability 
and other things and batch process.
For now each machine is iterated separately an inefficiently. but in time it will be resolved but probably needs some detailed statistics collection first to be rational.

## Checking and control
This is a single simple user project. me or anyone who copies it. 
All errors will show up in starling.py output. 
At this stage there is no plan past making starling.py more informative 

## Publishing use
- Each starling and the whole murmuration publishes a complete presence on
  Web, Gemini, Gopher and other networks.
- The murmuration is tasked to provide stability and Latency advantages over
  the relative instability of the individual starling nodes.
- Tests for unresponsive or high latency nodes and systems
  to provide auto-repair need to be develped.

## Daily use

- **`work`** — attach to your main tmux session, building it if absent:
named windows for status, logs, and a shell. One window on a small screen
beats three terminals.
- **`tasks`** — fzf picker over the task scripts. From a GUI, the same
scripts appear as an Openbox pipe menu (two thin renderers, one source).
- **Monitors** run detached in a tmux session named `mon`, rebuilt nightly
so long-running processes never rot on never-rebooted machines.

Example of ping times from London 
Servers span from SanFrancisco to HK
```
Sta-RTT------Svr-----2d-hrs--60d-hrs
✓   8.9ms    [g]      0.0      0.0 
✓   9.61ms   [u]      0.0      0.0 
✓   10.34ms  [r]      0.0      0.0  
✓   18.41ms  [o]      0.0      0.0 
✓   19.78ms  [j]      0.0      0.0   
✓   20.76ms  [f]      0.0      0.0   
✓   21.25ms  [i]      0.0      0.0  
✓   21.29ms  [t]      0.0      0.0   
✓   21.47ms  [b]      0.0      0.0  
✓   38.03ms  [p]      0.0      0.0   
✓   38.58ms  [e]      0.0      0.0  
✓   75.1ms   [c]      0.0      0.0   
✓   79.93ms  [d]      0.0      0.0  
✓   80.58ms  [n]      0.0      0.0   
✓   87.76ms  [v]      0.0      0.0   
```

- **Glance data** (battery, load) renders in the tmux status line from the
monitor state file — always visible, zero keypresses.

## Information tiers

Information is tiered by how it should reach you — this is what makes a
small screen a non-issue:

| Tier | What | Medium |
| --- | --- | --- |
| Glance | Numbers: battery, load, disk | tmux `status-right`, always visible |
| Watch | Streams: logs, journals | detached `mon` session, one window per stream |
| Alert | Conditions: disk >90%, service down, battery <20% | cron writes a flag the status line shows; `notify-send` on laptops |

> You should not watch monitors; monitors should tell you when to look.

Every alert automated deletes a window you would otherwise keep open.

## Sync discipline

- Edit on GitHub (web) for now. Push nowhere else matters.
- Machines run cron every day; they pull, they never commit.

## Why it looks like this

This repo grew out of an Openbox `menu.xml` that had become a memory
crutch: dozens of entries whose only purpose was storing commands that were
hard to remember. The escape path, in order:

1. **Tasks are scripts, not menu entries.** Plain text in, plain text out;
the menu (or fzf, or a keybind) is just a renderer over them.
2. **The session is the unit, not the task.** Things needed every session
belong in a built tmux session, not behind a selector.
3. **Frequency picks the interface.** Every session → builder script;
occasionally → fzf; rarely → shell history. One medium serving all three
frequencies is what made the original menu bloat.
4. **A terminal is a portal.** One fullscreen local tmux; remote hosts are
windows inside it (`ssh -t host tmux new-session -A -s main`). Every
host behaves identically because every host runs these same bytes.
5. **Which led here.** The three laptops wanted identical config, the
servers wanted the same monitoring without root and without bash, and
the only sustainable answer was one repo, pulled by all, edited in one
place.

## Status

murmuration installer, host profiles, and the first monitors on the three
laptops. The structure is sized for the flock, but every directory must
earn its place.
- **Identical rules, local sensing.** Every host runs identical bytes, reads
its own hostname and hardware, and expresses a different configuration
from the same source. Differentiation emerges; it is never pushed.
- **Edit on GitHub (for now); hosts only pull.** The single editor of record is the
GitHub web UI. Machines never commit. An edit reaches every host within
about 15 minutes via cron — no SSH required.

This framing is load-bearing, not decorative: whenever a future design
question arises (should machines report back? should there be a control
panel? should a host push its state?), the answer is *no* — those things
convert a swarm back into a fleet and reintroduce the central point of
failure this design exists to avoid.

## Hard rules

1. **POSIX sh only.** `#!/bin/sh`, safe for dash and BSD sh alike. No
bashisms. Python 3 is the escape hatch — it exists on every host.
2. **No root, ever.** Everything installs under `$HOME`.
3. **Per-host differences live only in `hosts/<name>.sh`.** Variables, not
logic. Everything else is identical bytes on every machine.
4. **Task scripts print plain text.** Menus, Openbox XML, tmux status lines
and alerts are *renderers* — rendering is always a separate layer, never
the task's job. XML lives in exactly one place.
5. **Sessions are built, never grown.** Every tmux session is created by an
idempotent script, safe to re-run from cron. If you cannot rebuild it,
it is already technical debt. "Always on" means restarts are automated
and invisible, not that nothing ever restarts.
6. **Nothing secret in this repo.** Public, so hosts need no credentials to
pull. If a host's real name is sensitive, give its profile an alias.

## How a host joins

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/USER/murmuration/main/murmuration.sh)"
```

`murmuration.sh` needs only `sh` plus one of `curl`, FreeBSD `fetch`, plus `tar`. 
Possibly if `git` is available it clones; it MAY fall back to fetching and extracting a tarball, 
and the updater handles bot paths. Then it runs `install.sh`, which links everything into `$HOME`.

## Source of truth
- At inception the core assets are stored on github.
- Plan is to duplicated this across starling machines to gain sovereignty.
- Eventually the whole system seeks to become soverign.

## Transparency.
 - This system operates over sensitive borders and should be transparent and open to inspection. secure shell is to be regared as inspectable and not attempt to conceal anything
