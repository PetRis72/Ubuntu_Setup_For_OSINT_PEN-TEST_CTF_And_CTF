#!/bin/bash

# Script to harden Ubuntu, install OSINT and security tools, and
# configure the terminal to resemble Kali Linux's default look.
# Run this script as root.

set -e

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root." >&2
  exit 1
fi

TARGET_USER="${SUDO_USER:-$USER}"
USER_HOME=$(eval echo ~"$TARGET_USER")

# Update and upgrade system
apt update && apt upgrade -y

# Install security and auditing tools (Added AIDE)
apt install -y ufw fail2ban clamav clamav-daemon rkhunter chkrootkit lynis aide

# Configure firewall
ufw default deny incoming
ufw default allow outgoing
ufw --force enable

# Enable fail2ban and update AV databases
systemctl enable --now fail2ban
freshclam || true
rkhunter --update || true

# Install OSINT and penetration testing tools (Added Sherlock, Amass, Proxychains, Tor)
apt install -y \
  nmap wireshark net-tools dnsutils whois \
  git python3 python3-pip curl wget \
  gobuster john hydra sqlmap nikto \
  aircrack-ng hashcat metasploit-framework \
  recon-ng theharvester sublist3r \
  maltego snort suricata tcpdump \
  sherlock amass spiderfoot proxychains4 tor

# Install CTF and Reverse Engineering tools (Added Ghidra, Radare2, Trivy)
apt install -y \
  binwalk steghide exiftool \
  gdb gdb-multiarch qemu socat netcat-traditional \
  python3-venv ghidra radare2 trivy

# Modern CLI tools (Quality of Life)
apt install -y bat htop btop tldr fzf

su - "$TARGET_USER" -c 'pip3 install --user --upgrade pwntools'

# Install and configure zsh with Kali theme
apt install -y zsh fonts-powerline

su - "$TARGET_USER" -c 'RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'

# Configure zshrc, aliases and theme
su - "$TARGET_USER" -c 'sed -i "s/^ZSH_THEME=.*/ZSH_THEME=\"kali\"/" ~/.zshrc'
su - "$TARGET_USER" -c 'echo "alias bat=batcat" >> ~/.zshrc'
chsh -s /usr/bin/zsh "$TARGET_USER"

printf '\nSetup complete. Please reboot or log out and back in for changes to take effect.\n'
