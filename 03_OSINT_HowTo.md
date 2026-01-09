# 🔍 OSINT Quick Start Guide

This guide provides basic usage examples for the Open Source Intelligence (OSINT) tools included in this setup.

---

## 👤 Identity & Social Media

### **Sherlock**
*Find usernames across hundreds of social networks.*
* **Search for a username:** `sherlock username`
* **Save results to a folder:** `sherlock username --folderout ./results`

---

## 🌐 Domain & Infrastructure Recon

### **Amass**
*In-depth sub-domain enumeration and network mapping.*
* **Passive discovery:** `amass enum -passive -d example.com`
* **Active enumeration:** `amass enum -active -d example.com -ip`

### **TheHarvester**
*Gather emails, subdomains, and employee names.*
* **Search via Google:** `theHarvester -d example.com -l 500 -b google`
* **Search all sources:** `theHarvester -d example.com -b all`

### **Sublist3r**
*Fast sub-domain enumeration using multiple search engines.*
* **Basic scan:** `sublist3r -d example.com`

---

## 🤖 Automated Intelligence

### **SpiderFoot**
*Automation tool with a web interface.*
* **Start the web UI:** `spiderfoot -l 127.0.0.1:5001`
* **Usage:** Open `http://127.0.0.1:5001` in your browser to start a new scan.

### **Recon-ng**
*A full-featured reconnaissance framework.*
* **Launch:** `recon-ng`
* **Workflow:** Load modules, set a source (like a domain), and type `run`.

---

## 🕵️ Privacy & Anonymity

### **Tor & Proxychains4**
*Mask your identity during scans.*
* **Start Tor:** `sudo systemctl start tor`
* **Run any tool through Tor:** `proxychains4 <tool_command>`
* **Example:** `proxychains4 nmap -sT -PN example.com`

---

## 🛠 Utilities

### **Whois**
*Check domain registration details.*
* **Query:** `whois example.com`

### **Dig**
*Advanced DNS querying.*
* **Find all records:** `dig example.com ANY`

