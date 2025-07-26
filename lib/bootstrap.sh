# Bootstrap-specific functions for dotfiles installation

# Source core functions
source "${DOTFILES_DIR}/lib/dotfiles.sh"

# Bootstrap-specific banner with decorative formatting
bootstrap_banner() {
	echo "========================================================================"
	echo " $1"
	echo "========================================================================"
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

copy_ssh_keys() {
	bootstrap_banner "Copying SSH keys"
	
	# Create .ssh directory if it doesn't exist
	mkdir -p "${HOME}/.ssh"
	chmod 700 "${HOME}/.ssh"
	
	# Check if SSH keys already exist locally
	local keys_exist=true
	for key in ${DOTFILES_SSH_KEYS}; do
		if [[ ! -f "${HOME}/.ssh/${key}" ]]; then
			keys_exist=false
			break
		fi
	done
	
	if [[ "$keys_exist" == "true" ]]; then
		echo "SSH keys already exist locally, skipping copy"
		return 0
	fi
	
	# Test if remote host is reachable
	echo "Testing connection to ${DOTFILES_SSH_KEYS_HOST}..."
	
	# First try key-based authentication (no password prompt)
	if ssh -o ConnectTimeout=5 -o BatchMode=yes "${DOTFILES_SSH_KEYS_HOST}" 'exit 0' 2>/dev/null; then
		echo "✅ Remote host reachable (key-based auth), copying SSH keys..."
		copy_method="key-based"
	else
		# Try regular connection (may prompt for password)
		echo "🔑 Key-based auth failed, testing password authentication..."
		echo "You may be prompted for a password..."
		if ssh -o ConnectTimeout=5 "${DOTFILES_SSH_KEYS_HOST}" 'exit 0'; then
			echo "✅ Remote host reachable (password auth), copying SSH keys..."
			copy_method="password"
		else
			echo "❌ Cannot reach ${DOTFILES_SSH_KEYS_HOST}"
			copy_method="failed"
		fi
	fi
	
	if [[ "$copy_method" != "failed" ]]; then
		# Copy each SSH key individually for better error handling
		for key in ${DOTFILES_SSH_KEYS}; do
			echo "Copying ${key}..."
			if scp "${DOTFILES_SSH_KEYS_HOST}:.ssh/${key}" "${HOME}/.ssh/${key}"; then
				echo "✓ ${key} copied successfully"
			else
				echo "⚠ Failed to copy ${key} (may not exist on remote host)"
			fi
		done
		
		# Set proper permissions
		echo "Setting SSH key permissions..."
		if is_macos; then
			chmod 600 "${HOME}/.ssh/"* 2>/dev/null || true
			chmod 644 "${HOME}/.ssh/"*.pub 2>/dev/null || true
		else
			chmod 600 "${HOME}/.ssh/"* 2>/dev/null || true
			chmod 644 "${HOME}/.ssh/"*.pub 2>/dev/null || true
		fi
		echo "SSH keys processing complete"
	else
		echo "WARNING: Cannot reach ${DOTFILES_SSH_KEYS_HOST}"
		echo "SSH keys will need to be copied manually to ${HOME}/.ssh/"
		echo "Required keys: ${DOTFILES_SSH_KEYS}"
		echo ""
		echo "You can either:"
		echo "1. Copy the keys manually to ${HOME}/.ssh/"
		echo "2. Update DOTFILES_SSH_KEYS_HOST in ~/.dotfilesrc to a reachable host"
		echo "3. Skip SSH key copying if you'll set them up differently"
		echo ""
		echo "Press Enter to continue without copying SSH keys, or Ctrl+C to abort..."
		read -r
	fi
}

configure_ssh() {
	bootstrap_banner "Configuring SSH"
	
	# Create SSH config if it doesn't exist
	if [ ! -f "${HOME}/.ssh/config" ]; then
		touch "${HOME}/.ssh/config"
		chmod 600 "${HOME}/.ssh/config"
	fi
	
	# Add identity file to SSH config
	echo "IdentityFile ~/.ssh/$DOTFILES_SSH_KEYS_PRIMARY" >> "${HOME}/.ssh/config"
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

run_installation() {
	bootstrap_banner "Running dotfiles installation"
	
	cd "${DOTFILES_DIR}" || exit 1
	bash install.sh
} 
