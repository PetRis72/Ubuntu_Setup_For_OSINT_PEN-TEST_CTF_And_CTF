# 📱 iOS Forensic Investigation (iOS 26.1 Ready)

Investigating iPhones in 2026 requires a "Live First" approach. With the introduction of iOS 26, Apple has increased encryption entropy and implemented "Sanitization on Reboot," which wipes certain diagnostic logs during a restart.

---

## 🛡️ The 2026 Golden Rules for iPhone
1. **Never Reboot if Possible:** iOS 26.1 overwrites the `shutdown.log` and other forensic artifacts upon reboot. If the device is ON, keep it ON.
2. **Isolate Immediately:** Use a **Faraday Bag** or enable Airplane Mode. Prevent "Remote Wipe" commands via iCloud.
3. **Capture RAM/Live Data First:** Use triage tools before the device hits "Before First Unlock" (BFU) state.

---

## 🔍 Investigation States: BFU vs. AFU

| State | Description | Forensic Value |
| :--- | :--- | :--- |
| **AFU (After First Unlock)** | The user has entered the passcode since the last boot. | **HIGH.** Most data is decrypted in memory. |
| **BFU (Before First Unlock)** | The device was just turned on or rebooted. | **LOW.** Only limited system files and metadata are available. |

---

## 🛠️ 2026 Toolset & Commands

### **1. Rapid Triage (Live System)**
If the device is unlocked (AFU), use **UAC (Unix Artifacts Collector)** to pull critical logs immediately.
```bash
# Run UAC via a connected Forensic Mac/Linux workstation
./uac -p ios_triage /mnt/iphone_mount
```

### **2. Checkm8 & Legacy Exploits (2026 Status)**
The `checkm8` exploit still works on older hardware (iPhone X and older) regardless of the iOS version.

* **Tool:** `palera1n` or `Belkasoft X`.
* **Use Case:** Full file system and keychain extraction on older "Secondary" evidence devices.

### **3. Advanced 2026 Tools (Commercial)**

* **Magnet GrayKey / VeraKey:** The primary tools for bypassing passcodes on modern iPhone 15/16/17+ running iOS 26.
* **Cellebrite UFED:** Essential for decoding encrypted app data (Signal, WhatsApp, Telegram).

## 📝 iOS Seizure Checklist

* [ ] **Physical Check:** Look for "Sticky Notes" with passcodes or FaceID bypass patterns.
* [ ] **Biometric Status:** If the user is present, document if FaceID/TouchID is enabled (legal requirements vary).
* [ ] **Emergency SOS:** Be aware that triggering "Emergency SOS" (pressing power 5 times) instantly disables Biometrics and requires a passcode.
* [ ] **Charging:** Use a portable power bank. If the battery dies, the device enters BFU state and encryption hardens.

---

## 🧪 Technical Verification: Lockdown Certificates
If you can pair the iPhone with a "Trusted" computer (e.g., the suspect's laptop), you can extract a **Lockdown Certificate**.

* **Action:** Copy the `.plist` files from `/var/db/lockdown/` (on macOS) or `C:\ProgramData\Apple\Lockdown` (on Windows).
* **Benefit:** These certificates allow you to bypass the "Trust This Computer" prompt on your forensic workstation.

