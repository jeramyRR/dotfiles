#!/bin/bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

## Individual config files
# Config directories
CONFIG_FOLDER_SRC="config"
CONFIG_FOLDER_DEST="$HOME/.config"

GIT_CONFIG_SRC=".gitconfig"
GIT_CONFIG_DEST="$HOME/.gitconfig"

FISH_CONFIG_SRC=".${CONFIG_FOLDER_SRC}/fish/config.fish"
FISH_CONFIG_DEST="${CONFIG_FOLDER_DEST}/fish/config.fish"


copy_file() {
  local src="$1"
  local dest="$2"
  
  if [[ -f "$src" ]]; then
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
    cp -rf $src $dest
    if [[ $? -ne 0 ]]; then
      echo "Failed to copy $src folder to $dest"
      exit 1
    fi
  fi
}

copy_git_config() {
  echo "Copying $GIT_CONFIG_SRC to $GIT_CONFIG_DEST"
  copy_file "$GIT_CONFIG_SRC" "$GIT_CONFIG_DEST"
}

copy_config_dir() {
  echo "Copying $CONFIG_FOLDER_SRC folder to $CONFIG_FOLDER_DEST"
  copy_dir "$CONFIG_FOLDER_SRC" "$CONFIG_FOLDER_DEST"
}

copy_fish_config() {
  echo "Copying $FISH_CONFIG_SRC folder to $FISH_CONFIG_DEST"
  copy_dir "$FISH_CONFIG_SRC" "$FISH_CONFIG_DEST"
}

install_homebrew() {
  if [[ -x /opt/homebrew/bin/brew ]]; then
    echo "Homebrew already installed"
  else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo >> /Users/jeramy/.zprofile
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/jeramy/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
}

install_tools() {
  brew install coreutils curl git direnv fish starship fzf onefetch eza fastfetch bat

  # Install asdf
  if [[ -d ~/.asdf ]]; then
    echo "asdf already installed"
  else
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.1
  fi
}

set_fish_default_shell() {
  if [[ -x /opt/homebrew/bin/fish ]]; then
    echo "Setting fish as default shell"

    echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
    chsh -s /opt/homebrew/bin/fish

    # Now switch to fish
    fish

    fish_add_path "/opt/homebrew/bin/"
    fish_update_completions

    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
    fisher install patrickf1/fzf.fish
    source ~/.config/fish/config.fish
  else
    echo "Fish shell not found"
  fi
}

main() {
  echo "Working out of script directory $SCRIPT_DIR"

  install_homebrew
  install_tools

  copy_git_config
  copy_config_dir
  copy_fish_config

  set_fish_default_shell
}

main "$@"

