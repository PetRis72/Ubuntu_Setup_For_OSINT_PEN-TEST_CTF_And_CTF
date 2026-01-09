# 💻 Terminal & Quality of Life Guide

This guide explains the modern CLI tools and terminal enhancements installed to make your workflow faster and more efficient.

---

## 🎨 The Environment

### **Zsh & Oh My Zsh**
Your shell has been upgraded from `bash` to `zsh`, featuring the **Kali Linux theme**.
* **Auto-suggestions:** Start typing a command, and it will suggest the rest based on your history (press `Right Arrow` to accept).
* **Syntax Highlighting:** Commands turn green if valid and red if invalid before you even press Enter.
* **Powerline Fonts:** Essential for displaying icons (like the "skull" icon or git branch symbols) in the prompt.

---

## 🚀 Modern CLI Replacements

### **bat (The "cat" replacement)**
A `cat` clone with syntax highlighting and Git integration.
* **Usage:** `bat filename.py`
* **Why:** It detects file types automatically and adds line numbers and colors, making code much easier to read.
* **Note:** The script adds an alias so you can just type `bat` instead of `batcat`.

### **fzf (Fuzzy Finder)**
An interactive Unix filter for command-line that can search through files, command history, and more.
* **Search History:** Press `CTRL+R` to search your command history with a fuzzy filter.
* **Search Files:** Type `fzf` in any directory to interactively find files.

### **tldr (Simplified Man Pages)**
Standard `man` pages are often too long. `tldr` gives you practical examples immediately.
* **Usage:** `tldr nmap` or `tldr tar`
* **Why:** It skips the fluff and shows you the most common ways to use a command.

---

## 📊 System Monitoring

### **btop / htop**
Interactive system monitors for processes, memory, and network usage.
* **Usage:** Type `btop` for the modern, dashboard-style UI or `htop` for the classic view.
* **Features:** You can kill processes, sort by CPU/RAM usage, and monitor system temperatures directly from the terminal.



---

## 📋 Quick Reference Table

| Command | Purpose | Modern Alternative to... |
| :--- | :--- | :--- |
| `bat` | View files with colors/lines | `cat` |
| `btop` | Advanced system monitoring | `top` |
| `tldr` | Quick command examples | `man` |
| `fzf` | Interactive fuzzy search | `find` / `grep` |
| `zsh` | Your new power-shell | `bash` |

---

## ⌨️ Useful Keyboard Shortcuts

* `CTRL + R`: Search command history (`fzf`).
* `Right Arrow`: Accept zsh auto-suggestion.
* `TAB`: Trigger enhanced zsh completion menu.
* `CTRL + L`: Clear the screen.

