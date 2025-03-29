#!/usr/bin/env bash
set -euo pipefail

# Terraform Installer for Ubuntu
# This script installs HashiCorp Terraform on Ubuntu

# Check if Terraform is already installed
if command -v terraform &> /dev/null; then
    echo "Terraform is already installed."
    terraform --version
    exit 0
fi

echo "Installing Terraform..."

# Add HashiCorp GPG key
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

# Add HashiCorp repository
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# Update package list
sudo apt-get update

# Install Terraform
sudo apt-get install -y terraform

# Verify installation
echo "Verifying installation..."
terraform --version

echo "Terraform installation complete."
