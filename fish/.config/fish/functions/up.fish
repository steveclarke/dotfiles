function up
  sudo nala upgrade
  and  flatpak upgrade
  and echo "Upgrading nix packages..."
  and  nix-env -u
end
