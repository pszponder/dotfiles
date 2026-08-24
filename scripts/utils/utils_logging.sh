#!/bin/sh
# Shared logging helpers for scripts/. Keep in sync with
# home/.chezmoitemplates/shell/logging.sh.tmpl.

log_info() {
  printf '%b\n' "ℹ️ [INFO] $*"
}

log_success() {
  printf '%b\n' "✅ [OK] $*"
}

log_warn() {
  printf '%b\n' "⚠️ [WARN] $*"
}

log_error() {
  printf '%b\n' "❌ [ERROR] $*" >&2
}
