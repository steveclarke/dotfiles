# A collection of functions used in the dotfiles installation scripts

is_installed() {
	command -v "$1" >/dev/null 2>&1
}

banner() {
	echo "=== $1"
}

# Bootstrap-specific banner with decorative formatting
bootstrap_banner() {
	echo "========================================================================"
	echo " $1"
	echo "========================================================================"
}

installing_banner() {
  banner "Installing $1"
}

skipping() {
	echo "=== skipping $1 - already installed"
}

success() {
	echo "✓ $1"
}

error() {
	echo "✗ ERROR: $1" >&2
}

apt_install() {
	sudo apt install -y "$1"
}

# OS Detection and Platform Functions
detect_os() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    export DOTFILES_OS="macos"
    export DOTFILES_DISTRO="macos"
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    export DOTFILES_OS="linux"
    # Detect Linux distro
    if [[ -f /etc/os-release ]]; then
      local distro_id
      distro_id=$(. /etc/os-release && echo "$ID")
      case "$distro_id" in
        arch)
          export DOTFILES_DISTRO="arch"
          # Detect Omarchy specifically
          if [[ -d /usr/share/omarchy ]] || is_installed omarchy-update-system-pkgs; then
            export DOTFILES_DISTRO="omarchy"
          fi
          ;;
        ubuntu|pop) export DOTFILES_DISTRO="ubuntu" ;;
        debian)     export DOTFILES_DISTRO="debian" ;;
        *)          export DOTFILES_DISTRO="$distro_id" ;;
      esac
    else
      export DOTFILES_DISTRO="unknown"
    fi
  else
    echo "Unsupported OS: $OSTYPE"
    exit 1
  fi
}

is_macos() {
  [[ "$DOTFILES_OS" == "macos" ]]
}

is_linux() {
  [[ "$DOTFILES_OS" == "linux" ]]
}

is_arch() {
  [[ "$DOTFILES_DISTRO" == "arch" || "$DOTFILES_DISTRO" == "omarchy" ]]
}

is_omarchy() {
  [[ "$DOTFILES_DISTRO" == "omarchy" ]]
}

is_ubuntu() {
  [[ "$DOTFILES_DISTRO" == "ubuntu" || "$DOTFILES_DISTRO" == "debian" ]]
}

# macOS-specific helper functions
macos_defaults() {
  # Helper for setting macOS system preferences
  defaults write "$@"
}

# Sudo credential caching helper
cache_sudo_credentials() {
  if is_macos; then
    echo "Caching sudo credentials for package installation..."
    sudo -v
    
    # Keep sudo timestamp refreshed in background (for long installations)
    # This will refresh the timestamp every 60 seconds until the script exits
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
  fi
}

config_banner() {
  banner "Configuring $1"
}

do_stow() {
  stow -d "${DOTFILES_DIR}/configs" -t "${HOME}" "$1"
}

# Bootstrap-specific shared functions
check_dotfilesrc() {
	if test -f ~/.dotfilesrc; then
		source "$HOME"/.dotfilesrc
	else
		echo "ERROR: ~/.dotfilesrc does not exist"
		echo "Please download and configure it first:"
		if is_macos; then
			    echo "curl -o ~/.dotfilesrc https://raw.githubusercontent.com/steveclarke/dotfiles/master/.dotfilesrc.template"
		else
			    echo "wget -qO ~/.dotfilesrc https://raw.githubusercontent.com/steveclarke/dotfiles/master/.dotfilesrc.template"
		fi
		exit 2
	fi
}

