#!/bin/sh
set -eu

git config --system --add safe.directory '*' 2>/dev/null || true

action_path="${RENOVATE_ACTION_PATH:-$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)}"
wrapper_bin="/usr/local/lib/renovate-action/bin"
wrapper_src="${action_path}/composer-docker-wrapper.sh"

if [ -f "$wrapper_src" ]; then
  mkdir -p "$wrapper_bin"
  install -m 0755 "$wrapper_src" "${wrapper_bin}/composer"
  export RENOVATE_COMPOSER_WRAPPER_BIN="$wrapper_bin"
  export PATH="${wrapper_bin}:${PATH}"
fi

if [ -S /var/run/docker.sock ]; then
  chmod 666 /var/run/docker.sock
fi

if id ubuntu >/dev/null 2>&1; then
  exec runuser -u ubuntu -- env \
    PATH="$PATH" \
    LOG_LEVEL="${LOG_LEVEL:-}" \
    RENOVATE_COMPOSER_WRAPPER_BIN="${RENOVATE_COMPOSER_WRAPPER_BIN:-}" \
    renovate "$@"
fi

exec renovate "$@"
