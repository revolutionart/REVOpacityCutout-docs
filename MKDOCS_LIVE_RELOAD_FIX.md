# MkDocs Live Reload Fix

This document records the known-good fix for MkDocs live reload in this repository.

## Problem Symptoms

- `mkdocs serve` starts and serves `http://127.0.0.1:8000/`
- local file edits do not trigger automatic browser refresh
- the site may appear to serve old content even after restarting

## Root Cause

In this environment, the safe working setup requires two things:

1. The Python package `livereload` must be installed.
2. MkDocs must be started with the explicit `--livereload` flag.

Without that combination, the server may build pages but fail to start the actual live-reload watch mode.

## Required Dependency

The project requirements must include:

```txt
livereload>=2.7
```

If needed, install dependencies with:

```powershell
pip install -r requirements.txt
```

Or install the missing package directly:

```powershell
pip install livereload
```

## Important Config Rule

Do not set `site_url` in `mkdocs.yml` for local development.

If `site_url` points to a GitHub Pages URL with a subpath, MkDocs will mount the local dev server under that subpath, which can break expected local behavior.

The current known-good config is that `site_url` is not present.

## Known-Good Recovery Procedure

Use this exact sequence.

### 1. Kill every running MkDocs instance

```powershell
Get-CimInstance Win32_Process |
  Where-Object { $_.CommandLine -match 'mkdocs.*serve' } |
  ForEach-Object { Stop-Process -Id $_.ProcessId -Force }
```

### 2. Make sure port 8000 is free

```powershell
Get-NetTCPConnection -LocalPort 8000 -State Listen -ErrorAction SilentlyContinue |
  ForEach-Object { Stop-Process -Id $_.OwningProcess -Force }
```

### 3. Start MkDocs with explicit live reload enabled

```powershell
cd j:\DEV_Blender_Addons\REVO_OpacityCutout_Docs
mkdocs serve --livereload -v
```

This is the important command. Do not replace it with plain `mkdocs serve` if live reload is broken.

## What Success Looks Like

When the fix is working, the MkDocs terminal should show lines like:

```txt
Watching paths for changes: 'docs', 'mkdocs.yml'
Serving on http://127.0.0.1:8000/
```

After that, editing a file under `docs/` or changing `mkdocs.yml` should trigger rebuilds automatically.

## Verification Checklist

If live reload still appears broken, check these in order:

1. `requirements.txt` still contains `livereload>=2.7`
2. `mkdocs.yml` does not contain `site_url`
3. no old MkDocs process is still bound to port `8000`
4. the server was started with `mkdocs serve --livereload -v`
5. the terminal shows `Watching paths for changes`

## One-Line Safe Start Command

If you just want the shortest reliable startup command:

```powershell
cd j:\DEV_Blender_Addons\REVO_OpacityCutout_Docs; mkdocs serve --livereload -v
```

## Summary

For this repository, the repeatable fix is:

- keep `site_url` out of `mkdocs.yml`
- keep `livereload` installed
- restart MkDocs cleanly
- always use `mkdocs serve --livereload -v` when live reload is important