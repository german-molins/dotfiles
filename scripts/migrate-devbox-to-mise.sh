#!/usr/bin/env bash

##
# Script to migrate from Devbox global packages to Mise
##

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Parse command line arguments
accept_other_versions=false
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --accept-other-versions) accept_other_versions=true ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

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

cd "$HOME"
log_info "Working in directory: $(pwd)"

log_info "Getting list of installed devbox packages..."
devbox_packages=$(devbox global list | sed 's/^\* //')

if [ -z "$devbox_packages" ]; then
    log_info "No devbox packages found."
    exit 0
fi

stats_file=$(mktemp --suffix=.json)
cat > "$stats_file" << EOF
{
  "total_packages": 0,
  "migrated_packages": 0,
  "skipped_packages": 0,
  "upgraded_packages": 0,
  "downgraded_packages": 0,
  "failed_packages": 0,
  "package_lists": {
    "migrated": [],
    "skipped": [],
    "upgraded": [],
    "downgraded": [],
    "failed": []
  }
}
EOF

update_stat() {
    local key=$1
    local value=$(jq ".$key" "$stats_file")
    value=$((value + 1))
    jq ".$key = $value" "$stats_file" > "${stats_file}.tmp" && mv "${stats_file}.tmp" "$stats_file"
}

add_package_to_list() {
    local list_name=$1
    local package_name=$2
    local version_info=$3
    
    # Add package with version info to the appropriate list
    local package_entry="\"$package_name@$version_info\""
    jq ".package_lists.$list_name += [$package_entry]" "$stats_file" > "${stats_file}.tmp" && mv "${stats_file}.tmp" "$stats_file"
}

while read -r line; do
    if [ -z "$line" ]; then
        continue
    fi

    update_stat "total_packages"

    package_name=$(echo "$line" | cut -d '@' -f 1)
    version=$(echo "$line" | cut -d '@' -f 2 | cut -d ' ' -f 1)
    actual_version=$(echo "$line" | sed 's/.*- //')

    log_info "Processing package: $package_name (version: $version, actual: $actual_version)"

    log_info "Checking if $package_name is available in mise registry..."
    if mise registry "$package_name" &>/dev/null; then
        log_info "Found matching package in mise registry: $package_name"

        install_success=false
        if mise use -g "$package_name@$actual_version" &>/dev/null; then
            log_info "Successfully installed $package_name@$actual_version with mise"
            install_success=true
        elif [ "$accept_other_versions" = true ]; then
            log_warning "Exact version $actual_version not found. Installing latest available version..."
            if mise use -g "$package_name" &>/dev/null; then
                installed_version=$(mise list "$package_name" | grep -oP '(?<=\s)\S+$')
                
                if [ "$installed_version" != "$actual_version" ]; then
                    if [[ "$installed_version" > "$actual_version" ]]; then
                        log_warning "Upgraded: $package_name from $actual_version to $installed_version"
                        update_stat "upgraded_packages"
                        add_package_to_list "upgraded" "$package_name" "$actual_version -> $installed_version"
                    else
                        log_warning "Downgraded: $package_name from $actual_version to $installed_version"
                        update_stat "downgraded_packages"
                        add_package_to_list "downgraded" "$package_name" "$actual_version -> $installed_version"
                    fi
                fi
                install_success=true
            fi
        fi

        if [ "$install_success" = true ]; then
            log_info "Removing $package_name from devbox..."
            if devbox global rm "$package_name"; then
                log_info "Successfully removed $package_name from devbox"
                update_stat "migrated_packages"
                add_package_to_list "migrated" "$package_name" "$actual_version"
            else
                log_error "Failed to remove $package_name from devbox"
            fi
        else
            log_error "Failed to install $package_name@$actual_version with mise"
            update_stat "failed_packages"
            add_package_to_list "failed" "$package_name" "$actual_version"
        fi
    else
        log_warning "No matching package found in mise registry for: $package_name"
        update_stat "skipped_packages"
        add_package_to_list "skipped" "$package_name" "$actual_version"
    fi

    echo "-------------------------------------------"
done <<<"$devbox_packages"

total_packages=$(jq -r '.total_packages' "$stats_file")
migrated_packages=$(jq -r '.migrated_packages' "$stats_file")
skipped_packages=$(jq -r '.skipped_packages' "$stats_file")
upgraded_packages=$(jq -r '.upgraded_packages' "$stats_file")
downgraded_packages=$(jq -r '.downgraded_packages' "$stats_file")
failed_packages=$(jq -r '.failed_packages' "$stats_file")

# Get package lists as arrays
migrated_array=$(jq -r '.package_lists.migrated[]' "$stats_file" 2>/dev/null || echo "")
skipped_array=$(jq -r '.package_lists.skipped[]' "$stats_file" 2>/dev/null || echo "")
upgraded_array=$(jq -r '.package_lists.upgraded[]' "$stats_file" 2>/dev/null || echo "")
downgraded_array=$(jq -r '.package_lists.downgraded[]' "$stats_file" 2>/dev/null || echo "")
failed_array=$(jq -r '.package_lists.failed[]' "$stats_file" 2>/dev/null || echo "")

rm "$stats_file"

log_info "Migration complete!"
log_info "Total packages: $total_packages"
log_info "Successfully migrated: $migrated_packages"
if [ "$migrated_packages" -gt 0 ]; then
    echo "$migrated_array" | while read -r package; do
        echo "  - $package"
    done
fi

log_info "Skipped packages (not in registry): $skipped_packages"
if [ "$skipped_packages" -gt 0 ]; then
    echo "$skipped_array" | while read -r package; do
        echo "  - $package"
    done
fi

log_warning "Upgraded packages: $upgraded_packages"
if [ "$upgraded_packages" -gt 0 ]; then
    echo "$upgraded_array" | while read -r package; do
        echo "  - $package"
    done
fi

log_warning "Downgraded packages: $downgraded_packages"
if [ "$downgraded_packages" -gt 0 ]; then
    echo "$downgraded_array" | while read -r package; do
        echo "  - $package"
    done
fi

log_error "Failed packages (installation error): $failed_packages"
if [ "$failed_packages" -gt 0 ]; then
    echo "$failed_array" | while read -r package; do
        echo "  - $package"
    done
fi
