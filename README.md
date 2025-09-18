# github-action-renovatebot

Wrapper around renovatebot/github-action

## Usage

### Basic Usage (Info Level)

```yaml
- uses: WyriHaximus/github-action-renovatebot@main
  with:
    renovateAppToken: ${{ secrets.RENOVATE_TOKEN }}
    logLevel: info # Optional, defaults to 'info'
```

### Debug Usage (Debug Level)

```yaml
- uses: WyriHaximus/github-action-renovatebot@main
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
