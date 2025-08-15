# Dotfiles Justfile

# Default recipe - show available commands
default:
    @just --list

# Run shellcheck on all shell scripts
lint:
    #!/usr/bin/env bash
    echo "Running shellcheck on all shell scripts..."
    
    # Find all .sh files and the dotfiles script
    scripts=$(find . -name "*.sh" -type f | grep -v ".git" | sort)
    scripts="$scripts ./bin/dotfiles"
    
    # Check if shellcheck is installed
    if ! command -v shellcheck &> /dev/null; then
        echo "Error: shellcheck is not installed"
        echo "Install with: sudo apt install shellcheck (Linux) or brew install shellcheck (macOS)"
        exit 1
    fi
    
    # Track if any errors were found
    errors=0
    
    # Run shellcheck on each script
    for script in $scripts; do
        if [ -f "$script" ]; then
            echo "Checking $script..."
            if ! shellcheck "$script"; then
                errors=$((errors + 1))
            fi
        fi
    done
    
    # Report results
    if [ $errors -eq 0 ]; then
        echo "✅ All scripts passed shellcheck!"
    else
        echo "❌ Found issues in $errors script(s)"
        exit 1
    fi

# Fix common shellcheck issues automatically where possible
lint-fix:
    #!/usr/bin/env bash
    echo "Running shellcheck with automatic fixes..."
    
    # Find all .sh files and the dotfiles script
    scripts=$(find . -name "*.sh" -type f | grep -v ".git" | sort)
    scripts="$scripts ./bin/dotfiles"
    
    # Check if shellcheck is installed
    if ! command -v shellcheck &> /dev/null; then
        echo "Error: shellcheck is not installed"
        echo "Install with: sudo apt install shellcheck (Linux) or brew install shellcheck (macOS)"
        exit 1
    fi
    
    # Run shellcheck with diff format to show potential fixes
    for script in $scripts; do
        if [ -f "$script" ]; then
            echo "Analyzing $script for potential fixes..."
            shellcheck --format=diff "$script" || true
        fi
    done
    
    echo "Note: Automatic fixes shown above as diffs. Apply manually as needed."

# Run a quick syntax check on all scripts
syntax-check:
    #!/usr/bin/env bash
    echo "Running syntax check on all shell scripts..."
    
    # Find all .sh files and the dotfiles script
    scripts=$(find . -name "*.sh" -type f | grep -v ".git" | sort)
    scripts="$scripts ./bin/dotfiles"
    
    errors=0
    
    for script in $scripts; do
        if [ -f "$script" ]; then
            echo "Checking syntax of $script..."
            if ! bash -n "$script"; then
                errors=$((errors + 1))
            fi
        fi
    done
    
    if [ $errors -eq 0 ]; then
        echo "✅ All scripts have valid syntax!"
    else
        echo "❌ Found syntax errors in $errors script(s)"
        exit 1
    fi 
