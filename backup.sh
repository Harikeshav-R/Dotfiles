#!/usr/bin/env bash

# Interactive macOS Backup Script
# Created for Harikeshav to backup data before Mac Reset
# Target Volume: /Volumes/Sandisk/Backup 05-21-26

set -euo pipefail

# ANSI color codes
NC='\033[0m'
BOLD='\033[1m'
CYAN='\033[36m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'

BACKUP_DIR="/Volumes/Sandisk/Backup 05-21-26"
USER_HOME="/Users/hari"

echo -e "${CYAN}${BOLD}====================================================${NC}"
echo -e "${CYAN}${BOLD}    Interactive macOS Pre-Reset Backup Utility       ${NC}"
echo -e "${CYAN}${BOLD}====================================================${NC}"
echo -e "Destination: ${BOLD}${BACKUP_DIR}${NC}\n"

# Verify backup destination exists or try to create it
if [ ! -d "$BACKUP_DIR" ]; then
    echo -e "${YELLOW}Warning: Destination directory does not exist. Attempting to create it...${NC}"
    mkdir -p "$BACKUP_DIR"
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error: Could not create backup folder. Is the Sandisk drive mounted and writable?${NC}"
        exit 1
    fi
fi

# Helper to get human-readable size of directory
get_size() {
    local path="$1"
    if [ -e "$path" ]; then
        local size
        size=$(du -sh "$path" 2>/dev/null | cut -f1 || true)
        if [ -z "$size" ]; then
            echo "unknown"
        else
            echo "$size"
        fi
    else
        echo "0B"
    fi
}

