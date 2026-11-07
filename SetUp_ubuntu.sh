#!/usr/bin/env bash
# Ubuntu security / OSINT / CTF / DFIR workstation bootstrap.
# Explicitly opt in to potentially disruptive system changes.
set -Eeuo pipefail
IFS=$'\n\t'
export DEBIAN_FRONTEND=noninteractive

SCRIPT_VERSION='2.0.0'
PROFILE='all'
DRY_RUN=0
UPGRADE=0
ENABLE_UFW=0
SSH_PORT=''
CHANGE_SHELL=0
INSTALL_UAC=0
INSTALL_PYTHON_TOOLS=0
INSTALL_DESKTOP=0
LOG_FILE=''
FAILURES=()
SKIPPED=()
INSTALLED=()

usage() {
  cat <<'USAGE'
Usage: sudo ./SetUp_ubuntu.sh [options]

Options:
  --profile core|osint|pentest|ctf|dfir|malware|all  Tool groups (default: all)
  --desktop              Install OBS Studio, CherryTree and Guymager (GUI)
  --python-tools         Install Sherlock and theHarvester via pipx
  --uac                  Clone UAC into /opt/uac (unpinned; review before use)
  --upgrade              Run apt-get upgrade (not done by default)
  --enable-ufw           Enable firewall; requires --ssh-port when SSH is in use
  --ssh-port PORT        Allow incoming TCP PORT before enabling UFW
  --change-shell         Install Oh My Zsh and change target user's login shell
  --dry-run              Print intended operations; make no changes
  -h, --help             Show this help

Run with sudo from a normal user account. Does not install Velociraptor,
Ghidra, Burp Suite, Metasploit, Autopsy GUI or other third-party binaries.
USAGE
}

log() { printf '[%s] %s\n' "$(date -u +%FT%TZ)" "$*"; }
warn() { log "WARN: $*" >&2; }
fail() { log "ERROR: $*" >&2; exit 1; }
run() { if (( DRY_RUN )); then printf '[DRY RUN]'; printf ' %q' "$@"; printf '\n'; else "$@"; fi; }
record_failure() { FAILURES+=("$1"); warn "$1"; }
trap 'warn "Stopped at line $LINENO (exit code $?)"' ERR

while (( $# )); do
  case "$1" in
    --profile) (( $# >= 2 )) || fail 'Missing profile'; PROFILE="$2"; shift 2 ;;
    --desktop) INSTALL_DESKTOP=1; shift ;;
    --python-tools) INSTALL_PYTHON_TOOLS=1; shift ;;
    --uac) INSTALL_UAC=1; shift ;;
    --upgrade) UPGRADE=1; shift ;;
    --enable-ufw) ENABLE_UFW=1; shift ;;
    --ssh-port) (( $# >= 2 )) || fail 'Missing SSH port'; SSH_PORT="$2"; shift 2 ;;
    --change-shell) CHANGE_SHELL=1; shift ;;
    --dry-run) DRY_RUN=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) fail "Unknown option: $1" ;;
  esac
done

case "$PROFILE" in core|osint|pentest|ctf|dfir|malware|all) ;; *) fail "Invalid profile: $PROFILE" ;; esac
if [[ -n "$SSH_PORT" ]]; then
  [[ "$SSH_PORT" =~ ^[0-9]+$ ]] && (( 10#$SSH_PORT >= 1 && 10#$SSH_PORT <= 65535 )) || fail 'Invalid SSH port'
fi
(( EUID == 0 )) || fail 'Run with sudo'
[[ -n "${SUDO_USER:-}" && "$SUDO_USER" != root ]] || fail 'Run using sudo from a normal user, not a direct root login'
TARGET_USER="$SUDO_USER"
USER_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6)"
[[ -n "$USER_HOME" && -d "$USER_HOME" ]] || fail 'Target user home directory not found'
[[ -r /etc/os-release ]] || fail 'Cannot identify operating system'
# shellcheck source=/dev/null
. /etc/os-release
[[ "${ID:-}" == ubuntu ]] || fail 'Only Ubuntu is supported'
case "${VERSION_ID:-}" in 22.04|24.04) ;; *) fail 'Only Ubuntu 22.04 and 24.04 LTS are supported targets' ;; esac
ARCH="$(dpkg --print-architecture)"
case "$ARCH" in amd64|arm64) ;; *) fail "Unsupported architecture: $ARCH" ;; esac

if (( ! DRY_RUN )); then
  LOG_FILE="/var/log/ubuntu-security-setup-$(date -u +%Y%m%dT%H%M%SZ).log"
  touch "$LOG_FILE" && chmod 600 "$LOG_FILE"
  exec > >(tee -a "$LOG_FILE") 2>&1
fi
log "Ubuntu setup $SCRIPT_VERSION | $PRETTY_NAME | $ARCH | user=$TARGET_USER | profile=$PROFILE"

# Each package is installed separately so one unavailable package does not
# prevent the rest of a group from installing. Unavailable packages are reported.
install_packages() {
  local pkg
  for pkg in "$@"; do
    if (( DRY_RUN )); then run apt-get install -y --no-install-recommends "$pkg"; continue; fi
