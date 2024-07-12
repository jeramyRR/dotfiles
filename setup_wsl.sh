#! /usr/bin/env bash

set -o nounset
set -o errexit
set -o pipefail

if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

## Individual config files
BASH_RC_SRC="rc/.bashrc"
BASH_RC_DEST="$HOME/"
GIT_CONFIG_SRC=".config/.gitconfig"
GIT_CONFIG_DEST="$HOME/"
HUSHLOGIN_SRC=".hushlogin"
HUSHLOGIN_DEST="$HOME/"
INPUT_RC_SRC="rc/.inputrc"
INPUT_RC_DEST="$HOME/"
STARSHIP_RC_SRC=".config/.starship.rc"
STARSHIP_RC_DEST="$HOME/"
ZSH_RC_SRC="rc/.zshrc"
ZSH_RC_DEST="$HOME/"
ZSH_OHMY_RC_SRC="rc/"
ZSH_OHMY_RC_DEST="$HOME/"
ZSH_ENV_SRC=".zshenv"
ZSH_ENV_DEST="$HOME/"

# Config directories
CONFIG_FOLDER_SRC=".config"
CONFIG_FOLDER_DEST="$HOME/"
ZSH_FOLDER_SRC=".zsh"
ZSH_FOLDER_DEST="$HOME/"

copy_file() {
  local src="$1"
  local dest="$2"
  
  if [[ -f "$src" ]]; then
    echo "Copying $src to $dest"
    cp -f "$src" "$dest"
   
    if [[ $? -ne 0 ]]; then
      echo "Failed to copy $src to $dest"
      exit 1
    fi
  fi

}

copy_dir() { 
  local src="$1"
  local dest="$2"

  if [[ -d "$src" ]]; then
  echo "Copying $src folder to $dest"
    cp -rf $src $dest
    if [[ $? -ne 0 ]]; then
      echo "Failed to copy $src folder to $dest"
      exit 1
    fi
  fi
}

install_rust() {
  echo "Installing rustup"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh  
}

install_starship() {
  if [[ -f /usr/local/bin/starship ]]; then
    echo "starship.rs already exists, skipping"
    return
  fi

  echo "Installing Starship.rs"
  curl -sS https://starship.rs/install.sh | sh
    
  if [[ $? -ne 0 ]]; then
    echo "Failed to install starship.rs"
    exit 1
  fi
}

install_ohmyzsh() {
  if [[ ! -f /usr/bin/zsh ]]; then
    echo "Installing zsh"
    sudo apt install zsh -y
  fi

  echo "Installing oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  if [[ $? -ne 0 ]]; then
    echo "Failed to install oh-my-zsh"
    exit 1
  fi
}

main() {
  echo "Working out of script directory $SCRIPT_DIR"

  install_rust
  install_starship
  install_ohmyzsh

  copy_file "$BASH_RC_SRC" "$BASH_RC_DEST"
  copy_file "$GIT_CONFIG_SRC" "$GIT_CONFIG_DEST"
  copy_file "$HUSHLOGIN_SRC" "$HUSHLOGIN_DEST"
  copy_file "$INPUT_RC_SRC" "$INPUT_RC_DEST"
  copy_file "$STARSHIP_RC_SRC" "$STARSHIP_RC_DEST"
  copy_file "$ZSH_RC_SRC" "$ZSH_RC_DEST"
  copy_file "$ZSH_OHMY_RC_SRC" "$ZSH_OHMY_RC_DEST"
  copy_file "$ZSH_ENV_SRC" "$ZSH_ENV_DEST"

  copy_dir "$CONFIG_FOLDER_SRC" "$CONFIG_FOLDER_DEST"
  copy_dir "$ZSH_FOLDER_SRC" "$ZSH_FOLDER_DEST"

  echo "Setup complete.  Please close out your terminal and reopen."
}

main "$@"

