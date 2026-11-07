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
    if dpkg-query -W -f='${Status}' "$pkg" 2>/dev/null | grep -qx 'install ok installed'; then
      INSTALLED+=("$pkg (already present)")
    elif ! apt-cache show "$pkg" >/dev/null 2>&1; then
      SKIPPED+=("$pkg (not in enabled APT repositories)")
      warn "APT package unavailable: $pkg"
    elif apt-get install -y --no-install-recommends "$pkg"; then
      INSTALLED+=("$pkg")
    else
      record_failure "APT installation failed: $pkg"
    fi
  done
}

selected() { [[ "$PROFILE" == all || "$PROFILE" == "$1" ]]; }

# Base prerequisites are always installed.
run apt-get update
if (( UPGRADE )); then run apt-get upgrade -y; fi
install_packages ca-certificates curl git wget gnupg software-properties-common \
  python3 python3-venv pipx zsh bat btop htop fzf tldr fonts-powerline

if selected core; then
  install_packages ufw fail2ban clamav clamav-freshclam rkhunter chkrootkit lynis aide
fi
if selected osint; then
  install_packages whois dnsutils amass tor proxychains4 exiftool
fi
if selected pentest; then
  install_packages nmap tshark wireshark gobuster john hydra sqlmap nikto net-tools
fi
if selected ctf; then
  install_packages binwalk gdb radare2 file binutils
fi
if selected dfir; then
  install_packages ewf-tools sleuthkit hashdeep testdisk foremost scalpel \
    bulk-extractor exiftool rclone volatility3
fi
if selected malware; then
  install_packages yara python3-oletools upx
fi
if (( INSTALL_DESKTOP )); then
  install_packages obs-studio cherrytree guymager
fi

# Optional Python CLI tools are isolated by pipx. No global pip installs.
if (( INSTALL_PYTHON_TOOLS )); then
  for spec in sherlock-project theHarvester; do
    if (( DRY_RUN )); then run runuser -u "$TARGET_USER" -- pipx install "$spec"; continue; fi
    if runuser -u "$TARGET_USER" -- pipx install "$spec"; then
      INSTALLED+=("pipx:$spec")
    else
      record_failure "pipx install failed: $spec (check package name/compatibility)"
    fi
  done
fi

# UAC is cloned but NOT executed. Its HEAD changes upstream; treat as unpinned.
if (( INSTALL_UAC )); then
  if [[ -e /opt/uac ]]; then
    SKIPPED+=('/opt/uac already exists; not modified')
  else
    if (( DRY_RUN )); then
      run git clone --depth 1 https://github.com/tclahr/uac.git /opt/uac
    elif git clone --depth 1 https://github.com/tclahr/uac.git /opt/uac; then
      INSTALLED+=('UAC source (/opt/uac)')
    else
      record_failure 'UAC clone failed'
    fi
  fi
fi

# Never activate a firewall silently. If SSH is active, require an explicit port.
if (( ENABLE_UFW )); then
  if [[ -z "$SSH_PORT" ]] && { [[ -n "${SSH_CONNECTION:-}" ]] || systemctl is-active --quiet ssh 2>/dev/null; }; then
    fail 'SSH detected. Re-run with --ssh-port PORT (or configure UFW manually).'
  fi
  install_packages ufw
  if [[ -n "$SSH_PORT" ]]; then run ufw allow "${SSH_PORT}/tcp"; fi
  run ufw default deny incoming
  run ufw default allow outgoing
  run ufw --force enable
fi

# Optional shell customization; use upstream default theme, not a nonexistent Kali theme.
if (( CHANGE_SHELL )); then
  if [[ -e "$USER_HOME/.oh-my-zsh" ]]; then
    SKIPPED+=('Oh My Zsh already present; not modified')
  else
    if (( DRY_RUN )); then
      run runuser -u "$TARGET_USER" -- git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git "$USER_HOME/.oh-my-zsh"
    elif runuser -u "$TARGET_USER" -- git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git "$USER_HOME/.oh-my-zsh"; then
      INSTALLED+=('Oh My Zsh')
    else
      record_failure 'Oh My Zsh clone failed'
    fi
  fi
  if [[ ! -e "$USER_HOME/.zshrc" ]]; then
    if (( DRY_RUN )); then
      log '[DRY RUN] Would create .zshrc from Oh My Zsh template'
    elif [[ -f "$USER_HOME/.oh-my-zsh/templates/zshrc.zsh-template" ]]; then
      runuser -u "$TARGET_USER" -- cp "$USER_HOME/.oh-my-zsh/templates/zshrc.zsh-template" "$USER_HOME/.zshrc"
    fi
  fi
  run chsh -s /usr/bin/zsh "$TARGET_USER"
fi

log '--- Summary ---'
log "Installed/already present: ${#INSTALLED[@]}"
for item in "${SKIPPED[@]}"; do warn "Skipped: $item"; done
for item in "${FAILURES[@]}"; do warn "Failed: $item"; done
[[ -z "$LOG_FILE" ]] || log "Log: $LOG_FILE"
if (( ${#FAILURES[@]} > 0 )); then
  warn "Finished with ${#FAILURES[@]} failed operations. Review log."
  exit 1
fi
log 'Finished. Verify installed tools and reboot/log out if shell was changed.'
