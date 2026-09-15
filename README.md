# murmuration

One mind, many machines.

Personal environment and tooling for a small swarm/fleet — three Debian laptops and a
dozen Linux/BSD servers — shared as a single public repository. No root
anywhere, no orchestrator, nothing pushed.

A murmuration is a flock of starlings: thousands of birds, no leader, no
central controller. Each bird follows the same simple rules, senses only its
immediate surroundings — and from that, coherent flock-scale behaviour
emerges. This repository works the same way. Every machine carries identical
code, reads its own local environment, and assembles itself.

## Philosophy: a swarm, not a fleet

A *fleet* is pushed: a central commander sends orders and uniformity is
imposed from above (Ansible, Salt, MDM). A *swarm* is pulled: each unit
follows a shared rulebook, senses local conditions, and self-assembles.

This project is unambiguously a swarm:

- **Pull, never push.** No orchestrator, no dashboard, no control channel.
Each machine wakes on cron, pulls this repo, and applies it locally. There
is no single point of failure because there is no point of control.
- **The repo is the machine; a host is a body.** Everything that makes a
machine *yours* lives here, not on its disk. A fresh mini# murmuration

One mind, many machines.

Personal environment and tooling for a small fleet — three Debian laptops and a
dozen Linux/BSD servers — shared as a single public repository. No root
anywhere, no orchestrator, nothing pushed.

A murmuration is a flock of starlings: thousands of birds, no leader, no
central controller. Each bird follows the same simple rules, senses only its
immediate surroundings — and from that, coherent flock-scale behaviour
emerges. This repository works the same way. Every machine carries identical
code, reads its own local environment, and assembles itself.

## Philosophy: a swarm, not a fleet

A *fleet* is pushed: a central commander sends orders and uniformity is
imposed from above (Ansible, Salt, MDM). A *swarm* is pulled: each unit
follows a shared rulebook, senses local conditions, and self-assembles.

This project is unambiguously a swarm:

- **Pull, never push.** No orchestrator, no dashboard, no control channel.
Each machine wakes on cron, pulls this repo, and applies it locally. There
is no single point of failure because there is no point of control.
- **The repo is the machine; a host is a body.** Everything that makes a
machine *yours* lives here, not on its disk. A fresh minimal install plus
one command reproduces your environment — that command *is* the backup.
- **Identical rules, local sensing.** Every host runs identical bytes, reads
its own hostname and hardware, and expresses a different configuration
from the same source. Differentiation emerges; it is never pushed.
- **Edit on GitHub; hosts only pull.** The single editor of record is the
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
sh -c "$(curl -fsSL https://raw.githubusercontent.com/USER/murmuration/main/bootstrap.sh)"
```

`bootstrap.sh` needs only `sh` plus one of `curl`, `wget`, FreeBSD `fetch`,
or `python3` (guaranteed), plus `tar`. If `git` is available it clones; it
falls back to fetching and extracting a tarball, and the updater handles both
paths. Then it runs `install.sh`, which links everything into `$HOME`.

New host? Create `hosts/<name>.sh` in the web editor, run the command above
on the machine, done.

## Layout

```javascript
murmuration/
├── README.md               # this file
├── LICENSE                 # MIT (or BSD-2)
├── bootstrap.sh            # the only file ever curl-piped
├── install.sh              # idempotent: (re)links everything into $HOME
├── lib/
│   ├── common.sh           # log, have(), die()
│   └── host.sh             # resolves hostname -> host profile
├── hosts/
│   ├── default.sh          # fallback profile (variables only)
│   └── <one file per host> # created via the GitHub web editor
├── bin/                    # portable tools, symlinked into ~/bin
│   ├── f-update            # git pull, or tarball refetch
│   ├── f-session           # tmux session builder (attach-or-build)
│   └── ...tasks...         # plain-text in, plain-text out
├── monitors/               # each prints plain text; run-all aggregates
│   ├── run-all.sh
│   └── load.sh battery.sh disk.sh ...
├── tmux/tmux.conf          # status line reads the monitor state file
├── shell/rc                # PATH, aliases; sourced from ~/.profile
├── cron/crontab.example    # installed per-host with: crontab cron/crontab.example
└── docs/philosophy.md      # the long version, for future-me
```

## Host profiles

The entire per-host difference is one small file of variables:

```sh
# hosts/lap1.sh
ROLE=laptop                 # laptop | server
MONITORS="load disk battery net"   # which monitors/run-all.sh runs
HAS_BATTERY=1
```

Scripts branch on these; they never contain per-host logic. The repo is the
whole flock's brain; each host reads its own page.

## Daily use

- **`work`** — attach to your main tmux session, building it if absent:
named windows for status, logs, and a shell. One window on a small screen
beats three terminals.
- **`tasks`** — fzf picker over the task scripts. From a GUI, the same
scripts appear as an Openbox pipe menu (two thin renderers, one source).
- **Monitors** run detached in a tmux session named `mon`, rebuilt nightly
so long-running processes never rot on never-rebooted machines.
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

- Edit on GitHub (web). Push nowhere else matters.
- Machines run `f-update` from cron every ~15 minutes; they pull, they
never commit.
- Edit on one machine only — the daily-driver laptop — or you will meet
merge conflicts that your memory will not thank you for.

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

Bootstrap, installer, host profiles, and the first monitors on the three
laptops. The structure is sized for the flock, but every directory must
earn its place — add the rest only when it is needed.mal install plus
one command reproduces your environment — that command *is* the backup.
- **Identical rules, local sensing.** Every host runs identical bytes, reads
its own hostname and hardware, and expresses a different configuration
from the same source. Differentiation emerges; it is never pushed.
- **Edit on GitHub; hosts only pull.** The single editor of record is the
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
sh -c "$(curl -fsSL https://raw.githubusercontent.com/USER/murmuration/main/bootstrap.sh)"
```

