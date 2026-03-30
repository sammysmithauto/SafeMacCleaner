#!/bin/bash

# ===================================================================
# SAFE MAC CLEANER
# Copyright (c) 2025 SAMUEL SMITH. All Rights Reserved.
# One tool. One job. Does it right.
# ===================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Variables
TOTAL_CLEANED=0
LOG_FILE=~/Desktop/safemaccleaner_$(date +%Y%m%d_%H%M%S).log

# ===================================================================
# PROTECTED PATHS - NEVER TOUCH
# ===================================================================
is_protected() {
    local path="$1"
    
    # Windsurf data
    [[ "$path" == *".codeium/windsurf"* ]] && return 0
    [[ "$path" == *"Application Support/Windsurf/User"* ]] && return 0
    
    # Application data
    [[ "$path" == *"Application Support"* ]] && return 0
    [[ "$path" == *"Preferences"* ]] && return 0
    
    # User files
    [[ "$path" == *"/Documents/"* ]] && return 0
    [[ "$path" == *"/Desktop/"* ]] && return 0
    [[ "$path" == *"/Pictures/"* ]] && return 0
    [[ "$path" == *"/Movies/"* ]] && return 0
    [[ "$path" == *"/Music/"* ]] && return 0
    
    # System
    [[ "$path" == "/System"* ]] && return 0
    [[ "$path" == "/Applications"* ]] && return 0
    [[ "$path" == *"/.ssh"* ]] && return 0
    
    # Databases
    [[ "$path" == *".db" ]] && return 0
    [[ "$path" == *".sqlite"* ]] && return 0
    
    return 1
}

# ===================================================================
# UTILITY FUNCTIONS
# ===================================================================
get_size_bytes() {
    if [ -e "$1" ]; then
        du -sk "$1" 2>/dev/null | awk '{print $1 * 1024}' || echo "0"
    else
        echo "0"
    fi
}

format_size() {
    local bytes=$1
    if [ "$bytes" -lt 1024 ]; then
        echo "${bytes}B"
    elif [ "$bytes" -lt 1048576 ]; then
        echo "$((bytes / 1024))KB"
    elif [ "$bytes" -lt 1073741824 ]; then
        printf "%.1fMB" $(echo "scale=1; $bytes / 1048576" | bc 2>/dev/null || echo "$((bytes / 1048576))")
    else
        printf "%.2fGB" $(echo "scale=2; $bytes / 1073741824" | bc 2>/dev/null || echo "$((bytes / 1073741824))")
    fi
}

get_disk_info() {
    df -h / | awk 'NR==2 {print $2, $3, $4}'
}

# ===================================================================
# HEADER
# ===================================================================
print_header() {
    clear
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}  ${GREEN}SAFE MAC CLEANER${NC}                                          ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}  $(date '+%Y-%m-%d %H:%M:%S')                                      ${BLUE}║${NC}"
    echo -e "${BLUE}╠════════════════════════════════════════════════════════════╣${NC}"
    
    read total used avail <<< $(get_disk_info)
    echo -e "${BLUE}║${NC}  ${CYAN}DISK:${NC} Macintosh HD                                         ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}  Total: $total | Used: $used | Free: $avail                  ${BLUE}║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# ===================================================================
# SCANNING FUNCTIONS
# ===================================================================
scan_time_machine() {
    local count=$(tmutil listlocalsnapshots / 2>/dev/null | wc -l | tr -d ' ')
    local size=0
    
    if [ "$count" -gt 0 ]; then
        # Estimate ~1-2GB per snapshot average
        size=$((count * 1500000000))
    fi
    
    echo "$size:$count"
}

scan_user_caches() {
    local size=0
    if [ -d "$HOME/Library/Caches" ]; then
        size=$(get_size_bytes "$HOME/Library/Caches")
    fi
    echo "$size"
}

scan_system_caches() {
    local size=0
    if [ -d "/Library/Caches" ]; then
        size=$(get_size_bytes "/Library/Caches")
    fi
    echo "$size"
}

scan_trash() {
    local size=0
    if [ -d "$HOME/.Trash" ]; then
        size=$(get_size_bytes "$HOME/.Trash")
    fi
    echo "$size"
}

scan_logs() {
    local size=0
    if [ -d "$HOME/Library/Logs" ]; then
        size=$(find "$HOME/Library/Logs" -type f -mtime +7 -exec du -sk {} + 2>/dev/null | awk '{sum+=$1} END {print sum*1024}')
        [ -z "$size" ] && size=0
    fi
    echo "$size"
}

