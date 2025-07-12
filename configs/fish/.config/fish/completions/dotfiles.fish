# Fish completion for dotfiles command

# Main commands
complete -c dotfiles -f
complete -c dotfiles -n "__fish_use_subcommand" -a "install" -d "Run full installation"
complete -c dotfiles -n "__fish_use_subcommand" -a "config" -d "Update configuration files using stow"
complete -c dotfiles -n "__fish_use_subcommand" -a "stow" -d "Alias for config command"
complete -c dotfiles -n "__fish_use_subcommand" -a "fonts" -d "Install fonts"
complete -c dotfiles -n "__fish_use_subcommand" -a "brew" -d "Install/update packages using Homebrew"
complete -c dotfiles -n "__fish_use_subcommand" -a "update" -d "Update both config and packages"
complete -c dotfiles -n "__fish_use_subcommand" -a "doctor" -d "Check system health and dependencies"
complete -c dotfiles -n "__fish_use_subcommand" -a "validate" -d "Run comprehensive system validation"
complete -c dotfiles -n "__fish_use_subcommand" -a "test" -d "Test commands"
complete -c dotfiles -n "__fish_use_subcommand" -a "clean" -d "Clean up temporary files and caches"
complete -c dotfiles -n "__fish_use_subcommand" -a "pkg" -d "Package management commands"
complete -c dotfiles -n "__fish_use_subcommand" -a "logs" -d "Log management commands"
complete -c dotfiles -n "__fish_use_subcommand" -a "debug" -d "Debug mode commands"
complete -c dotfiles -n "__fish_use_subcommand" -a "log-level" -d "Set logging level"
complete -c dotfiles -n "__fish_use_subcommand" -a "help" -d "Show help message"

# Install subcommands
complete -c dotfiles -n "__fish_seen_subcommand_from install" -a "status" -d "Show installation progress and status"
complete -c dotfiles -n "__fish_seen_subcommand_from install" -a "resume" -d "Resume interrupted installation"
complete -c dotfiles -n "__fish_seen_subcommand_from install" -a "reset" -d "Reset installation state"
complete -c dotfiles -n "__fish_seen_subcommand_from install" -a "steps" -d "Show all installation steps and their status"
complete -c dotfiles -n "__fish_seen_subcommand_from install" -a "linux" -d "Force Linux installation"
complete -c dotfiles -n "__fish_seen_subcommand_from install" -a "macos" -d "Force macOS installation"

# Install reset confirmation
complete -c dotfiles -n "__fish_seen_subcommand_from install; and __fish_seen_subcommand_from reset" -a "confirm" -d "Confirm reset operation"

# Test subcommands
complete -c dotfiles -n "__fish_seen_subcommand_from test" -a "dependencies" -d "Test dependency declarations in scripts"
complete -c dotfiles -n "__fish_seen_subcommand_from test" -a "script" -d "Validate specific script dependencies"

# Test script completion function
function __fish_dotfiles_script_files
    if test -d "$DOTFILES_DIR/install"
        find "$DOTFILES_DIR/install" -name "*.sh" -type f 2>/dev/null | sed 's|.*/||' | sed 's|\.sh$||'
    else if test -d "$HOME/.dotfiles/install"
        find "$HOME/.dotfiles/install" -name "*.sh" -type f 2>/dev/null | sed 's|.*/||' | sed 's|\.sh$||'
    end
end

# Test script file completion
complete -c dotfiles -n "__fish_seen_subcommand_from test; and __fish_seen_subcommand_from script" -a "(__fish_dotfiles_script_files)" -d "Script file"

# Package management subcommands
complete -c dotfiles -n "__fish_seen_subcommand_from pkg" -a "install" -d "Install package using unified package management"
complete -c dotfiles -n "__fish_seen_subcommand_from pkg" -a "install-bulk" -d "Install multiple packages"
complete -c dotfiles -n "__fish_seen_subcommand_from pkg" -a "remove" -d "Remove package"
complete -c dotfiles -n "__fish_seen_subcommand_from pkg" -a "list" -d "Show installed packages"
complete -c dotfiles -n "__fish_seen_subcommand_from pkg" -a "search" -d "Search for package"
complete -c dotfiles -n "__fish_seen_subcommand_from pkg" -a "info" -d "Show package manager information"
complete -c dotfiles -n "__fish_seen_subcommand_from pkg" -a "managers" -d "List available package managers"
complete -c dotfiles -n "__fish_seen_subcommand_from pkg" -a "conflicts" -d "Check package conflicts"

# Logs subcommands
complete -c dotfiles -n "__fish_seen_subcommand_from logs" -a "show" -d "Show recent log entries"
complete -c dotfiles -n "__fish_seen_subcommand_from logs" -a "tail" -d "Follow log file in real-time"
complete -c dotfiles -n "__fish_seen_subcommand_from logs" -a "clear" -d "Clear log file"

# Debug subcommands
complete -c dotfiles -n "__fish_seen_subcommand_from debug" -a "on" -d "Enable debug mode"
complete -c dotfiles -n "__fish_seen_subcommand_from debug" -a "off" -d "Disable debug mode"
complete -c dotfiles -n "__fish_seen_subcommand_from debug" -a "status" -d "Show debug status"

# Log level options
complete -c dotfiles -n "__fish_seen_subcommand_from log-level" -a "DEBUG" -d "Debug level logging"
complete -c dotfiles -n "__fish_seen_subcommand_from log-level" -a "INFO" -d "Info level logging"
complete -c dotfiles -n "__fish_seen_subcommand_from log-level" -a "WARN" -d "Warning level logging"
complete -c dotfiles -n "__fish_seen_subcommand_from log-level" -a "ERROR" -d "Error level logging" 
