# 💾 Hard Drive Forensics: Acquisition & Analysis (High Capacity)

This guide covers the professional process of seizing, imaging, and analyzing storage media, ranging from small USB drives to multi-terabyte (TB) HDD/SSD arrays.

---

## 🏗️ Phase 1: Physical Seizure & Hardware

When dealing with modern hard drives, data volume is the biggest challenge. A single drive can now reach 20TB+.

### **The Forensic Toolkit**
* **Write Blocker:** (Mandatory) Hardware like **Tableau** or **WiebeTech** to prevent metadata alteration.
* **Destination Storage:** Use external drives (8TB+) formatted as **exFAT** or **NTFS**. **Avoid FAT32** (4GB file limit).
* **UPS (Power):** For drives >1TB, use an Uninterruptible Power Supply. Imaging can take 24+ hours; a power flicker will ruin the process.



---

## 💿 Phase 2: Forensic Imaging (Guymager)

For large drives, we use the **.E01 (Expert Witness Format)**. Unlike raw `.dd` files, `.E01` compresses data and skips empty blocks, saving massive amounts of space.

### **The Process for Large Media**
1.  **Launch:** `sudo guymager`.
2.  **Acquire Image:** Right-click the source drive.
3.  **Settings for TB+ Drives:**
    * **Format:** Linux Expert Witness Format (.E01).
    * **Compression:** Set to "Fast" or "Best". This can reduce a 1TB drive (with 200GB data) down to a ~180GB file.
    * **Split Files:** Set to **2048 MiB** or **4096 MiB**. Splitting makes it easier to move the evidence between drives or upload it to servers.
4.  **Hashing:** Always verify with **SHA-256**.



---

## 🔍 Phase 3: Triage vs. Full Imaging

If a drive is too large (e.g., a 60TB RAID array) and time is limited, use **Forensic Triage**:

| Method | Target | Tool |
| :--- | :--- | :--- |
| **Full Image** | Every single bit (including deleted space) | `guymager` |
| **Logical Image** | Only existing files/folders | `mount -r` & `rsync` |
| **Targeted Triage** | Registry, $MFT, Logs, User Profile | `KAPE` or custom scripts |

---

## 🔬 Phase 4: Analysis with The Sleuth Kit (TSK)

Analyze the `.E01` image on your Ubuntu workstation.

### **1. Inspecting Partitions**
Large drives often use GPT partitions. Identify them with:
```bash
mmls evidence_image.E01
```
### **2. Deep File Analysis**
If you need to find files by type (e.g., all JPGs) even if they were deleted:
```bash
# Using foremost to 'carve' files from the image
foremost -i evidence_image.E01 -o /path/to/output
```

### **3. Mounting for Rapid Review**
You can mount an `.E01` file as a read-only device to browse it like a normal folder:
```bash
ewfmount evidence_image.E01 /mnt/ewf
mount -o loop,ro,show_sys_files /mnt/ewf/ewf1 /mnt/analysis
```

### **4. List Files (including deleted)**
Use the offset found in the previous step (replace START_SECTOR with the actual number):
```bash
# -r is recursive, -o is the offset
fls -r -o START_SECTOR evidence_image.E01
```
Note: Files marked with `*` are deleted but still exist in unallocated space.

**Recover a Specific File**
Extract a file using its inode number:
```bash
icat -o START_SECTOR evidence_image.E01 <inode_number> > recovered_file.jpg
```

---

## 🖥️ Phase 5: Graphical Analysis (Autopsy)
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

### 📋 Hard Drive Checklist (High Capacity)

| Step | Action | Tool / Requirement |
| :--- | :--- | :--- |
| **1** | Verify Destination Space (2x Source Size) | `df -h` |
| **2** | Connect via Hardware Write Blocker | USB 3.0 or Thunderbolt |
| **3** | Start `.E01` Imaging with Compression | `guymager` |
| **4** | Store `.info` file with SHA-256 Hash | Documentation |
| **5** | Run Autopsy Ingest (Overnight for TB+) | `autopsy` |
| **6** | Update Tracking Log | [Chain of Custody](./Chain_of_Custody.md) |

---

## ⚖️ Chain of Custody Reminder
Every time you move the physical drive or the `.E01` image file, you must update your `Tracking Log`.