`bootstrap.sh` needs only `sh` plus one of `curl`, `wget`, FreeBSD `fetch`,
or `python3` (guaranteed), plus `tar`. If `git` is available it clones; it
falls back to fetching and extracting a tarball, and the updater handles both
paths. Then it runs `install.sh`, which links everything into `$HOME`.

New host? Create `hosts/<name>.sh` in the web editor, run the command above
on the machine, done.

## Layout

```javascript
murmuration/
├── README.md               # this file
├── LICENSE                 # MIT (or BSD-2)
├── bootstrap.sh            # the only file ever curl-piped
├── install.sh              # idempotent: (re)links everything into $HOME
├── lib/
│   ├── common.sh           # log, have(), die()
│   └── host.sh             # resolves hostname -> host profile
├── hosts/
│   ├── default.sh          # fallback profile (variables only)
│   └── <one file per host> # created via the GitHub web editor
├── .local/bin/                    # portable tools, symlinked into ~/bin
│   ├── f-update            # git pull, or tarball refetch
│   ├── f-session           # tmux session builder (attach-or-build)
│   └── ...tasks...         # plain-text in, plain-text out
├── monitors/               # each prints plain text; run-all aggregates
│   ├── run-all.sh
│   └── load.sh battery.sh disk.sh ...
├── tmux/tmux.conf          # status line reads the monitor state file
├── shell/rc                # PATH, aliases; sourced from ~/.profile
├── cron/crontab.example    # installed per-host with: crontab cron/crontab.example
└── docs/philosophy.md      # the long version, for future-me
```

## Host profiles

The entire per-host difference is one small file of variables:

```sh
# hosts/lap1.sh
ROLE=laptop                 # laptop | server
MONITORS="load disk battery net"   # which monitors/run-all.sh runs
HAS_BATTERY=1
```

Scripts branch on these; they never contain per-host logic. The repo is the
whole flock's brain; each host reads its own page.

## Daily use

- **`work`** — attach to your main tmux session, building it if absent:
named windows for status, logs, and a shell. One window on a small screen
beats three terminals.
- **`tasks`** — fzf picker over the task scripts. From a GUI, the same
scripts appear as an Openbox pipe menu (two thin renderers, one source).
- **Monitors** run detached in a tmux session named `mon`, rebuilt nightly
so long-running processes never rot on never-rebooted machines.
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

- Edit on GitHub (web). Push nowhere else matters.
- Machines run `f-update` from cron every ~15 minutes; they pull, they
never commit.
- Edit on one machine only — the daily-driver laptop — or you will meet
merge conflicts that your memory will not thank you for.

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

Bootstrap, installer, host profiles, and the first monitors on the three
laptops. The structure is sized for the flock, but every directory must
earn its place — add the rest only when it is needed.
