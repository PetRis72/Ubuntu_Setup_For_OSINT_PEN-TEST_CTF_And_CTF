#!/bin/bash

# =================================================================
# UNIVERSAL DFIR, OSINT & SEC WORKSTATION SETUP
# Fungerer på Ubuntu 24.04+ (Laptop, Desktop, VM)
# =================================================================

set -e
export DEBIAN_FRONTEND=noninteractive

if [[ $EUID -ne 0 ]]; then
  echo "Dette skriptet må kjøres som root (sudo)." >&2
  exit 1
fi

TARGET_USER="${SUDO_USER:-$USER}"
USER_HOME=$(eval echo ~"$TARGET_USER")
# Oppdager antall CPU-kjerner for å maksimere hastighet på kompilering
CPU_CORES=$(nproc)

echo "--- 🚀 Starter installasjon på $(hostname) for $TARGET_USER ---"
echo "--- Bruker $CPU_CORES kjerner for optimalisering ---"

# --- SYSTEM OPPDATERING & DEPOTER ---
add-apt-repository -y universe
add-apt-repository -y multiverse
apt update && apt upgrade -y

# --- AUTOMATISERING ---
echo "wireshark-common wireshark-common/install-setuid boolean true" | debconf-set-selections

# --- BASISVERKTØY & BYGG-AVHENGIGHETER ---
apt install -y build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev curl libncursesw5-dev xz-utils tk-dev \
libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev git wget openjdk-17-jdk \
apt-transport-https ca-certificates software-properties-common

# --- UNIVERSAL PYTHON SETUP (via pyenv) ---
echo "--- Installerer pyenv og kompilerer Python (Justerer hastighet etter maskinvare) ---"
if [ ! -d "$USER_HOME/.pyenv" ]; then
    su - "$TARGET_USER" -c 'curl https://pyenv.run | bash'
fi

export PYENV_ROOT="$USER_HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# Her bruker vi MAKEOPTS for å bruke alle tilgjengelige CPU-kjerner uansett maskin
su - "$TARGET_USER" -c "export MAKEOPTS='-j$CPU_CORES'; export PATH=\"\$HOME/.pyenv/bin:\$PATH\"; eval \"\$(pyenv init -)\"; pyenv install 3.12.1 -s"
su - "$TARGET_USER" -c "export PATH=\"\$HOME/.pyenv/bin:\$PATH\"; eval \"\$(pyenv init -)\"; pyenv global 3.12.1"

# --- SECURITY & HARDENING ---
apt install -y ufw fail2ban clamav rkhunter chkrootkit lynis aide
ufw default deny incoming
ufw default allow outgoing
ufw --force enable
systemctl enable --now fail2ban

# --- NETTVERK, OSINT & PENTESTING ---
apt install -y nmap wireshark tshark net-tools dnsutils whois \
               gobuster john hydra sqlmap nikto \
               spiderfoot amass tor proxychains4

# --- DIGITAL FORENSICS (DFIR) ---
apt install -y ewf-tools sleuthkit hashdeep testdisk foremost scalpel \
               binwalk exiftool rclone volatility3 guymager bulk-extractor

# --- TRIAGE & LIVE RESPONSE ---
if [ ! -d "/opt/uac" ]; then
    git clone --depth 1 https://github.com/tclahr/uac.git /opt/uac
fi

V_VER="0.72"
wget -q -O /usr/local/bin/velociraptor https://github.com/Velocidex/velociraptor/releases/download/v${V_VER}/velociraptor-v${V_VER}-linux-amd64
chmod +x /usr/local/bin/velociraptor

# --- TERMINAL SETUP (ZSH & Modern CLI Tools) ---
apt install -y zsh fonts-powerline bat htop btop tldr fzf
if [ ! -d "$USER_HOME/.oh-my-zsh" ]; then
    su - "$TARGET_USER" -c 'git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh'
    su - "$TARGET_USER" -c 'cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc'
fi

# Oppsett av miljøvariabler i .zshrc
cat << EOF >> "$USER_HOME/.zshrc"
# Python (pyenv)
export PYENV_ROOT="\$HOME/.pyenv"
[[ -d \$PYENV_ROOT/bin ]] && export PATH="\$PYENV_ROOT/bin:\$PATH"
eval "\$(pyenv init -)"

# Tools & Aliases
alias bat=batcat
alias ls='ls --color=auto'
alias grep='grep --color=auto'
EOF

su - "$TARGET_USER" -c 'sed -i "s/^ZSH_THEME=.*/ZSH_THEME=\"kali\"/" ~/.zshrc'
chsh -s /usr/bin/zsh "$TARGET_USER"

# --- MANUAL INSTALLATION GUIDE ---
clear
echo "==============================================================="
echo "📥 UNIVERSAL POST-INSTALL MANUAL"
echo "==============================================================="
echo "Systemet er ferdig satt opp med kjerne-verktøy."
echo ""
echo "For tunge GUI-verktøy, følg disse instruksjonene:"
echo ""
echo "1. GHIDRA: Last ned fra https://ghidra-sre.org/"
echo "2. BURP SUITE: Last ned fra https://portswigger.net/"
echo "3. METASPLOIT: Kjør 'curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && chmod 755 msfinstall && ./msfinstall'"
echo "==============================================================="

read -p "Vil du åpne nedlastingssidene nå? (y/n): " choice
if [[ "$choice" == "y" ]]; then
    su - "$TARGET_USER" -c "xdg-open https://ghidra-sre.org/ && xdg-open https://portswigger.net/burp/communitydownload"
fi

echo "--- ✅ FERDIG! Logg ut og inn for å aktivere ZSH og Python-miljøet. ---"
