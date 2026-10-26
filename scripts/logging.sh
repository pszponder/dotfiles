#!/usr/bin/env bash

log_info() {
	printf '%s\n' "ℹ️ [INFO] $*"
}

log_success() {
	printf '%s\n' "✅ [OK] $*"
}

log_warn() {
	printf '%s\n' "⚠️ [WARN] $*"
}

log_error() {
	printf '%s\n' "❌ [ERROR] $*" >&2
}
