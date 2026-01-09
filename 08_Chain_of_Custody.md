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
```
2. **Verify the Hash Before Every Analysis Session:** Before you open the file in Autopsy or Volatility, verify its integrity.
```bash
sha256sum -c evidence_dump.raw.sha256
```
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
