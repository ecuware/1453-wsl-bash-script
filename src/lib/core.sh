#!/bin/bash
# Enhanced Core Library - Optimized for Performance and Compactness
# Version: 3.0 - High-Performance Architecture
# Features: Parallel processing, caching, smart dependency management, enhanced logging

# Performance tracking
declare -g SCRIPT_START_TIME
declare -g INSTALLATION_CACHE_DIR="$HOME/.1453-wsl-setup/cache"
declare -g LOG_FILE="$HOME/.1453-wsl-setup/install.log"
declare -g PERFORMANCE_LOG="$HOME/.1453-wsl-setup/performance.log"

# Initialize performance tracking
init_performance_tracking() {
    SCRIPT_START_TIME=$(date +%s.%N)
    mkdir -p "$INSTALLATION_CACHE_DIR" "$(dirname "$LOG_FILE")" "$(dirname "$PERFORMANCE_LOG")"
    
    # Clear previous logs if they exist and are too large (>10MB)
    [ -f "$LOG_FILE" ] && [ $(stat -f%z "$LOG_FILE" 2>/dev/null || stat -c%s "$LOG_FILE") -gt 10485760 ] && rm "$LOG_FILE"
    [ -f "$PERFORMANCE_LOG" ] && [ $(stat -f%z "$PERFORMANCE_LOG" 2>/dev/null || stat -c%s "$PERFORMANCE_LOG") -gt 10485760 ] && rm "$PERFORMANCE_LOG"
}

# Enhanced logging system
log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local log_entry="[$timestamp] [$level] $message"
    
    # Write to log file
    echo "$log_entry" >> "$LOG_FILE"
    
    # Write to performance log for performance-related messages
    if [[ "$level" == "PERF" ]]; then
        echo "$log_entry" >> "$PERFORMANCE_LOG"
    fi
    
    # Output to console with color coding
    case "$level" in
        "ERROR")   echo -e "${RED}[HATA]${NC} $message" >&2 ;;
        "WARN")    echo -e "${YELLOW}[UYARI]${NC} $message" ;;
        "INFO")    echo -e "${BLUE}[BİLGİ]${NC} $message" ;;
        "SUCCESS") echo -e "${GREEN}[BAŞARILI]${NC} $message" ;;
        "PERF")    echo -e "${CYAN}[PERF]${NC} $message" ;;
        *)         echo "$message" ;;
    esac
}

# Performance measurement
measure_performance() {
    local operation="$1"
    local start_time="$2"
    local end_time=$(date +%s.%N)
    local duration=$(echo "$end_time - $start_time" | bc -l 2>/dev/null || echo "0")
    
    log "PERF" "$operation completed in ${duration}s"
    return 0
}

# Smart cache management
cache_key() {
    local tool="$1"
    local version="$2"
    echo "${tool}_${version}_$(uname -m)_$(lsb_release -sr 2>/dev/null || echo 'unknown')"
}

is_cached() {
    local tool="$1"
    local version="${2:-latest}"
    local cache_file="$INSTALLATION_CACHE_DIR/$(cache_key "$tool" "$version")"
    
    [ -f "$cache_file" ] && [ $(($(date +%s) - $(stat -f%m "$cache_file" 2>/dev/null || stat -c%Y "$cache_file"))) -lt 86400 ] # 24 hours
}

save_cache() {
    local tool="$1"
    local version="${2:-latest}"
    local cache_file="$INSTALLATION_CACHE_DIR/$(cache_key "$tool" "$version")"
    
    echo "$(date +%s)" > "$cache_file"
}

