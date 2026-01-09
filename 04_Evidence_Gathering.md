# ⚖️ Evidence Gathering & Digital Forensics

This guide covers tools used for acquiring and preserving digital evidence in a forensically sound manner.

---

## 🛡️ Core Principles
1. **Never work on original media:** Always create a bit-by-bit copy (image).
2. **Verify Integrity:** Always use hashes (MD5/SHA256) to prove the evidence hasn't changed.
3. **Document Everything:** Keep a log of every command and action taken.

---

## 🛠️ Essential Tools

### **Guymager**
*A forensic imager for acquiring data from hard drives and USB sticks.*
* **Launch:** `sudo guymager`
* **Usage:** Select the drive, right-click and choose "Acquire Image." This creates an `.E01` or `.dd` file that preserves every bit of the original drive.

### **Autopsy**
*The premier open-source graphical interface for The Sleuth Kit.*
* **Launch:** `autopsy`
* **Usage:** It runs a local web server. Open the link provided in your browser. You can then "Add Data Source" (the image you created with Guymager) to analyze web history, deleted files, and registry keys.



### **Hashdeep**
*Verify that files have not been altered.*
* **Generate hashes for a folder:** `hashdeep -rl /path/to/evidence > manifest.txt`
* **Verify hashes later:** `hashdeep -rl -vv -k manifest.txt /path/to/evidence`

### **The Sleuth Kit (TSK)**
*Command-line tools for investigating disk images.*
* **fls:** List files and directories in an image (including deleted ones).
  * `fls -r evidence.dd`
* **icat:** Extract a specific file from an image based on its inode.
  * `icat evidence.dd <inode_number> > recovered_file.jpg`

---

## 📋 Evidence Checklist

| Task | Tool | Command/Method |
| :--- | :--- | :--- |
| **Imaging** | Guymager | `sudo guymager` |
| **Hashing** | Hashdeep | `hashdeep <file>` |
| **Analysis** | Autopsy | `autopsy` |
| **Metadata** | ExifTool | `exiftool <file>` |
| **String Search** | Grep/Strings | `strings <image> \| grep "password"` |

---

> **Pro Tip:** When gathering evidence from a live system, remember the **Order of Volatility**. Capture RAM (Memory) first, as it disappears when the power is cut!