# Write the SSH keys named in DOTFILES_SSH_KEYS to ~/.ssh, reading them out of
# 1Password. 1Password ships with Omarchy and is always reachable, so a new
# machine needs nothing but a 1Password login — no second machine powered on.
#
# DOTFILES_SSH_KEYS_OP maps each key name to its 1Password item:
#   "sevenview2020=op://Employee/<item-id> sevenview=op://Employee/<item-id>"
# Item ids rather than titles: stable, and no spaces to quote around.
fetch_ssh_keys_from_1password() {
	bootstrap_banner "Fetching SSH keys from 1Password"

	if ! is_installed op; then
		error "1Password CLI (op) not installed — open 1Password from the Omarchy menu"
		return 1
	fi

	if [[ -z "${DOTFILES_SSH_KEYS_OP:-}" ]]; then
		echo "DOTFILES_SSH_KEYS_OP not set in ~/.dotfilesrc, skipping"
		return 0
	fi

	mkdir -p "${HOME}/.ssh"
	chmod 700 "${HOME}/.ssh"

	local entry name ref priv pub
	for entry in ${DOTFILES_SSH_KEYS_OP}; do
		name="${entry%%=*}"
		ref="${entry#*=}"

		if [[ -f "${HOME}/.ssh/${name}" ]]; then
			echo "  ${name} already present, leaving it"
			continue
		fi

		# Written to a temp file first so a failed read cannot leave a
		# truncated key in place.
		priv=$(mktemp) && chmod 600 "$priv"
		if op read "${ref}/private key?ssh-format=openssh" > "$priv" 2>/dev/null &&
			[[ -s "$priv" ]]; then
			mv "$priv" "${HOME}/.ssh/${name}"
			chmod 600 "${HOME}/.ssh/${name}"
			echo "  ${name} written"
		else
			rm -f "$priv"
			error "  could not read ${ref}/private key"
			# `op whoami` is not a usable readiness check here: with the desktop
			# app integration it reports "not signed in" while reads work fine.
			echo "  If nothing has authorized the CLI yet: turn on 1Password >"
			echo "  Settings > Developer > Integrate with 1Password CLI, then run"
			echo "  'op item list' once and approve the prompt."
			continue
		fi

		pub=$(mktemp)
		if op read "${ref}/public key" > "$pub" 2>/dev/null && [[ -s "$pub" ]]; then
			mv "$pub" "${HOME}/.ssh/${name}.pub"
			chmod 644 "${HOME}/.ssh/${name}.pub"
		else
			rm -f "$pub"
			# Recoverable: the public key can be derived from the private one.
			ssh-keygen -y -f "${HOME}/.ssh/${name}" > "${HOME}/.ssh/${name}.pub" 2>/dev/null &&
				chmod 644 "${HOME}/.ssh/${name}.pub"
		fi
	done

	echo "SSH keys ready"
}

install_github_authorized_keys() {
	bootstrap_banner "Installing GitHub public keys into authorized_keys"

	local user="${DOTFILES_GITHUB_USER:-}"
	if [[ -z "$user" ]]; then
		echo "DOTFILES_GITHUB_USER not set in ~/.dotfilesrc, skipping"
		return 0
	fi

	mkdir -p "${HOME}/.ssh"
	chmod 700 "${HOME}/.ssh"
	local auth="${HOME}/.ssh/authorized_keys"
	touch "$auth"
	chmod 600 "$auth"

	local keys
	if ! keys=$(curl -fsSL "https://github.com/${user}.keys") || [[ -z "$keys" ]]; then
		echo "WARNING: could not fetch https://github.com/${user}.keys, skipping"
		return 0
	fi

	local added=0
	while IFS= read -r key; do
		[[ -z "$key" ]] && continue
		# Match on type + key blob; comments differ between copies of the same key
		local blob
		blob=$(echo "$key" | awk '{print $1" "$2}')
		if ! awk '{print $1" "$2}' "$auth" | grep -qxF "$blob"; then
			echo "$key" >> "$auth"
			added=$((added + 1))
		fi
	done <<< "$keys"

	echo "GitHub keys for ${user}: $(echo "$keys" | grep -c .) published, ${added} added"
}

onepassword_agent_sock() {
	if is_macos; then
		echo "${HOME}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
	else
		echo "${HOME}/.1password/agent.sock"
	fi
}

# True when the 1Password app is running with its SSH agent on. Auto-detected;
# DOTFILES_SSH_AGENT=keychain forces the old path, =1password forces this one.
use_onepassword_agent() {
	case "${DOTFILES_SSH_AGENT:-}" in
		1password) return 0 ;;
		keychain)  return 1 ;;
	esac
	[[ -S "$(onepassword_agent_sock)" ]]
}

