# 🚩 CTF & Forensic Tool Quick Start Guide (2026 Edition)

This guide provides rapid-fire examples for the forensic, reverse engineering, and exploitation tools included in this environment.

---

## 🔍 Forensics & File Analysis

### **ExifTool**
*Read and edit metadata in images, PDFs, and more.*
* **View all metadata:** `exiftool file.jpg`
* **Extract hidden thumbnails:** `exiftool -b -ThumbnailImage image.jpg > thumb.jpg`

### **Binwalk**
*Search binary files for embedded files and executable code.*
* **Scan for embedded files:** `binwalk challenge.bin`
* **Extract all files automatically:** `binwalk -e challenge.bin`

### **Oletools** (New!)
*Analyze malicious Office documents (macros, etc.).*
* **Scan document for macros:** `olevba document.docm`
* **Extract metadata from OLE files:** `olemeta document.doc`

### **Bulk-Extractor** (New!)
*Fast extraction of emails, URLs, and PCAP data from disk images.*
* **Extract all features:** `bulk_extractor -o output_dir image.E01`

---

## 🛡️ Live Triage & Incident Response

### **UAC (Unix Artifacts Collector)**
*Triage tool for live Linux systems.*
* **Collect standard artifacts:** `sudo /opt/uac/uac -p ir_triage ./output_folder`

### **Velociraptor**
*Endpoint hunting and real-time triage.*
* **Start local GUI:** `sudo velociraptor gui`

---

## ⚙️ Reverse Engineering & Debugging

### **GDB (GNU Debugger)**
*Interactive debugger for binary analysis.*
* **Start debugging:** `gdb ./binary`
* **Commands:** `info functions`, `disas main`, `run`

### **Radare2**
*Command-line hex editor and RE framework.*
* **Analyze & List:** `r2 ./binary` -> `aaa` (analyze) -> `afl` (list functions).
* **Visual Mode:** Press `V` then `p` to cycle views.

### **Ghidra**
*Graphical decompiler suite.*
* **Launch:** `ghidra`
* **Tip:** Always use the "Decompiler" window to read C-style logic from assembly.

---

## 🕸️ Web & Network Pentesting

### **Gobuster** (New!)
*Brute-force URLs, DNS, and VHosts.*
* **Directory scan:** `gobuster dir -u http://target.com -w /usr/share/wordlists/dirb/common.txt`

### **Impacket** (New!)
*Network protocol manipulation (SMB/WMI/Kerberos).*
* **Dump hashes via SMB:** `impacket-secretsdump -system SYSTEM -sam SAM LOCAL`
* **Get a shell via WMI:** `impacket-wmiexec DOMAIN/User@TargetIP`

### **Dirsearch** (New!)
*Advanced web path brute-forcing.*
* **Quick scan:** `dirsearch -u http://target.com`

---

## 🐍 Exploitation & Scripting

### **Pwntools**
*Python library for crafting exploits.*
* **Template script (`exploit.py`):**
```python
from pwn import *
target = process('./vuln_binary')
# target = remote('ip', port)
target.sendline(b'A' * 32 + p64(0xdeadbeef))
target.interactive()
```
## 🌐 Connectivity & Stealth

### **Proxychains4**
*Force connections through Tor or SOCKS proxies.*
* **Usage:** `proxychains4 nmap -sT -Pn <IP>`

**Tor**
*Anonymity network.*
**Start service:** `sudo systemctl start tor`

## 📝 Evidence Documentation

## **CherryTree**
*Hierarchical note-taking for case logs.*
* **Launch:** `cherrytree`
* **Tip:** Use "Code Nodes" to store suspicious scripts with syntax highlighting.

## **OBS Studio**
*Screen recording for "Digital Witnessing".*
* **Launch:** `obs`
* **Setup:** Create a "Screen Capture" source to document your forensic process.

  
