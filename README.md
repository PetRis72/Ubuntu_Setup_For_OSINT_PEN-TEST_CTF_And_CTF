# 🛡️ Ubuntu Security Workstation Setup

## About This Project

This Ubuntu setup was originally created to support my personal cybersecurity training on **picoCTF**, **Hack The Box (HTB)**, and other **Capture the Flag (CTF)** platforms.

The goal is to build a practical, customizable Linux workstation for learning and practicing:

- Capture the Flag challenges and cybersecurity labs
- Ethical hacking and penetration testing
- Open-Source Intelligence (OSINT)
- Digital forensics and incident response (DFIR)
- Reverse engineering and malware analysis
- Linux administration, scripting, and security fundamentals

Rather than installing a dedicated security distribution, this project provides a way to build a training environment on Ubuntu using selected tools and optional installation profiles.

**Intended use:** Personal learning, authorized labs, CTF competitions, and security research in environments where testing is explicitly permitted.

**Project status:** An evolving personal learning project. Tool availability and compatibility may vary by Ubuntu version, and installation should be tested in a virtual machine before use on a primary workstation.

A configurable Bash installer for **Ubuntu 22.04 LTS and 24.04 LTS** aimed at OSINT, authorized penetration testing, CTF practice, digital forensics / incident response (DFIR), and static malware analysis.

> **Status:** Version 2.0.0 is a reviewed rewrite, **not yet validated by end-to-end installation on every supported Ubuntu/architecture combination**. Package availability varies by Ubuntu release, architecture, and enabled APT repositories. Review the script before running it. Use a disposable VM and take a snapshot first.

## What it does

- Installs common prerequisites and command-line utilities from your existing APT repositories.
- Installs tool groups selected with `--profile` (`all` by default).
- Optionally installs desktop tools, selected Python CLI tools through `pipx`, and UAC source code.
- Optionally performs an APT upgrade, activates UFW, or changes the invoking user's login shell.
- Checks whether each APT package is available and reports skipped or failed installations.
- Logs actual runs to `/var/log/ubuntu-security-setup-<UTC timestamp>.log` (root-readable).

**It does not** configure a complete hardened/zero-trust system, guarantee every package is available, install or configure Autopsy GUI, Velociraptor, Ghidra, Burp Suite or Metasploit, or make forensic procedures legally compliant by itself.

## Requirements

- Ubuntu **22.04** or **24.04** LTS (the script refuses other versions).
- `amd64` or `arm64` architecture; package availability on ARM64 is **not guaranteed**.
- A normal user account with `sudo` access. **Do not invoke from a direct root login.**
- Network access to configured Ubuntu APT repositories. Optional `pipx` and GitHub installations need external network access.
- A fresh VM or a backed-up workstation; sufficient storage and memory for the selected toolsets.
- Existing APT repositories must provide the requested packages. The script does **not** add PPAs, `universe` or `multiverse` automatically.

## Installation

```bash
git clone https://github.com/PetRis72/Ubuntu_Setup_For_OSINT_PEN-TEST_CTF_And_CTF.git
cd Ubuntu_Setup_For_OSINT_PEN-TEST_CTF_And_CTF
chmod +x SetUp_ubuntu.sh

# Preview without making changes:
sudo ./SetUp_ubuntu.sh --dry-run

# Install command-line tools from all profiles:
sudo ./SetUp_ubuntu.sh --profile all
```

## Profiles and packages

All profiles install these shared prerequisites: `ca-certificates`, `curl`, `git`, `wget`, `gnupg`, `software-properties-common`, `python3`, `python3-venv`, `pipx`, `zsh`, `bat`, `btop`, `htop`, `fzf`, `tldr`, `fonts-powerline`.

| Profile | Packages requested from APT |
|---|---|
| `core` | `ufw`, `fail2ban`, `clamav`, `clamav-freshclam`, `rkhunter`, `chkrootkit`, `lynis`, `aide` |
| `osint` | `whois`, `dnsutils`, `amass`, `tor`, `proxychains4`, `exiftool` |
| `pentest` | `nmap`, `tshark`, `wireshark`, `gobuster`, `john`, `hydra`, `sqlmap`, `nikto`, `net-tools` |
| `ctf` | `binwalk`, `gdb`, `radare2`, `file`, `binutils` |
| `dfir` | `ewf-tools`, `sleuthkit`, `hashdeep`, `testdisk`, `foremost`, `scalpel`, `bulk-extractor`, `exiftool`, `rclone`, `volatility3` |
| `malware` | `yara`, `python3-oletools`, `upx` |
| `all` | Every profile above |

Packages are **attempted**, not guaranteed. If APT does not offer a package (for example, on a particular Ubuntu version), the script reports it as skipped. An APT install error is reported as a failure and causes a nonzero exit status at the end.

## Optional actions

```bash
# Only OSINT tools:
sudo ./SetUp_ubuntu.sh --profile osint

# All command-line profiles plus desktop applications:
sudo ./SetUp_ubuntu.sh --profile all --desktop

# Install optional Python CLIs via pipx (network required):
sudo ./SetUp_ubuntu.sh --profile osint --python-tools

# Also clone UAC source (not executed; upstream HEAD is not pinned):
sudo ./SetUp_ubuntu.sh --profile dfir --uac

# Upgrade existing system packages (opt-in):
sudo ./SetUp_ubuntu.sh --profile core --upgrade

# Configure UFW (opt-in). Allow your actual SSH port before enabling:
sudo ./SetUp_ubuntu.sh --profile core --enable-ufw --ssh-port 22

# Install Oh My Zsh and change your login shell (opt-in):
sudo ./SetUp_ubuntu.sh --profile core --change-shell
```

