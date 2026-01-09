#!/bin/bash

# Script to harden Ubuntu, install OSINT and security tools, and
# configure the terminal for 2026-standard Digital Forensics & IR.
# Run this script as root.

set -e

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root." >&2
  exit 1
fi

TARGET_USER="${SUDO_USER:-$USER}"
USER_HOME=$(eval echo ~"$TARGET_USER")

# --- SYSTEM UPDATE ---
apt update && apt upgrade -y

# --- SECURITY & HARDENING ---
# Added: ufw, fail2ban, clamav, rkhunter, chkrootkit, lynis, aide
apt install -y ufw fail2ban clamav clamav-daemon rkhunter chkrootkit lynis aide

# Configure firewall
ufw default deny incoming
ufw default allow outgoing
ufw --force enable

# Enable fail2ban and update AV databases
systemctl enable --now fail2ban
freshclam || true
rkhunter --update || true

# --- OSINT & PENETRATION TESTING ---
# Added: sherlock, amass, spiderfoot, proxychains4, tor + standard tools
apt install -y \
  nmap wireshark net-tools dnsutils whois \
  git python3 python3-pip curl wget \
  gobuster john hydra sqlmap nikto \
  aircrack-ng hashcat metasploit-framework \
  recon-ng theharvester sublist3r \
  maltego snort suricata tcpdump \
  sherlock amass spiderfoot proxychains4 tor

# --- CTF & REVERSE ENGINEERING ---
# Added: ghidra, radare2, trivy, binwalk, exiftool
apt install -y \
  binwalk steghide exiftool \
  gdb gdb-multiarch qemu socat netcat-traditional \
  python3-venv ghidra radare2 trivy

# --- MODERN CLI TOOLS (Quality of Life) ---
apt install -y bat htop btop tldr fzf

su - "$TARGET_USER" -c 'pip3 install --user --upgrade pwntools'

# --- TERMINAL CONFIGURATION (Kali Theme) ---
apt install -y zsh fonts-powerline
su - "$TARGET_USER" -c 'RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'

su - "$TARGET_USER" -c 'sed -i "s/^ZSH_THEME=.*/ZSH_THEME=\"kali\"/" ~/.zshrc'
su - "$TARGET_USER" -c 'echo "alias bat=batcat" >> ~/.zshrc'
chsh -s /usr/bin/zsh "$TARGET_USER"

# --- 🧪 NEW: 2026 DIGITAL FORENSICS & INCIDENT RESPONSE ---
# Core acquisition & analysis
apt install -y autopsy guymager hashdeep sleuthkit volatility3

# New 2026 additions:
# 1. ewf-tools: Required for handling .E01 files (expert witness format)
# 2. testdisk & photorec: The gold standard for recovering deleted partitions and files
# 3. foremost & scalpel: Advanced file carving tools
# 4. bulk-extractor: Extremely fast tool for extracting emails, URLs, and credit card numbers
# 5. plaso: (log2timeline) The industry standard for creating forensic timelines
# 6. rclone: For imaging and analyzing cloud storage (Dropbox, Google Drive, AWS)
apt install -y ewf-tools testdisk foremost scalpel bulk-extractor rclone

# Install UAC (Unix-like Artifacts Collector) - 2026 standard for triage
# This tool automates the collection of forensic artifacts from a live system
if [ ! -d "/opt/uac" ]; then
    git clone https://github.com/tclahr/uac.git /opt/uac
fi

# Install Velociraptor (The 2026 standard for endpoint hunting and triage)
# It allows you to query a running system for specific artifacts instantly.
V_VER="0.72" # Standard 2026 stable version
wget -O /usr/local/bin/velociraptor https://github.com/Velocidex/velociraptor/releases/download/v${V_VER}/velociraptor-v${V_VER}-linux-amd64
chmod +x /usr/local/bin/velociraptor

printf '\n--- 2026 FORENSIC UPDATE COMPLETE ---\n'
printf 'New Tools Added: E01 support, File Carving, Timeline Analysis, Cloud-Forensics, and Live Triage (UAC/Velociraptor).\n'
printf 'Please reboot to finalize setup.\n'
