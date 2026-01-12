#!/bin/bash

# =================================================================
# UNIVERSAL DFIR, OSINT, MALWARE & SEC WORKSTATION SETUP
# 2026 Professional Edition - "The Gold Script"
# =================================================================

set -e
export DEBIAN_FRONTEND=noninteractive

if [[ $EUID -ne 0 ]]; then
  echo "Dette skriptet må kjøres som root (sudo)." >&2
  exit 1
fi

TARGET_USER="${SUDO_USER:-$USER}"
USER_HOME=$(eval echo ~"$TARGET_USER")
CPU_CORES=$(nproc)

echo "--- 🚀 Starter installasjon på $(hostname) ---"
echo "--- Prosesserer med $CPU_CORES kjerner ---"

# --- 1. DEPOTER OG SYSTEM ---
add-apt-repository -y universe
add-apt-repository -y multiverse
add-apt-repository -y ppa:obsproject/obs-studio
apt update && apt upgrade -y

# --- 2. AUTOMATISERING (Silent Install) ---
echo "wireshark-common wireshark-common/install-setuid boolean true" | debconf-set-selections

# --- 3. BASIS & BYGG-AVHENGIGHETER ---
apt install -y build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev curl libncursesw5-dev xz-utils tk-dev \
libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev git wget openjdk-17-jdk \
apt-transport-https ca-certificates software-properties-common

# --- 4. PYTHON MILJØ (pyenv) ---
echo "--- Installerer isolert Python 3.12.1 (via pyenv) ---"
if [ ! -d "$USER_HOME/.pyenv" ]; then
    su - "$TARGET_USER" -c 'curl https://pyenv.run | bash'
fi
export PYENV_ROOT="$USER_HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

su - "$TARGET_USER" -c "export MAKEOPTS='-j$CPU_CORES'; export PATH=\"\$HOME/.pyenv/bin:\$PATH\"; eval \"\$(pyenv init -)\"; pyenv install 3.12.1 -s"
su - "$TARGET_USER" -c "export PATH=\"\$HOME/.pyenv/bin:\$PATH\"; eval \"\$(pyenv init -)\"; pyenv global 3.12.1"

# --- 5. SECURITY & HARDENING ---
apt install -y ufw fail2ban clamav rkhunter chkrootkit lynis aide
ufw default deny incoming
ufw default allow outgoing
ufw --force enable
systemctl enable --now fail2ban

# --- 6. FORENSICS & DFIR (2026 Standard) ---
apt install -y ewf-tools sleuthkit hashdeep testdisk foremost scalpel \
               binwalk exiftool rclone volatility3 guymager bulk-extractor

# --- 7. MALWARE ANALYSE (REMnux-Lite) ---
apt install -y yara upx-ucl python3-oletools forensics-all

# --- 8. NETTVERK, OSINT & PENTESTING (Kali-Style) ---
apt install -y nmap wireshark tshark net-tools dnsutils whois \
               gobuster john hydra sqlmap nikto dirsearch \
               spiderfoot amass tor proxychains4

# --- 9. TRIAGE & LIVE RESPONSE ---
if [ ! -d "/opt/uac" ]; then
    git clone --depth 1 https://github.com/tclahr/uac.git /opt/uac
fi
V_VER="0.72"
wget -q -O /usr/local/bin/velociraptor https://github.com/Velocidex/velociraptor/releases/download/v${V_VER}/velociraptor-v${V_VER}-linux-amd64
chmod +x /usr/local/bin/velociraptor

# --- 10. DOKUMENTASJON ---
apt install -y obs-studio cherrytree

# --- 11. TERMINAL & QoL (ZSH, bat, btop, fzf) ---
apt install -y zsh fonts-powerline bat htop btop tldr fzf
if [ ! -d "$USER_HOME/.oh-my-zsh" ]; then
    su - "$TARGET_USER" -c 'git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh'
    su - "$TARGET_USER" -c 'cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc'
fi

# Oppsett av .zshrc
cat << EOF >> "$USER_HOME/.zshrc"
# Python Environment
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

# --- AVSLUTNING OG MANUELL VEILEDER ---
clear
echo "==============================================================="
echo "✅ INSTALLASJON FULLFØRT PÅ $(hostname)"
echo "==============================================================="
echo "1. Restart maskinen for å aktivere ZSH og sikkerhetsregler."
echo "2. For Ghidra/Burp/Metasploit, se README.md for instrukser."
echo "3. Bruk OBS Studio for bevisdokumentasjon (skjermopptak)."
echo "4. Bruk CherryTree for sakslogg."
echo "==============================================================="

read -p "Vil du åpne nedlastingssidene for Ghidra og Burp nå? (y/n): " choice
if [[ "$choice" == "y" ]]; then
    su - "$TARGET_USER" -c "xdg-open https://ghidra-sre.org/ && xdg-open https://portswigger.net/burp/communitydownload"
fi
