# 🚀 Autopsy Optimization: Selective Ingest for Large Drives

When analyzing Terabyte-scale (TB+) evidence, running every Autopsy "Ingest Module" at once will freeze your workstation or take days to finish. This guide shows you how to prioritize data so you can start working immediately.

---

## ⏱️ The Triage Approach to Ingest

Instead of clicking "Select All" when adding a data source, use this three-phase approach to save time.

### **Phase 1: The "Quick Look" (5–15 Minutes)**
Enable only these modules to see the file structure and basic system info:
* **Recent Activity:** Extracts browser history, recent documents, and trash.
* **File Type Identification:** Essential for organizing files by category.
* **Encryption Detection:** Vital to know early if you are dealing with BitLocker or VeraCrypt.

### **Phase 2: The "Deep Dive" (1–4 Hours)**
Once you have explored the file system, run these manually on specific folders:
* **Exif Parser:** Pulls GPS and timestamps from photos.
* **Keyword Search (Targeted):** Search for specific names or terms rather than every word on the disk.
* **Email Parser:** If the user has Outlook/Thunderbird files.

### **Phase 3: The "Overnight" (12+ Hours)**
Run these only if you have the time or if the case specifically requires it:
* **PhotoRec Carver:** Searches for deleted files in unallocated space (extremely slow on TB drives).
* **Full Keyword Search:** Indexing every single string on a 4TB drive.



---

## 🛠️ How to Perform Selective Ingest

1.  **Add Data Source:** Follow the standard process of adding your `.E01` file.
2.  **Configure Ingest:** When the "Ingest Modules" window appears, click **Deselect All**.
3.  **Manual Selection:** Check only the **Phase 1** modules listed above.
4.  **Run:** Click Finish. You will see the file tree populate almost instantly.
5.  **Adding More Later:**
    * Right-click the **Data Source** in the left sidebar.
    * Select **Run Ingest Modules**.
    * Choose the **Phase 2** or **Phase 3** modules you need and click start.

---

## 📋 Ingest Priority Table

| Priority | Module Name | Resource Impact | Why? |
| :--- | :--- | :--- | :--- |
| **CRITICAL** | Recent Activity | Low | Shows what the user did last. |
| **HIGH** | Encryption Detection | Low | Determines if you can even see the data. |
| **MEDIUM** | Exif Parser | Medium | Great for mapping locations from photos. |
| **LOW** | Keyword Search | **Extreme** | Will slow down your CPU and RAM significantly. |
| **LOW** | PhotoRec Carver | **Extreme** | Scans every single byte for deleted fragments. |

---

## 💡 Performance Tips for Ubuntu

* **RAM Allocation:** Autopsy is Java-based. Ensure you have assigned enough memory in the settings (**Tools -> Options -> Ingest**).
* **SSD vs HDD:** Always store your **Autopsy Case Database** on an SSD, even if the Evidence Image is on a slow HDD. This makes browsing the results much faster.
* **CPU Threads:** Limit the number of ingest threads to `Total CPU Cores - 2` so your system remains responsive for other tasks.



---

## ⚖️ Integrity Note
Running ingest modules does **not** change the evidence. Autopsy works on the database it creates, leaving your `.E01` file untouched. Always verify your hash if you are in doubt!