scan_temp_files() {
    local size=0
    size=$(du -sk /private/var/folders 2>/dev/null | awk '{print $1 * 1024}' || echo "0")
    echo "$size"
}

scan_browser_caches() {
    local size=0
    local safari="$HOME/Library/Caches/com.apple.Safari"
    local chrome="$HOME/Library/Caches/Google/Chrome"
    local firefox="$HOME/Library/Caches/Firefox"
    
    [ -d "$safari" ] && size=$((size + $(get_size_bytes "$safari")))
    [ -d "$chrome" ] && size=$((size + $(get_size_bytes "$chrome")))
    [ -d "$firefox" ] && size=$((size + $(get_size_bytes "$firefox")))
    
    echo "$size"
}

scan_dev_caches() {
    local size=0
    local npm="$HOME/.npm/_cacache"
    local homebrew="$HOME/Library/Caches/Homebrew"
    local pip="$HOME/.cache/pip"
    local yarn="$HOME/.yarn/cache"
    
    [ -d "$npm" ] && size=$((size + $(get_size_bytes "$npm")))
    [ -d "$homebrew" ] && size=$((size + $(get_size_bytes "$homebrew")))
    [ -d "$pip" ] && size=$((size + $(get_size_bytes "$pip")))
    [ -d "$yarn" ] && size=$((size + $(get_size_bytes "$yarn")))
    
    echo "$size"
}

# ===================================================================
# CLEANING FUNCTIONS
# ===================================================================
clean_time_machine() {
    echo -e "${YELLOW}  Deleting Time Machine snapshots...${NC}"
    local snapshots=$(tmutil listlocalsnapshots / 2>/dev/null | grep "com.apple.TimeMachine")
    local count=0
    
    while IFS= read -r snapshot; do
        if [ -n "$snapshot" ]; then
            # Extract date: remove prefix and .local suffix
            local name=$(echo "$snapshot" | sed 's/com.apple.TimeMachine.//' | sed 's/.local$//')
            if [ -n "$name" ]; then
                tmutil deletelocalsnapshots "$name" 2>/dev/null && ((count++)) || true
            fi
        fi
    done <<< "$snapshots"
    
    echo -e "${GREEN}    Deleted $count snapshots${NC}"
}

