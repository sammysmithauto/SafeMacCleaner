# Installation Guide

## Quick Installation

### Method 1: Direct Download
1. Download `SafeMacCleaner_Complete.command`
2. Make it executable:
   ```bash
   chmod +x SafeMacCleaner_Complete.command
   ```
3. Double-click to run or execute in terminal

### Method 2: Git Clone
```bash
git clone <repository-url>
cd SafeMacCleaner
chmod +x *.command
./SafeMacCleaner_Complete.command
```

## System Requirements

- **macOS:** 10.12 (Sierra) or later
- **Shell:** Bash (default on macOS)
- **Utilities:** Standard Unix tools (find, du, tmutil, md5)
- **Permissions:** Administrator access for system cache cleaning

## First Run Setup

1. **Choose App Protection:**
   - Script will scan all installed applications
   - Select which apps to protect using numbers (e.g., 1,3,5,12)
   - Protected apps' caches won't be deleted

2. **Review Configuration:**
   - Check settings at top of script
   - Enable dry run mode for first test: `DRY_RUN=true`

3. **Test Run:**
   - Use dry run mode to see what would be cleaned
   - Review the log file after completion

## Configuration Options

Edit the script to customize behavior:

```bash
KEEP_RECENT_DOWNLOADS=true    # Keep downloads from last 30 days
KEEP_IOS_BACKUPS=true        # Keep iOS device backups  
KEEP_RECENT_LOGS=true        # Keep logs from last 7 days
BACKUP_BEFORE_DELETE=true    # Create backup of important items
DRY_RUN=false               # Set to true for preview mode
KEEP_SNAPSHOTS=0            # Number of Time Machine snapshots to keep
ORGANIZE_FILES=true         # Organize Desktop and Downloads by date
MIN_FILE_SIZE_MB=100        # Minimum size for "big files" detection
```

## Troubleshooting

### Permission Issues
```bash
# Make script executable
chmod +x SafeMacCleaner_Complete.command

# If system cache cleaning fails, ensure you have admin rights
# Script will prompt for sudo password when needed
```

### Script Won't Start
```bash
# Check if bash is available
which bash

# Run with explicit bash
bash SafeMacCleaner_Complete.command
```

### Time Machine Issues
- Ensure Time Machine is not actively running
- Some snapshots may be system-protected and cannot be deleted

## Security Notes

- Script only deletes cache and temporary files
- Protected directories are never touched
- User confirmation required for all deletions
- Comprehensive logging of all operations
- Optional backup system for large files

## Uninstallation

To remove SafeMacCleaner:
1. Delete the script files
2. Remove any log files from Desktop
3. Remove any backup directories from Desktop

No system modifications are made that require special uninstallation.
