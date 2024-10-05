#!/usr/bin/env bash

# This fixes local DNS resolution on Ubuntu. Default Ubuntu uses
# systemd-resolved with DNSStubListener=yes, which causes DNS lookups on
# my internal network's DNS server to fail. This script disables
# the DNSStubListener setting.

# Create the override directory if it doesn't exist
sudo mkdir -p /etc/systemd/resolved.conf.d

# Create the override file with DNSStubListener=no
echo "[Resolve]" | sudo tee /etc/systemd/resolved.conf.d/override.conf > /dev/null
echo "DNSStubListener=no" | sudo tee -a /etc/systemd/resolved.conf.d/override.conf > /dev/null

# Restart systemd-resolved to apply the changes
echo "Restarting systemd-resolved..."
sudo systemctl restart systemd-resolved

# Verify that the override was applied
echo "Verifying override..."
systemctl show systemd-resolved --property=FragmentPath