clean_user_caches() {
    echo -e "${YELLOW}  Cleaning user caches...${NC}"
    if [ -d "$HOME/Library/Caches" ]; then
        find "$HOME/Library/Caches" -mindepth 1 -maxdepth 1 -type d | while read -r dir; do
            # Skip Windsurf
            if [[ "$dir" != *"windsurf"* ]] && [[ "$dir" != *"Windsurf"* ]]; then
                rm -rf "$dir"/* 2>/dev/null
            fi
        done
        echo -e "${GREEN}    Done${NC}"
    fi
}

clean_system_caches() {
    echo -e "${YELLOW}  Cleaning system caches...${NC}"
    if [ -d "/Library/Caches" ]; then
        sudo rm -rf /Library/Caches/* 2>/dev/null || true
        echo -e "${GREEN}    Done${NC}"
    fi
}

clean_trash() {
    echo -e "${YELLOW}  Emptying trash...${NC}"
    rm -rf "$HOME/.Trash"/* 2>/dev/null || true
    echo -e "${GREEN}    Done${NC}"
}

clean_logs() {
    echo -e "${YELLOW}  Cleaning old logs (>7 days)...${NC}"
    find "$HOME/Library/Logs" -type f -mtime +7 -delete 2>/dev/null || true
    find /var/log -type f -mtime +7 -delete 2>/dev/null || true
    echo -e "${GREEN}    Done${NC}"
}

clean_temp_files() {
    echo -e "${YELLOW}  Cleaning temp files...${NC}"
    sudo rm -rf /private/var/folders/*/* 2>/dev/null || true
    rm -rf /tmp/* 2>/dev/null || true
    echo -e "${GREEN}    Done${NC}"
}

clean_browser_caches() {
    echo -e "${YELLOW}  Cleaning browser caches...${NC}"
    rm -rf "$HOME/Library/Caches/com.apple.Safari"/* 2>/dev/null || true
    rm -rf "$HOME/Library/Caches/Google/Chrome"/* 2>/dev/null || true
    rm -rf "$HOME/Library/Caches/Firefox"/* 2>/dev/null || true
    echo -e "${GREEN}    Done${NC}"
}

clean_dev_caches() {
    echo -e "${YELLOW}  Cleaning developer caches...${NC}"
    rm -rf "$HOME/.npm/_cacache"/* 2>/dev/null || true
    rm -rf "$HOME/Library/Caches/Homebrew"/* 2>/dev/null || true
    rm -rf "$HOME/.cache/pip"/* 2>/dev/null || true
    rm -rf "$HOME/.yarn/cache"/* 2>/dev/null || true
    echo -e "${GREEN}    Done${NC}"
}

# ===================================================================
# MAIN
# ===================================================================
main() {
    print_header
    
    echo -e "${CYAN}SCANNING...${NC}"
    echo ""
    
    # Scan all locations
    tm_result=$(scan_time_machine)
    tm_size=$(echo "$tm_result" | cut -d: -f1)
    tm_count=$(echo "$tm_result" | cut -d: -f2)
    
    user_cache_size=$(scan_user_caches)
    system_cache_size=$(scan_system_caches)
    trash_size=$(scan_trash)
    logs_size=$(scan_logs)
    temp_size=$(scan_temp_files)
    browser_size=$(scan_browser_caches)
    dev_size=$(scan_dev_caches)
    
    # Calculate total
    total_cleanable=$((tm_size + user_cache_size + system_cache_size + trash_size + logs_size + temp_size + browser_size + dev_size))
    
    # Display results
    echo -e "${CYAN}CLEANABLE:${NC}"
    echo -e "  Time Machine Snapshots ($tm_count)  $(format_size $tm_size)"
    echo -e "  User Caches                  $(format_size $user_cache_size)"
    echo -e "  System Caches                $(format_size $system_cache_size)"
    echo -e "  Browser Caches               $(format_size $browser_size)"
    echo -e "  Developer Caches             $(format_size $dev_size)"
    echo -e "  Trash                        $(format_size $trash_size)"
    echo -e "  Old Logs                     $(format_size $logs_size)"
    echo -e "  Temp Files                   $(format_size $temp_size)"
    echo -e "  ${CYAN}─────────────────────────────────────${NC}"
    echo -e "  ${GREEN}TOTAL CLEANABLE:               $(format_size $total_cleanable)${NC}"
    echo ""
    
    echo -e "${YELLOW}PROTECTED (will not touch):${NC}"
    echo -e "  - Windsurf conversations & memories"
    echo -e "  - Application Support (all apps)"
    echo -e "  - Documents, Desktop, Pictures, Movies, Music"
    echo -e "  - Databases, SSH keys, preferences"
    echo ""
    
    # Get before stats
    read before_total before_used before_avail <<< $(get_disk_info)
    
    # Prompt
    echo -e "${YELLOW}[C]${NC} Clean All    ${YELLOW}[R]${NC} Report Only    ${YELLOW}[Q]${NC} Quit"
    echo ""
    read -p "Choice: " -n 1 -r choice
    echo ""
    echo ""
    
    case $choice in
        [Cc])
            echo -e "${GREEN}CLEANING...${NC}"
            echo "" | tee -a "$LOG_FILE"
            
            clean_time_machine 2>&1 | tee -a "$LOG_FILE"
            clean_user_caches 2>&1 | tee -a "$LOG_FILE"
            clean_system_caches 2>&1 | tee -a "$LOG_FILE"
            clean_browser_caches 2>&1 | tee -a "$LOG_FILE"
            clean_dev_caches 2>&1 | tee -a "$LOG_FILE"
            clean_trash 2>&1 | tee -a "$LOG_FILE"
            clean_logs 2>&1 | tee -a "$LOG_FILE"
            clean_temp_files 2>&1 | tee -a "$LOG_FILE"
            
            echo ""
            echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
            echo -e "${GREEN}CLEANING COMPLETE${NC}"
            echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
            echo ""
            
            # Get after stats
            sleep 2
            read after_total after_used after_avail <<< $(get_disk_info)
            
            echo -e "${CYAN}BEFORE:${NC} Used: $before_used | Free: $before_avail"
            echo -e "${CYAN}AFTER:${NC}  Used: $after_used | Free: $after_avail"
            echo ""
            echo -e "Log saved: $LOG_FILE"
            ;;
        [Rr])
            echo -e "${CYAN}Report saved to: $LOG_FILE${NC}"
            echo "SafeMacCleaner Report - $(date)" > "$LOG_FILE"
            echo "Total Cleanable: $(format_size $total_cleanable)" >> "$LOG_FILE"
            ;;
        [Qq]|*)
            echo "Exiting."
            exit 0
            ;;
    esac
}

main "$@"