get_histories_size() {
    local files=()
    # Find matching files using a loop to avoid empty glob issues
    for f in $USER_HOME/.*history $USER_HOME/.histfile; do
        if [ -f "$f" ]; then
            files+=("$f")
        fi
    done
    if [ ${#files[@]} -eq 0 ]; then
        echo "0B"
    else
        local size
        size=$(du -ch "${files[@]}" 2>/dev/null | tail -n 1 | cut -f1 || true)
        echo "${size:-0B}"
    fi
}

get_home_files_size() {
    local files=()
    for f in "$USER_HOME/.aerospace.toml" "$USER_HOME/crossover.sh" "$USER_HOME/neovide.lua" "$USER_HOME/.wakatime.cfg"; do
        if [ -f "$f" ]; then
            files+=("$f")
        fi
    done
    if [ -d "$USER_HOME/.docker" ]; then
        files+=("$USER_HOME/.docker")
    fi
    if [ ${#files[@]} -eq 0 ]; then
        echo "0B"
    else
        local size
        size=$(du -ch "${files[@]}" 2>/dev/null | tail -n 1 | cut -f1 || true)
        echo "${size:-0B}"
    fi
}

# Queue for folders to be backed up
# Each entry: "source_path|relative_dest_path|display_name|exclude_type"
# Exclude types: 
#   none: no excludes
#   dev: exclude node_modules, target, venv, etc.
#   config: exclude raycast in .config
#   large: warning about size
declare -a BACKUP_QUEUE

add_to_queue() {
    local src="$1"
    local rel_dest="$2"
    local name="$3"
    local exclude_type="$4"
    BACKUP_QUEUE+=("$src|$rel_dest|$name|$exclude_type")
}

# 1. Critical configuration files
add_to_queue "$USER_HOME/.ssh" "dotfiles/.ssh" "SSH Keys & Configuration" "none"
add_to_queue "$USER_HOME/.gitconfig" "dotfiles/.gitconfig" "Global Git Config" "none"
add_to_queue "$USER_HOME/Developer/Dotfiles" "Developer/Dotfiles" "Developer Dotfiles Repository (Local)" "none"

# 2. Main Developer folders
add_to_queue "$USER_HOME/Developer" "Developer" "Developer Projects Folder" "dev"

# 3. Personal data folders
add_to_queue "$USER_HOME/Documents" "Documents" "Documents Folder" "none"
add_to_queue "$USER_HOME/Desktop" "Desktop" "Desktop Folder" "none"
add_to_queue "$USER_HOME/Pictures" "Pictures" "Pictures Folder" "none"
add_to_queue "$USER_HOME/Downloads" "Downloads" "Downloads Folder (Large/Temporary)" "large"

# 4. Local Database & Shell History (Atuin, Zoxide, CLI history files)
add_to_queue "$USER_HOME/.local/share/atuin" "local/share/atuin" "Atuin Shell History Database" "none"
add_to_queue "$USER_HOME/Library/Application Support/zoxide" "Library/Application Support/zoxide" "Zoxide Directory History Database" "none"

# Grouping home history files
# We'll use a virtual item for histories, then copy them manually or via script
add_to_queue "histories" "histories" "Shell Command History Files (.histfile, .zsh_history, etc.)" "none"

# 5. CLI configurations and home files (.config excluding raycast, standalone dotfiles)
add_to_queue "$USER_HOME/.config" "dotfiles/.config" "Tool Configurations (.config folder excluding Raycast)" "config"
add_to_queue "home_files" "dotfiles/home_files" "Home configs & scripts (.aerospace.toml, crossover.sh, neovide.lua, .wakatime.cfg, .docker)" "none"

# 6. Virtual Machines
add_to_queue "$USER_HOME/Virtual Machines.localized" "Virtual Machines.localized" "VMware Virtual Machines" "none"

# Selected backups list
declare -a SELECTED_SOURCES
declare -a SELECTED_DESTS
declare -a SELECTED_NAMES
declare -a SELECTED_EXCLUDES

echo -e "${BOLD}Step 1: Select what to back up${NC}"
echo -e "----------------------------------------------------"

for item in "${BACKUP_QUEUE[@]}"; do
    IFS="|" read -r src rel_dest name exclude_type <<< "$item"
    
    # Custom exists check for virtual categories
    if [ "$src" != "histories" ] && [ "$src" != "home_files" ] && [ ! -e "$src" ]; then
        continue # Skip if source path doesn't exist
    fi
    
    # Calculate display size
    if [ "$src" == "histories" ]; then
        size=$(get_histories_size)
    elif [ "$src" == "home_files" ]; then
        size=$(get_home_files_size)
    else
        size=$(get_size "$src")
    fi
    
    # Warnings or details
    warning=""
    if [ "$exclude_type" == "dev" ]; then
        warning=" (Will automatically exclude node_modules, target, .venv, etc. to save space)"
    elif [ "$exclude_type" == "config" ]; then
        warning=" (Will automatically exclude the 263MB Raycast cache folder)"
    elif [ "$exclude_type" == "large" ]; then
        warning=" ${RED}${BOLD}(Warning: large temporary directory)${NC}"
    fi
    
    echo -ne "Do you want to back up ${GREEN}${name}${NC} (${size})${warning}?\n[y/N]: "
    read -r response
    
    if [[ "$response" =~ ^[Yy]$ ]]; then
        SELECTED_SOURCES+=("$src")
        SELECTED_DESTS+=("$BACKUP_DIR/$rel_dest")
        SELECTED_NAMES+=("$name")
        SELECTED_EXCLUDES+=("$exclude_type")
    fi
    echo
done

# Check if anything was selected
if [ ${#SELECTED_SOURCES[@]} -eq 0 ]; then
    echo -e "${YELLOW}No items selected for backup. Exiting.${NC}"
    exit 0
fi

echo -e "\n${BOLD}Step 2: Summary of Selected Backups${NC}"
echo -e "----------------------------------------------------"
for i in "${!SELECTED_SOURCES[@]}"; do
    src="${SELECTED_SOURCES[$i]}"
    dest="${SELECTED_DESTS[$i]}"
    name="${SELECTED_NAMES[$i]}"
    
    if [ "$src" == "histories" ]; then
        size="~100K"
    elif [ "$src" == "home_files" ]; then
        size="~30K"
    else
        size=$(get_size "$src")
    fi
    echo -e " • ${GREEN}${name}${NC} (${size}) -> ${CYAN}${dest}${NC}"
done

echo -e "\nTotal items to back up: ${BOLD}${#SELECTED_SOURCES[@]}${NC}"
echo -ne "Proceed with the backup now? [y/N]: "
read -r proceed

if [[ ! "$proceed" =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Backup aborted by user.${NC}"
    exit 0
fi

echo -e "\n${BOLD}Step 3: Executing Backup...${NC}"
echo -e "----------------------------------------------------"

for i in "${!SELECTED_SOURCES[@]}"; do
    src="${SELECTED_SOURCES[$i]}"
    dest="${SELECTED_DESTS[$i]}"
    name="${SELECTED_NAMES[$i]}"
    exclude_type="${SELECTED_EXCLUDES[$i]}"
    
    echo -e "\n${CYAN}>>> Backing up: ${name}${NC}"
    
    # Ensure destination parent directory exists
    mkdir -p "$(dirname "$dest")"
    
    # Setup rsync flags
    RSYNC_CMD=("rsync" "-avh" "--progress")
    
    if [ "$src" == "histories" ]; then
        # Copy history files to destination directory
        mkdir -p "$dest"
        for f in "$USER_HOME/.zsh_history" "$USER_HOME/.bash_history" "$USER_HOME/.histfile" "$USER_HOME/.python_history" "$USER_HOME/.node_repl_history" "$USER_HOME/.irb_history"; do
            if [ -f "$f" ]; then
                cp -v "$f" "$dest/"
            fi
        done
        
    elif [ "$src" == "home_files" ]; then
        # Copy individual configuration files to destination directory
        mkdir -p "$dest"
        for f in "$USER_HOME/.aerospace.toml" "$USER_HOME/crossover.sh" "$USER_HOME/neovide.lua" "$USER_HOME/.wakatime.cfg"; do
            if [ -f "$f" ]; then
                cp -v "$f" "$dest/"
            fi
        done
        # Copy .docker folder
        if [ -d "$USER_HOME/.docker" ]; then
            rsync -avh --progress "$USER_HOME/.docker" "$dest/"
        fi
        
    else
        # Config folder exclusions
        if [ "$exclude_type" == "config" ]; then
            RSYNC_CMD+=("--exclude=raycast")
        # Developer folder exclusions
        elif [ "$exclude_type" == "dev" ]; then
            RSYNC_CMD+=(
                "--exclude=node_modules"
                "--exclude=.venv"
                "--exclude=venv"
                "--exclude=target"
                "--exclude=.next"
                "--exclude=.nuxt"
                "--exclude=dist"
                "--exclude=build"
                "--exclude=.cache"
                "--exclude=Pods"
                "--exclude=Caches"
                "--exclude=.DS_Store"
            )
        fi
        
        # Directory vs file check
        if [ -d "$src" ]; then
            "${RSYNC_CMD[@]}" "$src" "$(dirname "$dest")/"
        else
            "${RSYNC_CMD[@]}" "$src" "$dest"
        fi
    fi
    
    echo -e "${GREEN}✓ Done backing up ${name}${NC}"
done

echo -e "\n${GREEN}${BOLD}====================================================${NC}"
echo -e "${GREEN}${BOLD}             Backup Process Completed!              ${NC}"
echo -e "${GREEN}${BOLD}====================================================${NC}"
echo -e "Your files have been backed up to: ${BOLD}${BACKUP_DIR}${NC}"
echo -e "You can run ${BOLD}ls -la \"${BACKUP_DIR}\"${NC} to inspect."
