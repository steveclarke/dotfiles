# https://mise.jdx.dev/getting-started.html

# Note: Ensure Ruby dependencies are installed before running `mise use ruby@latest`.
# See script in `install/linux/prereq/ruby.sh`

curl https://mise.run | sh

"${HOME}"/.local/bin/mise --version

echo "eval \"\$(${HOME}/.local/bin/mise activate bash)\"" >> ~/.bashrc

# Note: Fish config is already in place via Fish config files
