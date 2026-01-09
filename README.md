# Ubuntu Hardening & Security Toolkit

This script automates the process of hardening a fresh Ubuntu installation and transforming it into a powerful workstation for OSINT, penetration testing, and CTF competitions (like PicoCTF, TryHackMe, and HackTheBox).

It streamlines system security, installs essential industry tools, and configures a professional terminal environment.

---

## 🛠 Features

### 1. System Hardening & Security
* **System Updates:** Runs a full `apt update` and `upgrade`.
* **Firewall:** Configures `UFW` to deny all incoming traffic by default.
* **Proactive Defense:** Installs and enables `fail2ban`, `ClamAV` (antivirus), `rkhunter`, and `chkrootkit`.
* **Auditing:** Installs `Lynis` for comprehensive system security auditing.

### 2. Security & OSINT Toolkit
A wide array of tools are installed, categorized by use case:
* **Network Analysis:** `nmap`, `wireshark`, `tcpdump`, `net-tools`.
* **Web & DB Hacking:** `sqlmap`, `gobuster`, `nikto`.
* **Exploitation & Cracking:** `metasploit-framework`, `john`, `hashcat`, `hydra`.
* **OSINT:** `theharvester`, `recon-ng`, `sublist3r`, `maltego`, `whois`.
* **CTF & Forensics:** `binwalk`, `steghide`, `exiftool`, `pwntools`, `gdb`.
* **IDS/IPS:** `snort`, `suricata`.

### 3. Terminal Enhancement
* Installs `zsh` and Powerline fonts.
* Automatically sets up **Oh My Zsh**.
* Configures the terminal to use the **Kali Linux theme** for an optimized CLI experience.

---

## 🚀 Usage

**Warning:** This script makes significant system changes. It is intended for use on a fresh installation or a dedicated security VM.

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/YOUR-USERNAME/YOUR-REPO-NAME.git](https://github.com/YOUR-USERNAME/YOUR-REPO-NAME.git)
   cd YOUR-REPO-NAME

2. **Make the script executable:**
   ```bash
   chmod +x setup.sh

4. **Run as root/sudo:**
   ```bash
   sudo ./setup.sh

6. ***Finalize:*** Reboot your system or log out and back in for the shell changes and group permissions to take effect.

---

## 📋 Requirements

* Ubuntu (Recommended: 22.04 LTS or 24.04 LTS).
* Active internet connection.
* Sudo privileges.

## ⚖️ Disclaimer

This script is for educational and ethical security testing purposes only. Using these tools against targets without prior authorization is illegal. The author assumes no liability for misuse or potential damage to your system.
