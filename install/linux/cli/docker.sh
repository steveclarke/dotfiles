# Install Docker Engine
# Reference: https://docs.docker.com/engine/install/ubuntu/

if ! is_installed docker; then
  installing_banner "Docker Engine"
  
  # Install prerequisites
  apt_install ca-certificates curl wget
  
  # Add Docker's official GPG key and repository
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo wget -qO /etc/apt/keyrings/docker.asc https://download.docker.com/linux/ubuntu/gpg
  sudo chmod a+r /etc/apt/keyrings/docker.asc
  
  # Add Docker repository to Apt sources
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  
  # Update package index and install Docker
  sudo apt update
  apt_install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras
  
  # Add current user to docker group for privileged access
  sudo usermod -aG docker "${USER}"
  
  # Configure Docker daemon with log rotation to prevent disk space issues
  echo '{"log-driver":"json-file","log-opts":{"max-size":"10m","max-file":"5"}}' | sudo tee /etc/docker/daemon.json > /dev/null
  
  echo "✅ Docker installed successfully"
  echo "💡 Please log out and back in for Docker group membership to take effect"
else
  skipping "Docker Engine"
fi
