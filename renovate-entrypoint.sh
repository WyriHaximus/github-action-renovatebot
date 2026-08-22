#!/bin/sh
set -eu

git config --system --add safe.directory '*' 2>/dev/null || true

if id ubuntu >/dev/null 2>&1; then
  exec runuser -u ubuntu -- renovate "$@"
fi

exec renovate "$@"
