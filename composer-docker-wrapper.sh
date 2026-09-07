#!/bin/sh
set -eu

WRAPPER_BIN="${RENOVATE_COMPOSER_WRAPPER_BIN:-/usr/local/lib/renovate-action/bin}"
PHP_IMAGE="ghcr.io/wyrihaximusnet/php"

debug_log() {
  [ "${LOG_LEVEL:-}" = "debug" ] || return 0
  echo "composer-docker-wrapper: $*" >&2
}

docker_available() {
  command -v docker >/dev/null 2>&1 && [ -S /var/run/docker.sock ]
}

has_make_run_target() {
  command -v make >/dev/null 2>&1 || return 1
  grep -E '^run[[:space:]]*:' Makefile makefile 2>/dev/null | grep -q .
}

containerbase_composer() {
  path_without_wrapper=$(printf '%s\n' "$PATH" | tr ':' '\n' | grep -Fxv "$WRAPPER_BIN" | tr '\n' ':' | sed 's/:$//')
  PATH="$path_without_wrapper" command -v composer 2>/dev/null || true
}

run_via_make() {
  debug_log "routing via make run"
  RENOVATE_COMPOSER_WRAPPER_ACTIVE=1 exec make run -- composer "$@"
}

run_via_docker() {
  debug_log "routing via docker"
  php_version=$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;' 2>/dev/null || echo 8.5)
  composer_cache="${COMPOSER_CACHE_DIR:-${HOME}/.composer/cache}"
  workdir=$(pwd)

  RENOVATE_COMPOSER_WRAPPER_ACTIVE=1 exec docker run --rm -i \
    --cap-drop=ALL \
    --security-opt=no-new-privileges=true \
    --user="$(id -u):$(id -g)" \
    -e "OTEL_PHP_FIBERS_ENABLED=${OTEL_PHP_FIBERS_ENABLED:-true}" \
    -e "COMPOSER_IGNORE_PLATFORM_REQS=${COMPOSER_IGNORE_PLATFORM_REQS:-1}" \
    -v "${workdir}:${workdir}" \
    -w "${workdir}" \
    -v "${workdir}/.git:${workdir}/.git:ro" \
    -v "${composer_cache}:/opt/app/.composer/cache" \
    --ulimit nofile=1000000 \
    "${PHP_IMAGE}:${php_version}-nts-alpine-slim-dev" \
    composer "$@"
}

run_via_containerbase() {
  debug_log "routing via containerbase"
  composer_bin=$(containerbase_composer)
  if [ -n "$composer_bin" ] && [ -x "$composer_bin" ]; then
    exec "$composer_bin" "$@"
  fi

  echo "composer-docker-wrapper: no composer backend available" >&2
  exit 127
}

if [ "${RENOVATE_COMPOSER_WRAPPER_ACTIVE:-}" = "1" ]; then
  debug_log "re-entry guard active"
  run_via_containerbase "$@"
fi

if docker_available && has_make_run_target; then
  run_via_make "$@"
fi

if docker_available; then
  run_via_docker "$@"
fi

run_via_containerbase "$@"
