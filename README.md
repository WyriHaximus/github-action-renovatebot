# github-action-renovatebot

Wrapper around [`renovatebot/github-action`](https://github.com/renovatebot/github-action) with personal preferences for self hosting

## Usage

### Complete Workflow Example

Here's a complete GitHub Actions workflow that uses this action:

```yaml
name: Renovate

on:
  schedule:
    - cron: "0 6-22/2 * * 1-5"  # Every 2 hours, 6am-10pm, weekdays
    - cron: "0 12-23/2 * * 0,6"  # Every 2 hours, 12pm-11pm, weekends
  push:
    branches:
      - 'main'
  issues:
    types:
      - edited

concurrency:
  group: 'renovate'
  cancel-in-progress: true

jobs:
  renovate:
    name: Renovate
    runs-on: ubuntu-latest
    steps:
      - name: Generate App Token for Renovate
        uses: actions/create-github-app-token@v2.1.4
        id: app-token
        with:
          app-id: ${{ secrets.RENOVATE_BOT_CLIENT_ID }}
          private-key: ${{ secrets.RENOVATE_BOT_PRIVATE_KEY }}
          owner: ${{ github.repository_owner }}
      - name: Renovate
        uses: WyriHaximus/github-action-renovatebot@v0.9.0
        with:
          renovateAppToken: ${{ steps.app-token.outputs.token }}
```

### Debug Usage (Debug Level)

For debugging or troubleshooting Renovate issues:

```yaml
name: Renovate Debug
on:
  workflow_dispatch:  # Manual trigger for debugging
jobs:
  renovate:
    runs-on: ubuntu-latest
    steps:
      - name: Renovate with Debug Logging
        uses: WyriHaximus/github-action-renovatebot@main
        with:
          renovateAppToken: ${{ secrets.RENOVATE_TOKEN }}
          logLevel: debug # Enables detailed JSON logging
```

### Log Level Differences

- **`info`** (default): Provides standard logging output in plain text format, showing key operations and results
- **`debug`**: Enables verbose logging in JSON format, providing detailed information about Renovate's internal processes, API calls, and decision-making logic. Useful for troubleshooting issues or understanding Renovate behavior in detail

## Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `renovateAppToken` | Renovate app token for authentication | Yes | |
| `logLevel` | Log level for Renovate execution | No | `info` |

## Features

This action provides a pre-configured Renovate setup with:

- Autodiscovery enabled
- Plugin and script execution allowed
- Install binary source (containerbase `install-tool` in the Renovate image)
- Docker socket mounted for post-upgrade `make after-renovate` targets that run QA tooling in WyriHaximus PHP containers
- `COMPOSER_IGNORE_PLATFORM_REQS` injected for Composer child processes
- Post-upgrade tasks for `make after-renovate || true`, `git add --all`, and `git reset HEAD`
- PHP package configuration via WyriHaximus/renovate-config
- Onboarding configuration with rebase checkbox

## Post-upgrade tasks

After dependency updates, Renovate runs these commands on each branch:

1. `make after-renovate || true` — run project-specific post-upgrade logic; `|| true` prevents a failing target from blocking the rest of the workflow
2. `git add --all` — stage generated changes
3. `git reset HEAD` — unstage everything so Renovate can commit only the files it changed

Shell execution is enabled via `RENOVATE_ALLOW_SHELL_EXECUTOR_FOR_POST_UPGRADE_COMMANDS`, so operators like `||` work in the command string.

### Allowed command regex escaping

Self-hosted Renovate requires every post-upgrade command to match a pattern in `RENOVATE_ALLOWED_COMMANDS`. Those patterns are regular expressions, not shell commands.

For `make after-renovate || true`, the pipe characters must be escaped in the regex. Unescaped `||` is regex alternation and matches far more than intended.

| Layer | Value |
|-------|-------|
| Shell command (`RENOVATE_POST_UPGRADE_TASKS`) | `make after-renovate \|\| true` |
| Regex pattern (what Renovate matches against) | `^make after-renovate \|\| true$` |
| In `action.yaml` (`RENOVATE_ALLOWED_COMMANDS`) | `"^make after-renovate \\\\|\\\\| true$"` |

The post-upgrade task uses literal `||`. The allowed-command entry needs `\\\\|\\\\|` in YAML so Renovate receives `\|\|` in the regex.

## License

MIT License

Copyright (c) 2025 Cees-Jan Kiewiet

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