`--python-tools` **attempts** to install `sherlock-project` and `theHarvester` through `pipx` under the invoking user's account. Package availability, CLI command names, and compatibility must be checked after installation; failed installations are reported. These tools are not installed unless the flag is provided.

`--desktop` attempts to install `obs-studio`, `cherrytree`, and `guymager` from APT. It does not install a desktop environment.

`--uac` clones `https://github.com/tclahr/uac.git` to `/opt/uac` if the directory does not exist. It **does not** run UAC. Because the source is not pinned to a commit or verified against a release checksum, review it before use in an investigation.

`--change-shell` clones Oh My Zsh if absent, creates `.zshrc` from its template if absent, and changes the invoking user's shell to `/usr/bin/zsh`. It does **not** install a Kali theme, autosuggestions, or syntax-highlighting plugins. It does not overwrite an existing `.zshrc`.

## Security considerations

- **UFW:** Disabled by default. `--enable-ufw` applies deny-incoming / allow-outgoing rules and activates UFW. If SSH is detected, the script requires `--ssh-port`. If you use SSH, VPN, remote management or other inbound services, review and allow **all** required ports first. Incorrect firewall rules can lock you out. Consider testing at a VM console.
- **System services:** Installing packages such as `fail2ban`, `tor`, `clamav` or `wireshark` may have service, permission or package-configuration side effects. The script does not claim to fully configure them.
- **Downloads:** The script uses APT packages, optionally `pipx` packages, and optionally clones GitHub repositories. Optional network sources are not cryptographically pinned in this version.
- **Forensic integrity:** This workstation is not automatically a validated forensic acquisition environment. Use write-blocking, verified acquisition methods, case logs, and documented chain of custody where applicable.
- **Legal scope:** Only investigate systems and data for which you have authorization. Legal rules differ by jurisdiction and investigation type.

## Verify installation

```bash
command -v nmap
command -v exiftool
command -v ewfmount
command -v yara
command -v zsh

# Check installed package status:
dpkg-query -W nmap sleuthkit yara 2>/dev/null

# See latest setup logs (requires sudo):
sudo ls -lt /var/log/ubuntu-security-setup-*.log
```

Only expect commands from profiles and optional flags that you actually selected. Command names can differ from APT package names. A successful run does not guarantee that every requested tool was installed; read the skipped list and log. A nonzero exit status means at least one operation failed or a fatal check stopped execution.

## Troubleshooting

- **Package not found:** Check `apt-cache policy <package>` and the enabled Ubuntu repositories. Some packages may not be present for your release/architecture.
- **Optional pipx failure:** Check `pipx list`, package naming, Python compatibility and network access. Retry the affected package separately.
- **SSH / UFW:** Use console access to inspect `sudo ufw status verbose`; do not activate firewall remotely until you know all necessary rules.
- **Disk space:** DFIR and CTF packages can use significant storage. Check `df -h` before installation.
- **Dry run:** Prints intended commands but does not test APT installation, GitHub downloads or runtime compatibility.

## Guides

The following documents are **reference material**, not a guarantee that every tool or workflow is installed or supported by the script. Some legacy examples need separate technical validation, especially the Autopsy, E01, mobile forensics and legal sections.

1. [Terminal & Quality of Life](./01_QoL_Guide.md)
2. [CTF Quick Start](./02_CTF_HowTo.md)
3. [OSINT Quick Start](./03_OSINT_HowTo.md)
4. [Evidence Gathering](./04_Evidence_Gathering.md)
5. [RAM Forensics](./05_RAM_Forensics.md)
6. [Hard Drive Forensics](./06_Hard_Drive_Forensics.md)
7. [Autopsy Optimization](./07_Autopsy_Optimization.md)
8. [Chain of Custody](./08_Chain_of_Custody.md)
9. [Seizure Photography Checklist](./09_Seizure_Photography_Checklist.md)
10. [Forensic Go-Bag](./10_Forensic_Go_Bag_2026.md)
11. [iOS Forensics](./11_iOS_Forensics_2026.md)
12. [Android Forensics](./12_Android_Forensics_2026.md)
13. [Final Case Report Template](./13_Final_Case_Report_Template.md)
14. [European Forensic Standards](./14_European_Forensic_Standards_2026.md)
15. [Discovery of Unrelated Crimes](./15_Discovery_of_Unrelated_Crimes.md)

## Project status and limitations

This version deliberately prioritizes conservative defaults and transparent installation reporting over claiming a turnkey forensic or zero-trust system. No automatic Velociraptor download is included because release/architecture selection and integrity verification should be implemented and tested first. Likewise, `pyenv` and a pinned Python 3.12.1 build have been removed in favor of system Python plus optional `pipx` installations.

**Testing status:** Bash syntax validation has been performed on the rewritten script. End-to-end Ubuntu VM tests, ARM64 validation, APT package matrix tests, and optional network installation tests are still needed before describing it as production-ready.

## Disclaimer

For authorized security work, research, training and digital forensics only. Review commands and dependencies before running them, and comply with applicable law and organizational policy.
