# 📑 Universal Chain of Custody (CoC) Guide & Template

The Chain of Custody is a legal safeguard. If the chain is broken, or a gap is found in the timeline, the evidence is considered "spoiled" and will likely be dismissed in court or during administrative hearings.

---

## 🛡️ The Golden Rules of Forensic Custody

### **1. The Principle of Integrity**
* **Never Work on Original Media:** Always create a bit-by-bit forensic image (`.E01` or `.raw`) and work only on the copy.
* **Verify Integrity:** Generate a cryptographic hash (SHA-256) immediately after acquisition.

### **2. Document the "Pre-Seizure" State**
* **Photograph Everything:** Before touching a machine, photograph the screen (if on), the back (cables/ports), and all serial number stickers.
* **Environment:** Note the room temperature, if the device was hot to the touch, and if any peripherals (USB sticks, Mouse Jigglers) were connected.

### **3. Physical Security**
* **Tamper-Evident Bags:** Once seized, items must go into an anti-static, tamper-evident bag.
* **Seal Numbers:** Every bag has a unique serial number. If you open the bag for imaging, you must record the **old seal number** being broken and the **new seal number** applied.



---

## 🛠️ Technical Verification (Ubuntu Commands)

**1. Create the Master Hash:**
Run this immediately after the acquisition (RAM or Disk) is finished.
```bash
# Generate SHA-256 for the evidence file
sha256sum evidence_dump.raw > evidence_dump.raw.sha256
```

**2. Verify the Chain (Digital):**
Run this before every analysis session to prove the file hasn't changed by a single bit.
```bash
sha256sum -c evidence_dump.raw.sha256
```

---

## 📝 Universal Evidence Template
Create a new copy of this section for every item seized (Item-001, Item-002, etc).

**Section A:** Item Identification
* **Case ID:** `[e.g., 2026-NY-001]`
* **Item ID:** `ITEM-_______`
* **Description:** `[e.g., 2TB Western Digital HDD / Serial: XYZ123]`
* **Tamper Seal #:** `[Initial Seal Number]`
* **Witnesses:** `[List any persons present during seizure]`

**Section B: Acquisition Details**
* **Date/Time of Seizure:** `YYYY-MM-DD HH:MM`
* **System Status:** `[Powered ON / Powered OFF / Sleep / Damaged]`
* **Capture Tool Used:** `[e.g., Guymager v0.8.12]`
* **Final Acquisition Hash (SHA-256):** `[Paste the 64-character hash here]`

**Section C: Evidence Tracking Log**
This table tracks the Physical movement and Digital access.
### **Section C: Evidence Tracking Log**

| Date & Time (ISO) | Handled By | Action Performed | Current Location | Hash Verified? |
| :--- | :--- | :--- | :--- | :---: |
| 2026-01-09 10:00 | [Name] | Evidence seized, bagged, and hashed | [Site Address] | N/A |
| 2026-01-09 13:00 | [Name] | Transported to Lab; Placed in Safe #1 | [Forensics Lab] | YES |
| 2026-01-10 09:00 | [Analyst] | Removed for forensic imaging | [Workstation 01] | YES |
| 2026-01-10 17:00 | [Analyst] | Imaging finished; Returned to Safe #1 | [Forensics Lab] | YES |
| 2026-01-11 10:00 | [Analyst] | Bag opened for physical inspection | [Workstation 01] | N/A |

---

⚠️ Common Pitfalls & Defense Challenges
* **The "Admin" Mistake:** Never log in to a suspect's Windows/Linux account to "just check a file." This changes thousands of registry keys and timestamps. **Capture first**, analyze the copy later.
* **Broken Timeline:** If a device is moved and there is no entry for the person who transported it, the "Chain" is broken.
* **Write-Protection:** Connecting a disk to a Windows machine without a hardware Write Blocker will update the "Last Accessed" timestamps on the files. This is enough to get evidence thrown out of court.
* **File Permissions:** Always set your evidence files to **Read-Only** on your workstation to prevent accidental modification:
```bash
chmod 444 evidence_dump.raw
```
