#!/bin/bash

# SafeMacCleaner Configuration Example
# Copy these settings to the top of your SafeMacCleaner script to customize behavior

# ===================================================================
# BASIC CONFIGURATION
# ===================================================================

# File retention settings
KEEP_RECENT_DOWNLOADS=true          # Keep downloads from last 30 days
KEEP_IOS_BACKUPS=true              # Keep iOS device backups
KEEP_RECENT_LOGS=true              # Keep logs from last 7 days

# Safety settings  
BACKUP_BEFORE_DELETE=true          # Create backup of important items (>1MB)
DRY_RUN=false                      # Set to true to preview actions without deleting

# Time Machine settings
KEEP_SNAPSHOTS=0                   # Number of snapshots to keep (0 = delete all)

# File organization settings
ORGANIZE_FILES=true                # Organize Desktop and Downloads by date
AUTO_DELETE_OLD_SAFE_FILES=true    # Auto-delete old cache/temp files (>30 days)
MARK_FOR_REVIEW=true               # Mark important files for manual review

# Advanced feature settings
MIN_FILE_SIZE_MB=100               # Minimum size for "big files" detection
DUPLICATE_MIN_SIZE_KB=1024         # Minimum size for duplicate detection

# Output settings
VERBOSE_OUTPUT=true                # Show detailed information

# ===================================================================
# EXAMPLE CONFIGURATIONS
# ===================================================================

# CONSERVATIVE SETUP (Safest)
# KEEP_RECENT_DOWNLOADS=true
# KEEP_IOS_BACKUPS=true  
# KEEP_RECENT_LOGS=true
# BACKUP_BEFORE_DELETE=true
# DRY_RUN=true
# KEEP_SNAPSHOTS=2
# AUTO_DELETE_OLD_SAFE_FILES=false

# AGGRESSIVE CLEANUP (Maximum space recovery)
# KEEP_RECENT_DOWNLOADS=false
# KEEP_IOS_BACKUPS=false
# KEEP_RECENT_LOGS=false  
# BACKUP_BEFORE_DELETE=false
# DRY_RUN=false
# KEEP_SNAPSHOTS=0
# AUTO_DELETE_OLD_SAFE_FILES=true

# BALANCED SETUP (Recommended)
# KEEP_RECENT_DOWNLOADS=true
# KEEP_IOS_BACKUPS=true
# KEEP_RECENT_LOGS=true
# BACKUP_BEFORE_DELETE=true
# DRY_RUN=false
# KEEP_SNAPSHOTS=1
# AUTO_DELETE_OLD_SAFE_FILES=true

# ===================================================================
# ADVANCED SETTINGS
# ===================================================================

# Big files detection thresholds
# MIN_FILE_SIZE_MB=50    # Find files larger than 50MB
# MIN_FILE_SIZE_MB=500   # Find files larger than 500MB
# MIN_FILE_SIZE_MB=1000  # Find files larger than 1GB

# Duplicate detection settings
# DUPLICATE_MIN_SIZE_KB=512   # Check files larger than 512KB
# DUPLICATE_MIN_SIZE_KB=2048  # Check files larger than 2MB
# DUPLICATE_MIN_SIZE_KB=5120  # Check files larger than 5MB
