#!/usr/bin/env bash

# utils_logging.sh - Shared logging utilities for scripts

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    local msg=${1:-}
    echo -e "${BLUE}[INFO]${NC} ${msg}"
}

log_success() {
    local msg=${1:-}
    echo -e "${GREEN}[SUCCESS]${NC} ${msg}"
}

log_warning() {
    local msg=${1:-}
    echo -e "${YELLOW}[WARNING]${NC} ${msg}"
}

log_error() {
    local msg=${1:-}
    echo -e "${RED}[ERROR]${NC} ${msg}"
}
