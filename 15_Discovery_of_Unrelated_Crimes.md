# ⚖️ Protocol: Discovery of Unrelated or Greater Crimes (Norway/EU)

What happens when a Private Investigator (PI) looking for "Crime A" stumbles upon evidence of "Crime B"? In Norway, this is a high-risk situation that can lead to "Evidence Poisoning" if not handled correctly.

---

## 🛑 1. The Immediate "Stop-Work" Rule
In Norway, a private investigator has **no police authority**. If you find evidence of a serious crime (e.g., Child Abuse Material (CSAM), Terrorism, or Murder):

1.  **Stop immediately.** Do not browse further. Every click you make as a private citizen could be argued as "tampering" or "illegal searching."
2.  **Snapshot the state.** Document exactly what was on the screen at the moment of discovery using the [Seizure Photography Checklist](./Seizure_Photography_Checklist.md).
3.  **Hash the current state.** If possible, run a hash on the current directory or memory dump to prove you didn't add the files.

---

## 🇳🇴 2. Duty to Report vs. Duty of Confidentiality

In Norway, you are caught between two sets of laws:

### **A. Duty to Avert (Avvergingsplikten - Straffeloven § 196)**
This is the most important law in Norway. It **overrides** your contract of confidentiality with your client. If you discover a crime that is **ongoing** or **planned** (like a physical attack, sabotage of critical infrastructure, or serious sexual crimes), you have a **legal duty to report it to the Police (112)**. 
* *Failure to report a crime covered by § 196 is itself a crime.*

### **B. Accidental Discovery (Slippfangst)**
If the crime is in the past and not "serious" enough to trigger § 196, you generally owe a duty of confidentiality to your client. However, you must advise your client that the evidence exists.

---

## 🛠️ 3. The 2026 "Clean Team" Procedure

If you find a "Greater Crime," follow these 2026-standard steps to ensure the evidence remains admissible for the police:

| Step | Action | Why? |
| :--- | :--- | :--- |
| **1. Isolate** | Lock the device/image. Do not touch it again. | To prevent "Private Party" evidence contamination. |
| **2. Log** | Create a "Discovery Entry" in the [Chain of Custody](./Chain_of_Custody.md). | To show exactly when the scope of the investigation changed. |
| **3. Consult** | Contact a lawyer (Advokat) immediately. | To determine if "Avvergingsplikten" (Duty to Avert) applies. |
| **4. Handover** | Contact the Police (Kripos for digital crimes). | The police will take over and perform their own forensic acquisition. |

---

## ⚠️ 4. The Risk of "Poisoned Fruit"
If you, as a private actor, continue to investigate a crime that should have been reported to the police, the defense lawyer will argue that you acted as an "Agent of the State" without having the legal authority. 

**Result:** The evidence could be ruled inadmissible in a Norwegian court (**Bevisavskjæring**).

---

## 📋 Checklist for Discovery of "Greater Crime"

- [ ] **Did I stop as soon as I realized what it was?**
- [ ] **Is the crime covered by Straffeloven § 196?** (Violence, Terrorism, CSAM, etc.)
- [ ] **Have I documented the 'Point of Discovery' without viewing more files?**
- [ ] **Have I secured the hashes to prove I didn't 'plant' the evidence?**
- [ ] **Has a lawyer been consulted regarding the duty of confidentiality?**

---

## 🔗 Norwegian Legal References
* **Straffeloven § 196:** [Plikt til å avverge et straffbart forhold](https://lovdata.no/lov/2005-05-20-28/§196)
* **Straffeprosessloven:** Rules for how the police take over evidence.