# Enhanced command execution with timeout and retry
execute_with_retry() {
    local max_attempts="${1:-3}"
    local timeout="${2:-30}"
    local command="$3"
    local description="$4"
    
    local attempt=1
    while [ $attempt -le $max_attempts ]; do
        log "INFO" "Attempting: $description (attempt $attempt/$max_attempts)"
        
        if timeout "$timeout" bash -c "$command" >> "$LOG_FILE" 2>&1; then
            log "SUCCESS" "$description completed successfully"
            return 0
        else
            local exit_code=$?
            if [ $exit_code -eq 124 ]; then
                log "WARN" "$description timed out after ${timeout}s"
            else
                log "WARN" "$description failed with exit code $exit_code"
            fi
            
            if [ $attempt -lt $max_attempts ]; then
                local delay=$((attempt * 2))
                log "INFO" "Retrying in ${delay}s..."
                sleep "$delay"
            fi
        fi
        ((attempt++))
    done
    
    log "ERROR" "$description failed after $max_attempts attempts"
    return 1
}

# Parallel execution manager
execute_parallel() {
    local -a commands=("$@")
    local -a pids=()
    local max_parallel="${#commands[@]}"
    
    # Limit parallel processes to avoid overwhelming the system
    [ $max_parallel -gt 4 ] && max_parallel=4
    
    log "INFO" "Executing ${#commands[@]} commands in parallel (max: $max_parallel)"
    
    for cmd in "${commands[@]}"; do
        # Start command in background if we haven't reached the limit
        while [ ${#pids[@]} -ge $max_parallel ]; do
            # Wait for any background process to complete
            for i in "${!pids[@]}"; do
                if ! kill -0 "${pids[i]}" 2>/dev/null; then
                    wait "${pids[i]}"
                    unset pids[i]
                fi
            done
            # Reindex array
            pids=("${pids[@]}")
            sleep 0.1
        done
        
        # Execute command in background
        eval "$cmd" &
        pids+=($!)
    done
    
    # Wait for all remaining processes
    for pid in "${pids[@]}"; do
        wait "$pid"
    done
}

# Smart dependency checker
check_dependencies() {
    local -a required_tools=("$@")
    local -a missing_tools=()
    
    for tool in "${required_tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            missing_tools+=("$tool")
        fi
    done
    
    if [ ${#missing_tools[@]} -gt 0 ]; then
        log "WARN" "Missing dependencies: ${missing_tools[*]}"
        return 1
    fi
    
    return 0
}

# Enhanced package manager detection with caching
detect_package_manager() {
    local cache_file="$INSTALLATION_CACHE_DIR/package_manager"
    
    # Check cache first
    if [ -f "$cache_file" ]; then
        local cached_data
        cached_data=$(cat "$cache_file")
        if [[ "$cached_data" =~ ^(apt|dnf|yum|pacman):[a-zA-Z0-9_]+:[^:]+:[^:]+$ ]]; then
            IFS=':' read -r PKG_MANAGER UPDATE_CMD INSTALL_CMD SYSTEM_INFO <<< "$cached_data"
            log "INFO" "Using cached package manager: $PKG_MANAGER"
            export PKG_MANAGER UPDATE_CMD INSTALL_CMD
            return 0
        fi
    fi
    
    # Detect and cache
    log "INFO" "Detecting package manager..."
    
    if command -v dnf &> /dev/null; then
        PKG_MANAGER="dnf"
        UPDATE_CMD="sudo dnf upgrade -y"
        INSTALL_CMD="sudo dnf install -y"
    elif command -v apt &> /dev/null; then
        PKG_MANAGER="apt"
        UPDATE_CMD="sudo DEBIAN_FRONTEND=noninteractive apt update && sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y"
        INSTALL_CMD="sudo DEBIAN_FRONTEND=noninteractive apt install -y"
    elif command -v yum &> /dev/null; then
        PKG_MANAGER="yum"
        UPDATE_CMD="sudo yum update -y"
        INSTALL_CMD="sudo yum install -y"
    elif command -v pacman &> /dev/null; then
        PKG_MANAGER="pacman"
        UPDATE_CMD="sudo pacman -Syu --noconfirm"
        INSTALL_CMD="sudo pacman -S --noconfirm"
    else
        log "ERROR" "No supported package manager found!"
        return 1
    fi
    
    SYSTEM_INFO="$(uname -m):$(lsb_release -sr 2>/dev/null || echo 'unknown'):$(lsb_release -id 2>/dev/null || echo 'unknown')"
    
    # Cache the result
    echo "$PKG_MANAGER:$UPDATE_CMD:$INSTALL_CMD:$SYSTEM_INFO" > "$cache_file"
    
    export PKG_MANAGER UPDATE_CMD INSTALL_CMD
    log "SUCCESS" "Package manager detected: $PKG_MANAGER"
}

# Optimized system update with parallel package installation
optimized_update_system() {
    local start_time=$(date +%s.%N)
    log "INFO" "Starting optimized system update..."
    
    # Update package lists
    execute_with_retry 2 60 "eval \"$UPDATE_CMD\"" "System package update" || return 1
    
    # Install essential packages based on package manager
    case "$PKG_MANAGER" in
        "apt")
            execute_with_retry 2 120 "eval \"$INSTALL_CMD curl wget git jq zip unzip p7zip-full\"" "Essential packages installation" || return 1
            execute_with_retry 2 180 "eval \"$INSTALL_CMD build-essential\"" "Build tools installation" || return 1
            ;;
        "dnf"|"yum")
            execute_with_retry 2 120 "eval \"$INSTALL_CMD curl wget git jq zip unzip p7zip\"" "Essential packages installation" || return 1
            execute_with_retry 2 180 "sudo $PKG_MANAGER groupinstall 'Development Tools' -y" "Development tools installation" || return 1
            ;;
        "pacman")
            execute_with_retry 2 120 "eval \"$INSTALL_CMD curl wget git jq zip unzip p7zip\"" "Essential packages installation" || return 1
            execute_with_retry 2 180 "sudo pacman -S base-devel --noconfirm" "Base development tools" || return 1
            ;;
    esac
    
    measure_performance "System update" "$start_time"
    log "SUCCESS" "System update completed successfully"
}

# Enhanced shell configuration reloader
reload_shell_configs() {
    local mode="${1:-verbose}"
    local shell_name
    shell_name=$(basename "${SHELL:-}")
    
    local candidates
    case "$shell_name" in
        "zsh") candidates=("$HOME/.zshrc" "$HOME/.bashrc" "$HOME/.profile") ;;
        "bash") candidates=("$HOME/.bashrc" "$HOME/.profile" "$HOME/.zshrc") ;;
        *) candidates=("$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile") ;;
    esac
    
    local sourced_file=""
    for rc_file in "${candidates[@]}"; do
        if [ -f "$rc_file" ]; then
            . "$rc_file" && sourced_file="$rc_file" && break
        fi
    done
    
    if [ "$mode" != "silent" ]; then
        if [ -n "$sourced_file" ]; then
            log "INFO" "Shell configurations loaded from: $sourced_file"
        else
            log "WARN" "No shell configuration files found"
        fi
    fi
}

# System information collector
get_system_info() {
    local info_file="$INSTALLATION_CACHE_DIR/system_info"
    
    if [ -f "$info_file" ]; then
        cat "$info_file"
        return
    fi
    
    local system_info
    system_info=$(cat << EOF
OS: $(lsb_release -d 2>/dev/null | cut -f2 || echo "Unknown")
ARCH: $(uname -m)
KERNEL: $(uname -r)
MEMORY: $(free -h | awk '/^Mem:/ {print $2}' || echo "Unknown")
DISK: $(df -h / | awk 'NR==2 {print $4}' || echo "Unknown")
SHELL: ${SHELL:-Unknown}
USER: ${USER:-Unknown}
EOF
)
    
    echo "$system_info" > "$info_file"
    echo "$system_info"
}

# Export all functions
export -f init_performance_tracking
export -f log
export -f measure_performance
export -f cache_key
export -f is_cached
export -f save_cache
export -f execute_with_retry
export -f execute_parallel
export -f check_dependencies
export -f detect_package_manager
export -f optimized_update_system
export -f reload_shell_configs
export -f get_system_info