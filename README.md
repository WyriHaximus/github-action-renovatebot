# github-action-renovatebot

Wrapper around renovatebot/github-action

## Usage

```yaml
- uses: WyriHaximus/github-action-renovatebot@main
  with:
    renovateAppToken: ${{ secrets.RENOVATE_TOKEN }}
    logLevel: info # Optional, defaults to 'info'
```

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
