#!/usr/bin/env bash

# Interactive macOS Restore Script
# Created for Harikeshav to restore backed-up data after Mac Reset
# Run this script from the backup directory

set -euo pipefail

# ANSI color codes
NC='\033[0m'
BOLD='\033[1m'
CYAN='\033[36m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'

# Get the directory of this script (backup directory)
BACKUP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
USER_HOME="/Users/hari"

echo -e "${CYAN}${BOLD}====================================================${NC}"
echo -e "${CYAN}${BOLD}    Interactive macOS Post-Reset Restore Utility     ${NC}"
echo -e "${CYAN}${BOLD}====================================================${NC}"
echo -e "Source: ${BOLD}${BACKUP_DIR}${NC}"
echo -e "Destination: ${BOLD}${USER_HOME}${NC}\n"

# Safety confirmation
echo -e "${YELLOW}WARNING: This script will copy files back to your home directory (${USER_HOME}).${NC}"
echo -e "${YELLOW}It may overwrite existing configurations on your new system.${NC}"
echo -ne "Do you want to proceed? [y/N]: "
read -r proceed_global
if [[ ! "$proceed_global" =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Restoration aborted by user.${NC}"
    exit 0
fi
echo

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

# Queue for folders to restore
# Format: "backup_subdir|relative_dest_path|display_name|restore_type"
# Restore types:
#   standard: standard rsync folder/file
#   histories: copy back shell history files
#   home_files: copy back individual files + .docker folder
declare -a RESTORE_QUEUE

add_to_queue() {
    local backup_sub="$1"
    local rel_dest="$2"
    local name="$3"
    local restore_type="$4"
    RESTORE_QUEUE+=("$backup_sub|$rel_dest|$name|$restore_type")
}

# 1. Critical config
add_to_queue "dotfiles/.ssh" ".ssh" "SSH Keys & Configuration" "standard"
add_to_queue "dotfiles/.gitconfig" ".gitconfig" "Global Git Config" "standard"
add_to_queue "Developer/Dotfiles" "Developer/Dotfiles" "Developer Dotfiles Repository (Local)" "standard"

# 2. Projects & Personal
add_to_queue "Developer" "Developer" "Developer Projects Folder" "standard"
add_to_queue "Documents" "Documents" "Documents Folder" "standard"
add_to_queue "Desktop" "Desktop" "Desktop Folder" "standard"
add_to_queue "Pictures" "Pictures" "Pictures Folder" "standard"
add_to_queue "Downloads" "Downloads" "Downloads Folder" "standard"

# 3. Local History and Databases
add_to_queue "local/share/atuin" ".local/share/atuin" "Atuin Shell History Database" "standard"
add_to_queue "Library/Application Support/zoxide" "Library/Application Support/zoxide" "Zoxide Directory History Database" "standard"
add_to_queue "histories" "" "Shell Command History Files (.histfile, .zsh_history, etc.)" "histories"

# 4. Configurations & Custom Scripts
add_to_queue "dotfiles/.config" ".config" "Tool Configurations (.config folder)" "standard"
add_to_queue "dotfiles/home_files" "" "Home configs & scripts (.aerospace.toml, crossover.sh, neovide.lua, .wakatime.cfg, .docker)" "home_files"

# 5. Virtual Machines
add_to_queue "Virtual Machines.localized" "Virtual Machines.localized" "VMware Virtual Machines" "standard"


# Selected restores list
declare -a SELECTED_BACKUPS
declare -a SELECTED_DESTS
declare -a SELECTED_NAMES
declare -a SELECTED_TYPES

echo -e "${BOLD}Step 1: Select what to restore${NC}"
echo -e "----------------------------------------------------"

for item in "${RESTORE_QUEUE[@]}"; do
    IFS="|" read -r backup_sub rel_dest name restore_type <<< "$item"
    
    backup_path="$BACKUP_DIR/$backup_sub"
    
    # Check if this backup item actually exists in our backup directory
    if [ "$restore_type" == "standard" ] && [ ! -e "$backup_path" ]; then
        continue # Skip if it was not backed up
    fi
    if [ "$restore_type" == "histories" ] && [ ! -d "$BACKUP_DIR/histories" ]; then
        continue
    fi
    if [ "$restore_type" == "home_files" ] && [ ! -d "$BACKUP_DIR/dotfiles/home_files" ]; then
        continue
    fi
    
    # Get size of the backup
    if [ "$restore_type" == "histories" ]; then
        size=$(get_size "$BACKUP_DIR/histories")
    elif [ "$restore_type" == "home_files" ]; then
        size=$(get_size "$BACKUP_DIR/dotfiles/home_files")
    else
        size=$(get_size "$backup_path")
    fi
    
    echo -ne "Do you want to restore ${GREEN}${name}${NC} (${size})?\n[y/N]: "
    read -r response
    
    if [[ "$response" =~ ^[Yy]$ ]]; then
        SELECTED_BACKUPS+=("$backup_sub")
        SELECTED_DESTS+=("$USER_HOME/$rel_dest")
        SELECTED_NAMES+=("$name")
        SELECTED_TYPES+=("$restore_type")
    fi
    echo
done

# Check if anything was selected
if [ ${#SELECTED_BACKUPS[@]} -eq 0 ]; then
    echo -e "${YELLOW}No items selected for restoration. Exiting.${NC}"
    exit 0
fi

echo -e "\n${BOLD}Step 2: Summary of Selected Restorations${NC}"
echo -e "----------------------------------------------------"
for i in "${!SELECTED_BACKUPS[@]}"; do
    backup_sub="${SELECTED_BACKUPS[$i]}"
    dest="${SELECTED_DESTS[$i]}"
    name="${SELECTED_NAMES[$i]}"
    
    if [ "$backup_sub" == "histories" ] || [ "$backup_sub" == "dotfiles/home_files" ]; then
        display_dest="$USER_HOME/"
    else
        display_dest="$dest"
    fi
    
    echo -e " • ${GREEN}${name}${NC} -> ${CYAN}${display_dest}${NC}"
done

echo -ne "\nProceed with the restoration now? [y/N]: "
read -r proceed_confirm

if [[ ! "$proceed_confirm" =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Restoration aborted by user.${NC}"
    exit 0
fi

echo -e "\n${BOLD}Step 3: Executing Restoration...${NC}"
echo -e "----------------------------------------------------"

for i in "${!SELECTED_BACKUPS[@]}"; do
    backup_sub="${SELECTED_BACKUPS[$i]}"
    dest="${SELECTED_DESTS[$i]}"
    name="${SELECTED_NAMES[$i]}"
    restore_type="${SELECTED_TYPES[$i]}"
    
    backup_path="$BACKUP_DIR/$backup_sub"
    
    echo -e "\n${CYAN}>>> Restoring: ${name}${NC}"
    
    if [ "$restore_type" == "histories" ]; then
        # Copy history files back
        mkdir -p "$USER_HOME"
        rsync -avh --progress "$BACKUP_DIR/histories/" "$USER_HOME/"
        
    elif [ "$restore_type" == "home_files" ]; then
        # Copy home configuration files back
        mkdir -p "$USER_HOME"
        rsync -avh --progress "$BACKUP_DIR/dotfiles/home_files/" "$USER_HOME/"
        
    else
        # Standard folder restoration using rsync
        # Ensure destination parent directory exists
        mkdir -p "$(dirname "$dest")"
        
        # If source is a directory, rsync it
        if [ -d "$backup_path" ]; then
            # We copy backup_path directory into the parent of dest
            rsync -avh --progress "$backup_path" "$(dirname "$dest")/"
        else
            # Single file copy
            rsync -avh --progress "$backup_path" "$dest"
        fi
    fi
    
    echo -e "${GREEN}✓ Done restoring ${name}${NC}"
done

echo -e "\n${GREEN}${BOLD}====================================================${NC}"
echo -e "${GREEN}${BOLD}           Restoration Process Completed!           ${NC}"
echo -e "${GREEN}${BOLD}====================================================${NC}"
echo -e "All selected files have been restored to your home directory."
echo -e "Next steps: Run your dotfiles bootstrap script if needed:"
echo -e "  ${BOLD}bash ~/Developer/Dotfiles/setup.sh${NC}"