# SSH signs with keys held in 1Password. No private key on disk, no key copy,
# no keychain.
configure_ssh_agent_1password() {
	bootstrap_banner "Configuring SSH to use the 1Password agent"
	mkdir -p "${HOME}/.ssh"; chmod 700 "${HOME}/.ssh"
	local cfg="${HOME}/.ssh/config" sock
	sock=$(onepassword_agent_sock)
	[[ -f "$cfg" ]] || { touch "$cfg"; chmod 600 "$cfg"; }
	if grep -q "IdentityAgent" "$cfg"; then
		echo "IdentityAgent already set in ~/.ssh/config, leaving it"
	else
		printf '\nHost *\n\tIdentityAgent "%s"\n' "$sock" >> "$cfg"
		echo "Added IdentityAgent for 1Password to ~/.ssh/config"
	fi
	[[ -S "$sock" ]] || echo "WARNING: 1Password agent socket not found at $sock (app not running, or SSH agent off)"
}

configure_ssh() {
	bootstrap_banner "Configuring SSH"
	
	# Create SSH config if it doesn't exist
	if [ ! -f "${HOME}/.ssh/config" ]; then
		touch "${HOME}/.ssh/config"
		chmod 600 "${HOME}/.ssh/config"
	fi
	
	# Add identity file to SSH config, once. This used to append every run, so a
	# machine that had install.sh run twice ended up with duplicate IdentityFile
	# lines.
	local line="IdentityFile ~/.ssh/$DOTFILES_SSH_KEYS_PRIMARY"
	if grep -qxF "$line" "${HOME}/.ssh/config" 2>/dev/null; then
		echo "IdentityFile already set in ~/.ssh/config, leaving it"
	else
		echo "$line" >> "${HOME}/.ssh/config"
	fi
}

clone_git_repo() {
	bootstrap_banner "Cloning git repo"

	if test -d "${DOTFILES_DIR}"; then
		echo "${DOTFILES_DIR} already exists"
	else
		if is_macos; then
			mkdir -p "$(dirname "${DOTFILES_DIR}")"
		fi
		    git clone git@github.com:steveclarke/dotfiles "${DOTFILES_DIR}"
	fi
}

bootstrap_warning() {
	if tput colors >/dev/null 2>&1 && [[ $(tput colors) -gt 0 ]]; then
		echo -e "\033[0;31m!!!!!!!!!!!!!!!!!!!!!!!!!!!\033[0m"
		echo -e "\033[0;31m!!!!!!!!! WARNING !!!!!!!!!\033[0m"
		echo -e "\033[0;31m!!!!!!!!!!!!!!!!!!!!!!!!!!!\033[0m"
	else
		echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!"
		echo "!!!!!!!!! WARNING !!!!!!!!!"
		echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	fi
	
	if is_macos; then
		echo -e "This script is designed to bootstrap a fresh macOS system and may overwrite existing files."
	else
		echo -e "This script is designed to boostrap a fresh system and may overwrite existing files."
	fi
	echo -e "Are you sure you want to proceed?"
}

bootstrap_confirm() {
	echo -n "Do you want to proceed? (y/N): "
	read -r answer
	
	# convert answer to lowercase
	answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')
	
	if [ "$answer" = "y" ] || [ "$answer" = "yes" ]; then
		return 0
	else
		echo "Exiting..."
		return 1
	fi
}

install_linux_prerequisites() {
	bootstrap_banner "Installing bootstrap pre-requisites"
	sudo apt update &&
		sudo apt install -y \
			git \
			curl \
			software-properties-common \
			build-essential
}

