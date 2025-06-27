#!/usr/bin/env bash

#######################################################################
# Devbox Scripts to Mise Tasks Migration Script
#######################################################################
#
# This script migrates scripts from Devbox global scripts to Mise tasks.
# 
# Features:
# - Automatically detects and processes all Devbox global scripts
# - Properly handles both script formats in devbox.json:
#   * String format (single-line scripts)
#   * Array format (multi-line scripts)
# - Handles both single-line and multi-line scripts differently:
#   * Single-line scripts are added directly to mise config.toml
#   * Multi-line scripts are created as executable files in mise tasks directory
# - Generates human-readable descriptions from script names by:
#   * Converting hyphens and underscores to spaces
#   * Capitalizing first letters of words
# - Preserves original script content without filtering
# - Replaces any "devbox global run" commands with "mise run" in multi-line scripts
# - Removes migrated scripts from Devbox global configuration
# - Provides detailed statistics about the migration process
#
# Requirements:
# - devbox, mise, and jq must be installed
#
# Usage:
# ./migrate-devbox-scripts-to-mise.sh
#
#######################################################################

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

log_info()
{
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warning()
{
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error()
{
    echo -e "${RED}[ERROR]${NC} $1"
}

check_command()
{
    if ! command -v "$1" &>/dev/null; then
        log_error "Command '$1' not found. Please install it first."
        exit 1
    fi
}

check_command "devbox"
check_command "mise"
check_command "jq"

DEVBOX_GLOBAL_PATH=$(devbox global path)
DEVBOX_CONFIG_PATH="$DEVBOX_GLOBAL_PATH/devbox.json"
MISE_TASKS_PATH="$HOME/.config/mise/tasks"
MISE_CONFIG_PATH="$HOME/.config/mise/config.toml"

# Check if devbox.json exists
if [ ! -f "$DEVBOX_CONFIG_PATH" ]; then
    log_error "Devbox global configuration file not found at: $DEVBOX_CONFIG_PATH"
    exit 1
fi

mkdir -p "$MISE_TASKS_PATH"

log_info "Getting list of devbox global scripts..."
DEVBOX_SCRIPTS=$(devbox global run)
SCRIPT_NAMES=$(echo "$DEVBOX_SCRIPTS" | grep -oP '(?<=\* )[a-zA-Z0-9_-]+')

stats_file=$(mktemp --suffix=.json)
cat >"$stats_file" <<EOF
{
  "total_scripts": 0,
  "single_line_scripts": 0,
  "multi_line_scripts": 0,
  "migrated_scripts": 0,
  "script_lists": {
    "single_line": [],
    "multi_line": []
  }
}
EOF

update_stat()
{
    local key=$1
    local value=$(jq ".$key" "$stats_file")
    value=$((value + 1))
    jq ".$key = $value" "$stats_file" >"${stats_file}.tmp" && mv "${stats_file}.tmp" "$stats_file"
}

add_script_to_list()
{
    local list_name=$1
    local script_name=$2

    local script_entry="\"$script_name\""
    jq ".script_lists.$list_name += [$script_entry]" "$stats_file" >"${stats_file}.tmp" && mv "${stats_file}.tmp" "$stats_file"
}

for script_name in $SCRIPT_NAMES; do
    update_stat "total_scripts"
    log_info "Processing script: $script_name"

    # Check if script is defined as a string or an array
    script_type=$(jq -r "if .shell.scripts.\"$script_name\" | type == \"string\" then \"string\" else \"array\" end" "$DEVBOX_CONFIG_PATH")
    
    if [ "$script_type" = "string" ]; then
        # Handle single-line script defined as a string
        script_content=$(jq -r ".shell.scripts.\"$script_name\"" "$DEVBOX_CONFIG_PATH")
        line_count=1
    else
        # Handle multi-line script defined as an array
        script_content=$(jq -r ".shell.scripts.\"$script_name\"[]" "$DEVBOX_CONFIG_PATH" 2>/dev/null)
        if [ -z "$script_content" ]; then
            log_warning "  Could not find script content for: $script_name"
            continue
        fi
        line_count=$(echo "$script_content" | wc -l)
    fi

    description=$(echo "$script_name" | sed 's/[-_]/ /g' | sed 's/\b\(.\)/\u\1/g')

    if [ "$line_count" -le 1 ]; then
        log_info "  Detected as single-line script"
        update_stat "single_line_scripts"
        add_script_to_list "single_line" "$script_name"

        command="$script_content"

        if ! grep -q "\[tasks\]" "$MISE_CONFIG_PATH"; then
            echo -e "\n[tasks]" >>"$MISE_CONFIG_PATH"
        fi

        echo -e "\n[tasks.$script_name]" >>"$MISE_CONFIG_PATH"
        if [ -n "$description" ]; then
            log_info "  Adding to mise config.toml with description: $description"
            echo "description = \"$description\"" >>"$MISE_CONFIG_PATH"
        else
            log_info "  Adding to mise config.toml without description"
        fi
        echo "run = \"$command\"" >>"$MISE_CONFIG_PATH"
    else
        log_info "  Detected as multi-line script"
        update_stat "multi_line_scripts"
        add_script_to_list "multi_line" "$script_name"

        task_file="$MISE_TASKS_PATH/$script_name"
        log_info "  Creating task file: $task_file"

        echo "#!/usr/bin/env bash" >"$task_file"
        if [ -n "$description" ]; then
            echo "#MISE description=\"$description\"" >>"$task_file"
        fi
        echo "" >>"$task_file"

        echo "$script_content" | sed 's/devbox global run/mise run/g' >>"$task_file"

        chmod +x "$task_file"
    fi

    # Remove the script from devbox.json
    log_info "  Removing script from Devbox global configuration..."
    jq "del(.shell.scripts.\"$script_name\")" "$DEVBOX_CONFIG_PATH" > "$DEVBOX_CONFIG_PATH.tmp" && mv "$DEVBOX_CONFIG_PATH.tmp" "$DEVBOX_CONFIG_PATH"
    log_info "  Successfully removed script from Devbox global configuration"

    update_stat "migrated_scripts"
    echo "-------------------------------------------"
done

total_scripts=$(jq -r '.total_scripts' "$stats_file")
single_line_scripts=$(jq -r '.single_line_scripts' "$stats_file")
multi_line_scripts=$(jq -r '.multi_line_scripts' "$stats_file")
migrated_scripts=$(jq -r '.migrated_scripts' "$stats_file")

single_line_array=$(jq -r '.script_lists.single_line[]' "$stats_file" 2>/dev/null || echo "")
multi_line_array=$(jq -r '.script_lists.multi_line[]' "$stats_file" 2>/dev/null || echo "")

rm "$stats_file"

log_info "Migration complete!"
log_info "Total scripts: $total_scripts"
log_info "Single-line scripts: $single_line_scripts"
if [ "$single_line_scripts" -gt 0 ]; then
    echo "$single_line_array" | while read -r script; do
        echo "  - $script"
    done
fi

log_info "Multi-line scripts: $multi_line_scripts"
if [ "$multi_line_scripts" -gt 0 ]; then
    echo "$multi_line_array" | while read -r script; do
        echo "  - $script"
    done
fi

log_info "Successfully migrated: $migrated_scripts"
log_info "Devbox global configuration updated: $DEVBOX_CONFIG_PATH"
log_info "Run 'mise tasks' to see all available tasks"
