/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" &&
  cd "${DOTFILES_DIR}" &&
  (
    echo
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'
  ) >>"${HOME}"/.bashrc &&
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" &&
  brew bundle
