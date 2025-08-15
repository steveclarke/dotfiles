#!/usr/bin/env bash
# Install Docker Engine
# Reference: https://docs.docker.com/engine/install/ubuntu/

# Enable strict error handling
set -euo pipefail

# Source required libraries
source "${DOTFILES_DIR}/lib/linux.sh"

# Dependency declarations
SCRIPT_DEPENDS_COMMANDS=("wget" "apt" "usermod" "tee")
SCRIPT_DEPENDS_PACKAGES=("ca-certificates" "curl" "wget")
SCRIPT_DEPENDS_PLATFORM=("linux")
SCRIPT_DEPENDS_DISTRO=("ubuntu")
SCRIPT_DEPENDS_ENV=("USER" "DOTFILES_DIR")
SCRIPT_DEPENDS_DIRS=("/etc/apt/keyrings" "/etc/apt/sources.list.d")
SCRIPT_DEPENDS_CONFLICTS=("snap:docker")
SCRIPT_DEPENDS_MINIMUM_VERSION=("wget:1.0" "curl:7.0")

# Main installation function
install_docker() {
  log_banner "Installing Docker Engine"
  
  # Start progress tracking
  progress_start 6 "Docker Engine Installation"
  
  # Step 1: Install prerequisites
  progress_step "Installing prerequisites"
  log_info "Installing prerequisite packages"
  
  validate_commands "apt" "wget" "curl"
  
  local prereq_packages=("ca-certificates" "curl" "wget")
  for package in "${prereq_packages[@]}"; do
    if apt_install "$package"; then
      log_debug "✓ $package installed successfully"
    else
      log_error "✗ Failed to install $package"
      return 1
    fi
  done
  
  # Step 2: Create keyrings directory
  progress_step "Setting up Docker GPG keyring"
  log_info "Creating Docker keyring directory"
  
  if sudo install -m 0755 -d /etc/apt/keyrings; then
    log_debug "Created /etc/apt/keyrings directory"
  else
    log_error "Failed to create /etc/apt/keyrings directory"
    return 1
  fi
  
  # Step 3: Download Docker GPG key
  progress_step "Downloading Docker GPG key"
  log_info "Downloading Docker official GPG key"
  
  if sudo wget -qO /etc/apt/keyrings/docker.asc https://download.docker.com/linux/ubuntu/gpg; then
    log_success "Docker GPG key downloaded successfully"
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    log_debug "Set appropriate permissions for Docker GPG key"
  else
    log_error "Failed to download Docker GPG key"
    return 1
  fi
  
  # Step 4: Add Docker repository
  progress_step "Adding Docker repository"
  log_info "Adding Docker repository to apt sources"
  
  local docker_repo="deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable"
  
  if echo "$docker_repo" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null; then
    log_success "Docker repository added successfully"
    log_debug "Repository: $docker_repo"
  else
    log_error "Failed to add Docker repository"
    return 1
  fi
  
  # Step 5: Install Docker packages
  progress_step "Installing Docker packages"
  log_info "Updating package index and installing Docker"
  
  if sudo apt update; then
    log_debug "Package index updated successfully"
  else
    log_error "Failed to update package index"
    return 1
  fi
  
  local docker_packages=(
    "docker-ce"
    "docker-ce-cli"
    "containerd.io"
    "docker-buildx-plugin"
    "docker-compose-plugin"
    "docker-ce-rootless-extras"
  )
  
  for package in "${docker_packages[@]}"; do
    if apt_install "$package"; then
      log_debug "✓ $package installed successfully"
    else
      log_error "✗ Failed to install $package"
      return 1
    fi
  done
  
  # Step 6: Configure Docker
  progress_step "Configuring Docker"
  log_info "Configuring Docker daemon and user permissions"
  
  # Add current user to docker group
  if sudo usermod -aG docker "${USER}"; then
    log_success "Added ${USER} to docker group"
    log_info "💡 Please log out and back in for Docker group membership to take effect"
  else
    log_error "Failed to add ${USER} to docker group"
    return 1
  fi
  
  # Configure Docker daemon with log rotation
  log_info "Configuring Docker daemon with log rotation"
  local docker_config='{"log-driver":"json-file","log-opts":{"max-size":"10m","max-file":"5"}}'
  
  if echo "$docker_config" | sudo tee /etc/docker/daemon.json > /dev/null; then
    log_success "Docker daemon configured with log rotation"
    log_debug "Docker daemon config: $docker_config"
  else
    log_error "Failed to configure Docker daemon"
    return 1
  fi
  
  # Complete installation
  progress_complete
  log_success "Docker Engine installation completed successfully"
  
  # Verify installation
  if command -v docker >/dev/null 2>&1; then
    local docker_version
    docker_version=$(docker --version)
    log_info "Docker version: $docker_version"
  else
    log_warn "Docker command not found in PATH - restart may be required"
  fi
  
  # Show next steps
  log_info "Next steps:"
  log_info "  1. Log out and back in to apply Docker group membership"
  log_info "  2. Test Docker with: docker run hello-world"
  log_info "  3. Check Docker service status: sudo systemctl status docker"
}

# Main execution
if ! is_installed docker; then
  install_docker
else
  log_warn "Docker Engine is already installed"
  log_info "Current Docker version: $(docker --version)"
fi
