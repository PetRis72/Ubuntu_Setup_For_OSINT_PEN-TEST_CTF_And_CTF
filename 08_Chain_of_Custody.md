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

##🛡️ The 2026 "Golden Rules" Update

### **1. Remote Proof of Custody (Blockchain/Notary):** In 2026, simply saving a hash in a text file is weak. You should "notarize" the hash by sending it to a trusted third-party time-stamping service or a private ledger. This proves the hash existed at that exact second and hasn't been backdated.

### **2. Physical Memory State (Cold Boot Protection):** If a machine is on, you must verify the TPM (Trusted Platform Module) status. This proves the hardware hasn't been tampered with at the firmware level before you ran your tools.

### **3. Write-Blocking via Audit Logs:** Hardware write-blockers (like Tableau) now generate their own internal logs. You must export the **Write-Blocker** Log to prove the device was physically incapable of receiving data during your session.

## ⚖️ 2026 Zero-Trust Verification Workflow

To ensure evidence remains admissible against "AI-Manipulation" or "Timeline Tampering" defenses, follow these advanced steps.

### **1. Hardware Integrity (TPM & Firmware)**
Before imaging, check the Secure Boot and TPM status to ensure no rootkits are masking data.
* **Command:** `sudo dmidecode -t 17` (Check RAM serials match physical stickers).
* **Command:** `mokutil --sb-state` (Verify Secure Boot integrity).

### **2. Enhanced Digital Fingerprinting (HashDeep)**
Do not just hash the image; hash every individual file within the image to detect "surgical" tampering.
```bash
# Generate recursive hashes with audit logs
hashdeep -c sha256 -r /path/to/mounted/evidence > audit_log.txt
```

### **3. Remote Time-Stamping (RFC 3161)**
Use an external Time Stamping Authority (TSA) to prove your hash was generated at the seizure time.
```bash
# Example using OpenSSL to get a certified timestamp for your hash
openssl ts -query -data evidence.sha256 -cert -out evidence.tsr
```

## **4. Write-Blocker Audit Export**
If using a 2026-spec write blocker, connect via the management port and export the session log. This log must be attached to the CoC.


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

### 📊 The Comprehensive 2026 Chain of Custody Table
This version includes the **Audit ID** and **Seal Status** columns, which are now mandatory for high-security forensics.

| Date & Time (ISO) | Handled By | Action / Audit ID | Physical Seal # | Hash Verified? |
| :--- | :--- | :--- | :--- | :---: |
| 2026-01-09 10:00 | [Name] | Initial Seizure / `AID-99` | `SEAL-00123` | N/A |
| 2026-01-09 13:00 | [Name] | Transferred to Lab | `SEAL-00123` | YES |
| 2026-01-10 09:00 | [Analyst] | Imaging (Guymager) | **BROKEN**¹ | YES |
| 2026-01-10 17:00 | [Analyst] | Resealed after Imaging | `SEAL-00456` | YES |
| 2026-01-11 08:00 | [Admin] | Remote TSA Notarization | `SEAL-00456` | **CERTIFIED** |
¹ *Note: Seal broken for forensic imaging; original disk remained connected to hardware write-blocker.*

---

### 📝 Added Security Checklist
Ensure the "Zero-Trust" model is followed:

* [ ] **Camera Check:** Did I photograph the system clock of the suspect machine compared to my "atomic clock" (phone)?
* [ ] **Firmware Check:** Did I check for "Mouse Jigglers" or "Rubber Duckies" in hidden ports?
* [ ] **Notarization:** Has the master hash been uploaded to a time-stamped log or witness-signed ledger?
* [ ] **Read-Only:** Is the evidence file currently marked as `immutable`? (`sudo chattr +i evidence.e01`)

---

⚠️ Common Pitfalls & Defense Challenges
* **The "Admin" Mistake:** Never log in to a suspect's Windows/Linux account to "just check a file." This changes thousands of registry keys and timestamps. **Capture first**, analyze the copy later.
* **Broken Timeline:** If a device is moved and there is no entry for the person who transported it, the "Chain" is broken.
* **Write-Protection:** Connecting a disk to a Windows machine without a hardware Write Blocker will update the "Last Accessed" timestamps on the files. This is enough to get evidence thrown out of court.
* **File Permissions:** Always set your evidence files to **Read-Only** on your workstation to prevent accidental modification:
```bash
chmod 444 evidence_dump.raw
```
