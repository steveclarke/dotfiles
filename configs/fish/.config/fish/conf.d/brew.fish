# Set up Homebrew environment based on OS
if test -d /opt/homebrew
    # macOS (Apple Silicon and Intel)
    eval "$(/opt/homebrew/bin/brew shellenv)"
else if test -d /home/linuxbrew/.linuxbrew
    # Linux (Homebrew on Linux)
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else if test -d /usr/local/Homebrew
    # macOS (Intel - older installations)
    eval "$(/usr/local/bin/brew shellenv)"
end
