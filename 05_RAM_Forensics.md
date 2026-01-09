# 🧠 RAM Acquisition & Analysis Guide (Memory Forensics)

Memory (RAM) is volatile. It contains active data that is lost the moment the computer loses power. This guide covers how to capture RAM from live systems and analyze it using your Ubuntu workstation.

---

## ⚡ The Order of Volatility
Before touching a live system, remember the golden rule of forensics: **Capture the most volatile data first.**
1.  **RAM (Memory)**
2.  **Swap/Pagefile**
3.  **Local Disk (SSD/HDD)**
4.  **Remote Logs**

---

## 📥 Acquisition: How to Capture RAM

### **1. Hardware Requirements**
* **USB Stick:** A high-speed USB 3.0/3.1 drive.
* **Size:** Must be larger than the target's RAM (e.g., if the target has 64GB RAM, use a **128GB or 256GB** stick).
* **File System:** Must be formatted as **exFAT** or **NTFS** (FAT32 cannot handle files over 4GB).

### **2. Windows Acquisition (Magnet RAM Capture)**
* **Tool:** `Magnet RAM Capture` (Standalone .exe).
* **Process:**
    1.  Copy the `.exe` to your USB stick.
    2.  Plug the stick into the live Windows machine.
    3.  **Run as Administrator**.
    4.  Select the USB stick as the output destination.
    5.  Click **Start**.

### **3. Linux Acquisition (AVML)**
* **Tool:** `AVML` (Microsoft Acquisition Tool for Vendor Memory Logs).
* **Process:**
    1.  Download the `avml` binary to your USB.
    2.  Mount the USB on the target: `mount /dev/sdb1 /mnt`.
    3.  Run the capture: `sudo ./avml /mnt/mem_dump.raw`.
    4.  Generate a hash: `sha256sum /mnt/mem_dump.raw > /mnt/mem_hash.txt`.

---

## 🔬 Analysis: How to investigate RAM on Ubuntu

Once you have the `.raw` dump on your USB, plug it into your Ubuntu machine. We use **Volatility 3** to investigate.

### **Volatility 3 Cheat Sheet**

**Identify the Operating System:**
```bash
vol -f /path/to/mem_dump.raw windows.info
```
**List Running Processes: Find out what was running (hidden malware often hides here):**
```bash
vol -f /path/to/mem_dump.raw windows.pslist
```
**View Network Connections: See active TCP/UDP connections:**
```bash
vol -f /path/to/mem_dump.raw windows.netstat
```
**Dump Password Hashes: Recover NTLM hashes from memory:**
```bash
vol -f /path/to/mem_dump.raw windows.hashdump
```

---

## ⚖️ Chain of Custody
Always document:
* **Date/Time** of acquisition.
* **Hash value** (SHA256) of the captured file.
* **Hardware details** of the target machine.
