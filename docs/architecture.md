# Architecture and Python migration

## Current boundary

The current Bash `asurf` command is an integration layer. It owns the public
workflow names, session selection, path safety checks, and destructive-operation
confirmations. It delegates specialised work to the mature tools already in this
repository:

```text
asurf session / ingest / review / annotate / publish
       |          |        |        |          |
       |        msurf     mpx      anotr     msurf
       |          |        |        |          |
       +--- session manifest and workspace convention ---+
```

This is deliberately not a plugin API yet. A plugin API should follow proven
data contracts, rather than freezing guesses made before real coaching workflows
have been exercised.

## Why migrate the orchestration layer to Python

Python is a good next implementation language for Asurf once the session CLI
has been used enough to confirm its vocabulary. It gives the project typed and
versioned records, robust validation, reliable filesystem operations, structured
testing, report generation, and a conventional extension-discovery mechanism.
Those matter when one athlete participates in many sessions and one session has
many athletes.

It should *not* replace every component:

- Keep mpv configuration and Lua scripts as mpv-native extensions.
- Keep short wrappers for system tools such as `rclone`, `udisksctl`, and mpv.
- Preserve `msurf` and `anotr` commands during migration as compatibility
  adapters; do not force users to change a working capture-day workflow.

## Migration sequence

1. Exercise the Bash session manifests and record which fields coaching tasks
   actually share.
2. Add `pyproject.toml` and a Python `asurf` package using only the standard
   library initially (`argparse`, `dataclasses`, `pathlib`, `json`, and
   `subprocess`). Retain the installed Bash command as `asurf-legacy` during the
   transition.
3. Version a structured session file, preferably JSON at first for zero
   dependencies. It should represent `session`, `athletes`, `media`,
   `analysis`, `reports`, `destinations`, and extension-owned namespaced data.
4. Implement Python adapters for import, review, annotation, reporting, and
   publication. Each adapter receives a validated session object and emits a
   plan before changing files.
5. Introduce entry-point plugins only after two or more real extensions need
   the same lifecycle. Plugins should declare their required capabilities and
   own only a namespaced part of the session record.
6. Port proven `msurf` behaviour incrementally with fixture tests. Preserve its
   CLI aliases until the Python equivalent has passed real SD-card workflows.

## Data model direction

Use a session as the primary record, with athlete references as a list. This
supports both views without duplicating media:

```json
{
  "schema_version": 1,
  "id": "2026-09-12-club-training",
  "athletes": [{"id": "alice"}, {"id": "bob"}],
  "paths": {"media": "media", "analysis": "analysis", "reports": "reports"},
  "extensions": {}
}
```

An athlete index can later point to sessions; do not make it a second source of
truth. Keep large video files in the filesystem and store only paths, hashes,
timestamps, tags, and derived-analysis references in the structured record.
