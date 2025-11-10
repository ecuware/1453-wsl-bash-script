# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a WSL (Windows Subsystem for Linux) automated setup script designed for AI developers. The project consists of a single comprehensive Bash script that installs and configures development tools, programming languages, and AI CLI tools in a Linux environment.

## Core Commands

### Running the Main Script
```bash
# Make the script executable
chmod +x src/linux-ai-setup-script.sh

# Run the script
./src/linux-ai-setup-script.sh

# Or run with bash directly
bash src/linux-ai-setup-script.sh
```

### Script Validation
```bash
# Check for syntax errors
bash -n src/linux-ai-setup-script.sh

# Run shellcheck for linting (if installed)
shellcheck src/linux-ai-setup-script.sh
```

## Architecture

The script (`src/linux-ai-setup-script.sh`) is a 2,331-line monolithic Bash script with the following architecture:

### Function Categories
1. **Core Utilities** - System detection, package manager handling, shell configuration
2. **Python Ecosystem** - Python, pip, pipx, UV installation with PEP 668 compliance
3. **JavaScript Ecosystem** - NVM and Bun.js installation
4. **PHP Ecosystem** - Multiple PHP versions (7.4-8.5) with Laravel support
5. **AI CLI Tools** - Claude Code, Gemini, Qwen, OpenCode, Copilot, Codex
6. **AI Frameworks** - SuperGemini, SuperQwen, SuperClaude with MCP server support
7. **Interactive Menus** - Menu-driven interface with multi-choice support

### Key Implementation Details

**Package Manager Detection**: The script automatically detects and supports:
- APT (Debian/Ubuntu)
- DNF (Fedora/RHEL 8+)
- YUM (RHEL/CentOS)
- Pacman (Arch Linux)

**Shell Configuration Management**: Automatically modifies and reloads:
- `.bashrc`
- `.zshrc`
- `.profile`

**Windows WSL Compatibility**: Handles CRLF line endings automatically at startup using `dos2unix`, `sed`, or `tr`.

**Error Handling**: Uses color-coded output (RED for errors, GREEN for success, YELLOW for warnings) with bilingual messages (Turkish/English).

## Important Functions

### Core Functions
- `detect_package_manager()` - Detects system package manager (lines 90-115)
- `reload_shell_configs()` - Reloads shell configuration files (lines 31-66)
- `update_system()` - Updates system packages (lines 117-141)

### Installation Functions
- `install_python()` - Installs Python with modern pip handling (lines 143-205)
- `install_claude_code()` - Installs Claude Code CLI (lines 519-593)
- `install_php_version()` - Installs specific PHP version with extensions (lines 1727-1822)
- `configure_git()` - Interactive Git configuration (lines 436-517)

### Menu System
- `show_menu()` - Main interactive menu (lines 2145-2169)
- `main()` - Main program loop with multi-choice support (lines 2171-2329)

## Development Notes

### Script Modifications
When modifying the script:
1. Maintain color-coded output consistency using the defined color variables
2. Always check for command existence before using it (`command -v`)
3. Handle both single and multi-choice menu selections
4. Reload shell configurations after PATH modifications
5. Use the `mask_secret()` function for sensitive data

### Adding New Tools
To add a new installation function:
1. Create function following naming pattern `install_<tool_name>()`
2. Check if tool already exists before installation
3. Add PATH modifications to appropriate shell RC files
4. Call `reload_shell_configs()` after installation
5. Add menu entry in `show_menu()` and case handler in `main()`

### PHP Version Management
The script uses `update-alternatives` for PHP version switching. When adding new PHP versions:
1. Add version to `PHP_SUPPORTED_VERSIONS` array
2. Ensure all extensions in `PHP_EXTENSION_PACKAGES` are installed
3. Configure alternatives in `install_php_version()`

### MCP Server Integration
MCP (Model Context Protocol) servers are managed through:
- `cleanup_magic_mcp()` - SuperGemini servers
- `cleanup_qwen_mcp()` - SuperQwen servers
- `cleanup_claude_mcp()` - SuperClaude servers

## Testing Approach

No automated tests exist. Manual testing approach:
```bash
# Test syntax
bash -n src/linux-ai-setup-script.sh

# Test in Docker container (recommended)
docker run -it ubuntu:latest /bin/bash
# Copy script and test installations

# Test specific functions by sourcing
source src/linux-ai-setup-script.sh
detect_package_manager
```

## Common Issues and Solutions

1. **CRLF Line Endings**: Script auto-fixes on first run
2. **Permission Denied**: Run `chmod +x` on the script
3. **PEP 668 Errors**: Script handles externally-managed-environment automatically
4. **Missing Dependencies**: Script installs prerequisites automatically
5. **Shell Not Reloading**: Script calls `reload_shell_configs()` automatically