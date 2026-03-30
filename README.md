# SafeMacCleaner

Professional macOS System Cleaner with Advanced Features

Copyright © 2025 SAMUEL SMITH. [cite_start]All Rights Reserved. [cite: 570]

---

## 🚀 Overview
SafeMacCleaner is a comprehensive macOS cleaning utility engineered to safely remove redundant system files while protecting critical applications and user data. It serves as a unified maintenance tool that combines standard system cleanup with advanced disk analysis and privacy protection.

---

## ✨ Key Features

### 🧹 Core Maintenance
* [cite_start] Time Machine Management: Uses `tmutil` to identify and delete local snapshots, recovering significant disk space[cite: 582, 590].
* [cite_start] Intelligent Cache Cleaning: Safely targets User and System library caches while preserving application-critical data[cite: 595, 598].
* Developer Cleanup: Dedicated routines for clearing `npm`, `yarn`, `pip`, and `poetry` caches.
* File Organization: Automatically analyzes and organizes the Desktop and Downloads folders based on file age (30+ days).

### 🔍 Advanced Disk Analysis
* Duplicate Finder: Employs MD5 checksum-based detection to identify identical files across the system.
* Big Files Finder: Scans and sorts files larger than 100MB to identify primary storage consumers.
* Privacy Protector: Removes browser history, cookies, and system recent items from Safari, Chrome, and Firefox.

---

## 🛡️ Safety & Protection Logic
Safety is the core architectural principle of this tool. It includes several layers of protection to prevent accidental data loss:

* [cite_start] Protected Directories: The `is_protected()` function hard-codes safety for essential user folders including Documents, Desktop, Pictures, Movies, and Music[cite: 572].
* [cite_start] Application Safeguards : Includes specific logic to protect sensitive application data, such as app conversations and memories[cite: 571].
* Dry Run Mode: Allows users to preview exactly what would be deleted without making any actual changes to the file system.
* User-Controlled Selection: Features a dynamic app protection system where users manually select which applications to exempt from cache cleaning.

---

## 🛠️ Technical Stack
* [cite_start] OS: macOS 10.12 (Sierra) or later[cite: 568].
* Language: Bash.
* [cite_start]Unix Utilities: Deep integration with `find`, `du`, `tmutil`, and `md5`[cite: 568].
* [cite_start]Permissions: Requires Administrator privileges for system-level cache operations[cite: 568].

---

## 💻 Quick Start

1. Make the script executable:
   ```bash
   chmod +x SafeMacCleaner_Complete.command
   ```

2. Run the application:
   ```bash
   ./SafeMacCleaner_Complete.command
   ```

---

## 📝 License & Disclaimer
[cite_start] MIT License  [cite: 562]
[cite_start]Copyright (c) 2025 SAMUEL SMITH [cite: 562]

⚠️ Important: This software performs system cleaning operations. Users are responsible for backing up important data before use. [cite_start]The author is not liable for data loss or system damage[cite: 565, 567].
