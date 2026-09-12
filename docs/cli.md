# Asurf CLI guide

## The coaching loop

Asurf models a local coaching loop rather than a monolithic video application:

```text
session -> ingest -> review -> annotate -> report -> publish -> repeat
```

The first four stages are available now. `publish` deliberately requires
`--yes`, because it calls `rclone sync`, whose normal semantics can remove
destination-only files. Reports are a workspace convention for now: place
Markdown, stills, or exported material in the session's `reports/` directory.

## Setup

Install to a user-owned prefix:

```bash
make install PREFIX="$HOME/.local"
make install-mpx-cfg
export PATH="$HOME/.local/bin:$PATH"
```

`install-mpx-cfg` adds only missing bundled mpv profile files; it preserves
local changes to an existing profile.

Then initialise a local configuration. It is intentionally outside the Git
checkout and is shared with `msurf` at `~/.config/asurf/env`.

```bash
asurf init --workspace "$HOME/asurf-work"
```

Edit that file to select the SD-card mount discovery pattern and any rclone
remotes. Its default `rgx_sdx` intentionally matches no card; set it to the
mount-directory pattern for your camera card, or pass `asurf ingest --source
PATH`. Do not commit credentials or personal destination paths to this
repository.

## Session workflow

```bash
asurf session create 2026-09-12-club-training --athletes alice,bob
asurf session status
asurf ingest --dry-run
asurf ingest --source /run/media/user/CARD
asurf sort --dry-run
asurf sort --yes
asurf review --session 2026-09-12-club-training
asurf annotate /path/to/clip.mp4
```

By default a session uses `sessions/NAME` relative to `rx`; override this at
creation with `--dir 2026/club/training-01`. Session names are deliberately
restricted to safe filename characters. A manifest is stored under
`$XDG_DATA_HOME/asurf/sessions` (normally `~/.local/share/asurf/sessions`) and
the current session is stored separately. Both are simple `key=value` files
designed to be reviewable and portable.

## Capability tiers

| Tier | Needed for | Dependencies |
| --- | --- | --- |
| Core | sessions and directory conventions | Bash, core Unix utilities |
| Review | frame stepping and playback | mpv plus `make install-mpx-cfg` |
| Ingest | SD import and archive | udisks2, rsync |
| Annotation | visual and written notes | flameshot, Neovim |
| Distribution | remote delivery | rclone |
| Workspace | personalised desktop layout | nnn and optionally i3/X11 helpers |

Run `asurf doctor` after installation. Missing optional tools do not prevent a
user from using the core commands.

## Extension boundary

Keep an extension narrow and task-shaped. It should consume a session directory
and write its output inside one of `media/`, `analysis/`, or `reports/`; it
should not need to know whether a session has one athlete or many. Athlete
identity can initially be represented by the manifest's `athletes` field and
by the existing `anotr` tags. Once repeated workflows prove which fields need
querying together, introduce a versioned structured record format.

Near-term work: add `asurf report` from a supplied Markdown template, a
non-destructive export command, shell completion for the top-level CLI, and
fixtures that exercise manifest resolution and media operations without real
cards or remotes.
