# 🛡️ Ubuntu Hardening & 2026 Forensic Toolkit

This repository contains a professional-grade, **hardware-aware** automation script and documentation suite to transform any fresh Ubuntu installation into a high-performance workstation for **Digital Forensics (DFIR)**, **Incident Response**, **OSINT**, and **Advanced CTF** competitions.

The 2026 update introduces **Universal Hardware Optimization**, **Cloud Forensics**, and **Isolated Python Environments**.

---

## 🛠️ Features

### 1. System Hardening & "Zero-Trust" Security
* **Proactive Defense:** Installs `UFW`, `fail2ban`, `ClamAV`, `rkhunter`, and `chkrootkit`.
* **Integrity Monitoring:** Configures `AIDE` and `Lynis` for continuous security auditing.
* **Non-Interactive Setup:** Hardened configurations applied automatically without user prompts for seamless deployment.

### 2. Specialized Toolkits (2026 Ready)
* **Digital Forensics (Deep Dive):** `SleuthKit`, `Volatility3`, `ewf-tools` (.E01 support), `Guymager`, and `Bulk-Extractor`.
* **Incident Response & Live Triage:** `Velociraptor` (endpoint hunting) and `UAC` (Unix Artifacts Collector) for rapid 15-minute triage.
* **Data Recovery & Carving:** `Foremost`, `Scalpel`, `TestDisk`, and `PhotoRec`.
* **Pentesting & Recon:** `Gobuster`, `John the Ripper`, `Hydra`, `SQLMap`, and `Nikto`.
* **Advanced OSINT:** `Sherlock`, `Amass`, `Spiderfoot`, and `theHarvester`.
* **Reverse Engineering:** `Radare2`, `Binwalk`, `ExifTool`, and `PwnTools`. (Includes OpenJDK 17 for `Ghidra` support).

### 3. Professional Terminal & Python Environment
* **Universal Hardware Awareness:** Automatically detects CPU cores to optimize tool compilation speed.
* **Pyenv Integration:** Installs and configures an isolated **Python 3.12.1** environment, preventing "externally-managed-environment" conflicts on Ubuntu 24.04+.
* **Zsh & Kali Theme:** Automatically configures **Oh My Zsh** with the Kali Linux theme for a seamless transition between security tools.
* **QoL Tools:** `bat` (syntax highlighting), `btop` (resource monitoring), `tldr` (simplified man pages), and `fzf` (fuzzy finder).

### 4. Documentation & Evidence Discovery
* **OBS Studio:** Configured for high-fidelity screen recording of forensic workflows (Digital Witnessing).
* **CherryTree:** A hierarchical note-taking application used for case logging, image embedding, and evidence documentation.

### 5. Static Malware Analysis (REMnux-Lite)
* **YARA:** The pattern matching swiss-army knife for malware researchers.
* **Oletools:** Python tools to analyze Microsoft OLE2 files (MS Office) for malicious macros.
* **UPX:** Advanced executable packer/unpacker.

### 6. Network Exploitation & Lateral Movement
* **Impacket:** A collection of Python classes for working with network protocols (SMB, WMI, Kerberos).
* **Evil-WinRM:** The ultimate WinRM shell for hacking Windows boxes.
* **Dirsearch:** Advanced web path brute-forcing tool.

---

## 🚀 Installation & Usage

**Warning:** This script is intended for use on a dedicated security VM or a fresh forensic workstation.

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/PetRis72/Ubuntu_Setup_For_OSINT_PEN-TEST_CTF_And_CTF.git](https://github.com/PetRis72/Ubuntu_Setup_For_OSINT_PEN-TEST_CTF_And_CTF.git)
   cd Ubuntu_Setup_For_OSINT_PEN-TEST_CTF_And_CTF
   ```

2. **Make the script executable:**
   ```bash
   chmod +x SetUp_ubuntu.sh
   ```

4. **Run as root/sudo:**
   ```bash
   sudo ./SetUp_ubuntu.sh
   ```

6. ***Finalize:*** Reboot your system or log out and back in for the shell changes and group permissions to take effect.

---

## 📋 Forensic Documentation & Guides

This repo includes 2026-standard documentation for professional investigations:

* [✨ Quality Of Life](./01_QoL_Guide.md)
* [🚩 CTF Quick Start](./02_CTF_HowTo.md)
* [🔎 OSINT Quick Start](./03_OSINT_HowTo.md)
* [🔍Evidence Gathering](./04_Evidence_Gathering.md)
* [🧠 RAM Acquisition & Analysis](./05_RAM_Forensics.md) – Volatile memory workflows.
* [📁 Hard Drive Forensics (TB+ Scale)](./06_Hard_Drive_Forensics.md) – Mastering large drive imaging.
* [🚀 Autopsy Optimization](./07_Autopsy_Optimization.md) – Handling Big Data analysis.
* [📊 Universal Chain of Custody](./08_Chain_of_Custody.md) – Legally defensible audit trails.
* [📸 Seizure Photography Checklist](./09_Seizure_Photography_Checklist.md) – The "10-Shot" rule for scenes.
* [🧳 Forensic Go-Bag 2026](./10_Forensic_Go_Bag_2026.md) – Essential hardware kit.

---

## 📋 Requirements

* **OS:** Ubuntu 24.04 LTS (Recommended) or 22.04 LTS.
* **Architecture:** Universal (x86_64 / ARM64).
* **User:** Sudo privileges required.
* **Hardware:** Minimum 8GB RAM (16GB+ recommended for RAM forensics and virtualization).

## ⚖️ Disclaimer

This toolkit is for authorized forensic investigations and ethical security testing only. The author assumes no liability for misuse. Using these tools against systems without explicit permission is illegal.
