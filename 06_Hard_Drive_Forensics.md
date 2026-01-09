# 💾 Hard Drive Forensics: Acquisition & Analysis

This guide covers the professional process of seizing, imaging, and analyzing physical storage media (HDD, SSD, NVMe, and USB drives).

---

## 🏗️ Phase 1: Physical Seizure & Connection

### **The Hardware Write Blocker**
Before connecting a suspect's drive to your workstation, you **must** use a hardware write blocker (e.g., Tableau, WiebeTech).
* **Why:** Operating systems (Linux/Windows) automatically attempt to mount drives, which updates "Last Accessed" timestamps and writes system metadata (like `System Volume Information`).
* **The Goal:** Zero bits should be written to the source media.



---

## 💿 Phase 2: Forensic Imaging (Guymager)

We create a bit-by-bit copy of the drive. The industry standard format is **.E01** (Expert Witness Format) because it supports compression, internal metadata, and hash storage.

### **The Process**
1.  **Launch:** Open your terminal and type `sudo guymager`.
2.  **Identify:** Find your source drive (check the serial number and size to be 100% sure).
3.  **Acquire:** Right-click the drive -> **Acquire Image**.
4.  **Settings:**
    * **Format:** Linux Expert Witness Format (.E01).
    * **Destination:** An external "Evidence" drive (formatted as exFAT or NTFS).
    * **Hashing:** Check both **MD5** and **SHA-256**.
5.  **Info File:** Guymager generates a `.info` file containing the acquisition time, hardware details, and the final hash. **Store this file with your Chain of Custody.**

### **Hard Drive Checklist**

| Step | Action | Tool |
| :--- | :--- | :--- |
| **1** | Photograph drive and label with Item ID | Camera / Label Maker |
| **2** | Connect via Hardware Write Blocker | Tableau / WiebeTech |
| **3** | Create `.E01` Forensic Image | `guymager` |
| **4** | Verify Image Hash matches Source Hash | `sha256sum` |
| **5** | Perform automated analysis | `autopsy` |
| **6** | Manual file recovery (Carving) | `foremost` / `scalpel` |

---

## 🔍 Phase 3: Command Line Analysis (The Sleuth Kit)

Once you have your `.E01` file, you can analyze it on your workstation without the physical drive.

### **1. List Partitions**
Find the starting offset of the partitions within the image:
```bash
mmls evidence_image.E01
```
### **2. List Files (including deleted)**
Use the offset found in the previous step (replace `START_SECTOR` with the actual number):
```bash
# -r is recursive, -o is the offset
fls -r -o START_SECTOR evidence_image.E01
```
Note: Files marked with * are deleted but still exist in unallocated space.

### **3. Recover a Specific File**
Extract a file using its inode number:
```bash
icat -o START_SECTOR evidence_image.E01 <inode_number> > recovered_file.jpg
```
---

## 🖥️ Phase 4: Graphical Analysis (Autopsy)
Autopsy is the most powerful tool for deep analysis and reporting.

1. **Start Autopsy:** Type `autopsy` in the terminal.
2. **Access Web UI:** Open the URL provided in your browser (usually `http://localhost:9999/autopsy`).
3. **New Case:** Name the case and add your `.E01` as a Data Source.
4. **Ingest Modules:** Enable these for the best results:
   * **Recent Activity:** Extracts web history, cookies, and recent documents.
   * **Keyword Search:** Search the entire drive for strings like "password" or "confidential".
   * **Exif Parser:** Pulls GPS and camera metadata from image files.
   * **Encryption Detection:** Identifies BitLocker, FileVault, or VeraCrypt volumes.

---

## ⚖️ Chain of Custody Reminder
Every time you move the physical drive or the `.E01` image file, you must update your `Tracking Log`.
