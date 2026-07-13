#!/usr/bin/env bash
# Logging utility functions with colors

# ANSI color codes
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
CYAN="\033[36m"
RESET="\033[0m"

# Info message
log_info() {
  echo -e "${BLUE}ℹ️ $*${RESET}"
}

# Success message
log_success() {
  echo -e "${GREEN}✅ $*${RESET}"
}

# Warning message
log_warn() {
  echo -e "${YELLOW}⚠️ $*${RESET}"
}

# Error message
log_error() {
  echo -e "${RED}❌ $*${RESET}" >&2
}

# Debug message (optional, controlled by env var LOG_DEBUG=1)
log_debug() {
  if [[ "${LOG_DEBUG:-0}" == "1" ]]; then
    echo -e "${CYAN}🐛 DEBUG: $*${RESET}"
  fi
}