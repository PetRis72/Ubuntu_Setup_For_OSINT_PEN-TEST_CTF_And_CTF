# 🧳 Forensic Go-Bag: 2026 Standard Equipment List

This list identifies the essential hardware and supplies required for a professional digital forensic field response. A 2026-standard bag focuses on **high-speed acquisition**, **physical integrity**, and **live-system stability**.

---

## 💻 1. The Forensic Workstation (Field Laptop)
The "Brain" of your operation. 
* **OS:** Dual-boot Ubuntu (Forensic-hardened) and Windows 11 (for specialized tools).
* **RAM:** Minimum 64GB (To handle large RAM dumps and Autopsy ingest).
* **Ports:** Multiple Thunderbolt 4/5 ports (for 40Gbps+ imaging speeds).
* **Storage:** 2TB NVMe internal (OS/Apps) + 4TB NVMe Scratch Space (Temp processing).

---

## ⚡ 2. Write-Blockers & Adapters
You cannot investigate what you cannot connect to safely.
* **Hardware Write-Blocker:** (e.g., Tableau T8u or TX1) Supports SATA, SAS, USB 3.0, and PCIe.
* **NVMe/M.2 Adapters:** Modern laptops use NVMe; you need specialized bridges to image these.
* **Apple T2/M1/M2/M3 Tether:** Specialized cables for "Target Disk Mode" acquisitions.



---

## 💾 3. Storage Media (The Evidence "Vaults")
* **Primary Evidence Drives:** 4x 8TB Rugged External HDDs (for large backups).
* **Fast Ingest SSDs:** 2x 4TB NVMe External SSDs (for speed-critical imaging).
* **Forensic Boot USBs:** 3x 128GB USB 3.1 sticks containing:
    * **Live Forensics OS:** (e.g., Kali or DEFT Zero).
    * **Capture Tools:** AVML, Magnet RAM Capture, FTK Imager Lite.

---

## 📸 4. Documentation & Physical Tools
* **Camera:** 4K Mirrorless or high-end smartphone with EXIF-tagging for the [Seizure Photography Checklist](./09_Seizure_Photography_Checklist.md).
* **Faraday Bags:** Various sizes to block cellular/Wi-Fi signals for mobile phones and tablets.
* **Tamper-Evident Supplies:** * Forensic Tape (Red/Void).
    * Numbered Tamper-Evident Bags (Anti-Static).
    * Permanent Markers (Ultra-fine and Thick).

---

## 🛠️ 5. The "Tactical" Kit
* **Mouse Jiggler:** To prevent a live system from sleeping/locking while you prepare for RAM capture.
* **USB Rubber Ducky / Bash Bunny:** (For authorized automated triage scripts).
* **Screwdriver Set:** Precision electronics kit (e.g., iFixit Pro Tech) for opening laptops/servers.
* **Atomic Clock / GPS Sync:** A dedicated device to verify the "True Time" against the system BIOS clock.

---

## 📋 Go-Bag Readiness Checklist

| Category | Item | Status |
| :--- | :--- | :---: |
| **Power** | Universal Travel Adapter + Power Strip | [ ] |
| **Integrity** | 50x Tamper-Evident Seals (Unused) | [ ] |
| **Storage** | 20TB Total Available Evidence Space | [ ] |
| **Network** | 10Gbps Ethernet Cables + USB-C Adapters | [ ] |
| **Cables** | USB-C to USB-A, Thunderbolt 4, Micro-B | [ ] |

---

## ⚠️ 2026 Pro-Tip: The "Hot-Swap" Power Supply
In 2026, many suspects use **Full Disk Encryption (FDE)**. If a laptop is seized while ON and UNLOCKED, you cannot let it die. 
* **Requirement:** Carry a high-capacity **Portable Power Station** (e.g., Jackery or Anker) to keep the device powered during transport to the lab. If the power cuts, the encryption locks the drive forever.