install_macos_prerequisites() {
	bootstrap_banner "Installing bootstrap pre-requisites"
	
	# Install Xcode Command Line Tools if not already installed
	if ! xcode-select -p &>/dev/null; then
		echo "Installing Xcode Command Line Tools..."
		xcode-select --install
		echo "Please complete the Xcode Command Line Tools installation and re-run this script."
		exit 1
	fi
	
	# Install Homebrew if not already installed
	if ! command -v brew &>/dev/null; then
		echo "Installing Homebrew..."
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		
		# Add Homebrew to PATH for current session
		eval "$(/opt/homebrew/bin/brew shellenv)"
		
		# Also add to shell profile for future sessions
		echo "eval \"\$(/opt/homebrew/bin/brew shellenv)\"" >> "${HOME}/.zprofile"
	fi
	
	# Install git if not already available
	if ! command -v git &>/dev/null; then
		echo "Installing git..."
		brew install git
	fi
}

run_installation() {
	bootstrap_banner "Running dotfiles installation"
	
	cd "${DOTFILES_DIR}" || exit 1
	bash install.sh
}

# [[ GitHub release / AppImage helpers ]]

# Latest tag on a repo that starts with a given prefix.
# Usage: github_latest_tag <owner/repo> <tag-prefix>
github_latest_tag() {
	local tag
	tag=$(gh release list --repo "$1" --limit 100 --json tagName \
		--jq "[.[] | select(.tagName | startswith(\"$2\"))][0].tagName" 2>/dev/null)
	[[ -z "$tag" || "$tag" == "null" ]] && return 1
	echo "$tag"
}

# True when ~/Applications already holds this app at this version.
# Usage: appimage_is_installed <Name> <version>
appimage_is_installed() {
	compgen -G "${HOME}/Applications/${1}-${2}*.AppImage" >/dev/null
}

# Install an AppImage into ~/Applications and add it to the app menu.
# Older versions of the same app are removed. AppImageLauncher does the
# menu entry when it is available; otherwise a desktop entry is written
# by hand with the icon pulled out of the AppImage.
# Usage: install_appimage <Name> <version> <downloaded-file>
install_appimage() {
	local name=$1 version=$2 src=$3
	local dest_dir="${HOME}/Applications"
	local dest="${dest_dir}/${name}-${version}.AppImage"

	mkdir -p "$dest_dir"
	command install -Dm755 "$src" "$dest"

	if is_installed ail-cli && ail-cli integrate "$dest" >/dev/null 2>&1; then
		# AppImageLauncher renames the file as it integrates it
		local integrated
		integrated=$(compgen -G "${dest_dir}/${name}-${version}*.AppImage" | head -1)
		[[ -n "$integrated" ]] && dest="$integrated"
	else
		_appimage_desktop_entry "$name" "$dest"
	fi

	_appimage_remove_other_versions "$name" "$dest"
	success "${name} ${version} installed (${dest})"
}

# Write a desktop entry for an AppImage, with its icon if one can be found.
_appimage_desktop_entry() {
	local name=$1 app=$2
	local icon_dir="${HOME}/.local/share/icons"
	local icon="$name"
	local tmpdir

	tmpdir=$(mktemp -d)
	if (cd "$tmpdir" && "$app" --appimage-extract '*.png' >/dev/null 2>&1); then
		local extracted
		extracted=$(compgen -G "${tmpdir}/squashfs-root/*.png" | head -1)
		if [[ -n "$extracted" ]]; then
			command install -Dm644 "$extracted" "${icon_dir}/${name}.png"
			icon="${icon_dir}/${name}.png"
		fi
	fi
	rm -rf "$tmpdir"

	mkdir -p "${HOME}/.local/share/applications"
	cat > "${HOME}/.local/share/applications/${name}.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=${name}
Exec=${app} %U
Icon=${icon}
Terminal=false
Categories=Utility;
StartupWMClass=${name}
EOF
	update-desktop-database "${HOME}/.local/share/applications" >/dev/null 2>&1 || true
}

# Drop AppImages of the same app that are not the one just installed.
_appimage_remove_other_versions() {
	local name=$1 keep=$2 old
	while IFS= read -r old; do
		[[ "$old" == "$keep" ]] && continue
		is_installed ail-cli && ail-cli unintegrate "$old" >/dev/null 2>&1
		rm -f "$old"
		banner "removed old ${name} AppImage: $(basename "$old")"
	done < <(compgen -G "${HOME}/Applications/${name}-*.AppImage" || true)
}
