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

**List Running Processes: Find out what was running (hidden malware often hides here):**
```bash
vol -f /path/to/mem_dump.raw windows.pslist

**View Network Connections: See active TCP/UDP connections:**
```bash
vol -f /path/to/mem_dump.raw windows.netstat

**Dump Password Hashes: Recover NTLM hashes from memory:**
```bash
Dump Password Hashes: Recover NTLM hashes from memory:

---

## ⚖️ Chain of Custody
Always document:
* **Date/Time** of acquisition.
* **Hash value** (SHA256) of the captured file.
* **Hardware details** of the target machine.

---

## 📑 Chain of Custody (CoC) Guide & Template
The Chain of Custody is the most critical part of digital forensics. It is a chronological written record of those who have had custody of the evidence from the moment it is collected until it is presented in a legal or administrative proceeding.

**🛡️ The Golden Rules of CoC **
1. **Never Work on Original Media:** Always create a bit-by-bit forensic image and work only on the copy.
2. **Verify Integrity:** Generate a cryptographic hash (SHA-256) immediately after acquisition.
3. **Document Everything:** If it isn't documented, it didn't happen. Every transfer of evidence must be signed and dated.
4. **Secure Storage:** Evidence must be stored in a tamper-evident bag or a locked, access-controlled environment.

**🛠️ Technical Verification (On Ubuntu)**
To maintain the "Digital Chain of Custody," you must verify that the evidence file has not changed over time.

1. **Create the Initial Hash:** Run this as soon as the acquisition (RAM or Disk) is finished.
```bash
sha256sum evidence_dump.raw > evidence_dump.raw.sha256

2. **Verify the Hash Before Every Analysis Session:** Before you open the file in Autopsy or Volatility, verify its integrity.
```bash
sha256sum -c evidence_dump.raw.sha256 
If the output is `OK`, the evidence is intact. If it fails, the evidence is "contaminated" and no longer reliable.

---

## 📝 Chain of Custody Template
Copy and use this template for every item seized.

***Case Information:***

* **Case ID:** ____________________
* **Investigator:** ____________________
* **Location of Seizure:** ____________________

Evidence Description:

* **Item ID:** ITEM-001
* **Description:** (e.g., 500GB Samsung SSD, Serial Number: XYZ123)
* **Status:** (Powered ON / Powered OFF / Locked)
* **Acquisition Hash (SHA-256):** `[Insert Hash Here]`

### **Evidence Tracking Log**

| Date & Time | Handled By | Action Taken | Location | Signature/ID |
| :--- | :--- | :--- | :--- | :--- |
| 2026-01-09 10:00 | [Name] | Evidence seized and hashed | [Site Location] | [Initials] |
| 2026-01-09 12:30 | [Name] | Locked in Evidence Safe #1 | Forensics Lab | [Initials] |
| 2026-01-10 09:00 | [Name] | Removed for forensic imaging | Workstation 01 | [Initials] |
| 2026-01-10 17:00 | [Name] | Returned to Evidence Safe #1 | Forensics Lab | [Initials] |

---
## ⚠️ Common Pitfalls

* **Broken Links:** If there is a gap in the timeline (e.g., evidence was out of the safe for 48 hours without a name attached), the evidence is often dismissed.

* **Write-Protection:** Connecting a disk to a Windows machine without a hardware Write Blocker will update the "Last Accessed" timestamps on the files, destroying the original metadata. Always use a write blocker!
