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
        uses: WyriHaximus/github-action-renovatebot@v0.1.0
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
- Docker binary source
- Post-upgrade tasks for git operations
- PHP package configuration via WyriHaximus/renovate-config
- Onboarding configuration with rebase checkbox

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
