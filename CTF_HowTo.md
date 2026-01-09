# 🚩 CTF Tool Quick Start Guide

This guide provides basic usage examples for the forensic, reverse engineering, and exploitation tools included in this setup.

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

### **Steghide**
*Hide or extract data from images and audio files.*
* **Extract hidden data:** `steghide extract -sf image.jpg`

---

## ⚙️ Reverse Engineering & Debugging

### **GDB (GNU Debugger)**
*Interactive debugger for binary analysis.*
* **Start debugging:** `gdb ./binary`
* **Useful internal commands:**
  * `info functions` - List all functions.
  * `disas main` - Disassemble the main function.
  * `run` - Start the program.

### **Radare2**
*Command-line hex editor and reverse engineering framework.*
* **Analyze binary:** `r2 ./binary` -> then type `aaa` to analyze all.
* **List functions:** `afl`
* **Enter visual mode:** `V` (use `p` to cycle through views).

### **Ghidra**
*Graphical decompiler and SRE suite.*
* **Launch:** `ghidra`
* **Usage:** Create a project, import binary, and use the **Decompiler** window to see C-style code.

---

## 🐍 Exploitation & Scripting

### **Pwntools**
*Python library for crafting exploits.*
* **Example exploit script (`exploit.py`):**
```python
from pwn import *

# Connect to a local process
target = process('./vuln_binary')

# Or connect to a remote server
# target = remote('127.0.0.1', 1337)

# Send payload
target.sendline(b'A' * 32 + p64(0xdeadbeef))

# Drop to interactive shell
target.interactive()
```

## 🛡 Vulnerability Research
**Trivy**
Scan filesystems or images for CVEs.
* **Scan current directory:** `trivy fs`
* **Scan for misconfigurations:** `trivy config`

---

## 🌐 Networking

**Netcat (nc)**
The "Swiss Army Knife" of networking.
* **Listen for a shell:** `nc -lvnp 4444`
* **Connect to a server:** `nc <IP> <PORT>`

**Proxychains4**
Force any TCP connection through a proxy (e.g., Tor).
* **Usage with Nmap:** `proxychains4 nmap -sT -PN <IP>`

