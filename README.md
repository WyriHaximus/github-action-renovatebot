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

[MIT](LICENSE)
