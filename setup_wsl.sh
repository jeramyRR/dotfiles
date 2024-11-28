#! /usr/bin/env bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

## Individual config files
BASH_RC_SRC=".bashrc"
BASH_RC_DEST="$HOME/.bashrc"
GIT_CONFIG_SRC=".gitconfig"
GIT_CONFIG_DEST="$HOME/.gitconfig"
HUSHLOGIN_SRC=".hushlogin"
HUSHLOGIN_DEST="$HOME/.hushlogin"
INPUT_RC_SRC=".inputrc"
INPUT_RC_DEST="$HOME/.inputrc"
ZSH_RC_SRC=".zshrc"
ZSH_RC_DEST="$HOME/.zshrc"
ZSH_ENV_SRC=".zshenv"
ZSH_ENV_DEST="$HOME/.zshenv"

# Config directories
CONFIG_FOLDER_SRC="config"
CONFIG_FOLDER_DEST="$HOME/"
ZSH_FOLDER_SRC=".zsh"
ZSH_FOLDER_DEST="$HOME/"

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

copy_bash_rc() {
  echo "Copying $BASH_RC_SRC to $BASH_RC_DEST"
  copy_file "$BASH_RC_SRC" "$BASH_RC_DEST"
}

copy_git_config() {
  echo "Copying $GIT_CONFIG_SRC to $GIT_CONFIG_DEST"
  copy_file "$GIT_CONFIG_SRC" "$GIT_CONFIG_DEST"
}

copy_hushlogin() {
  echo "Copying $HUSHLOGIN_SRC to $HUSHLOGIN_DEST"
  copy_file "$HUSHLOGIN_SRC" "$HUSHLOGIN_DEST"
}

copy_input_rc() {
  echo "Copying $INPUT_RC_SRC to $INPUT_RC_DEST"
  copy_file "$INPUT_RC_SRC" "$INPUT_RC_DEST"
}

copy_zsh_rc() {
  echo "Copying $ZSH_RC_SRC to $ZSH_RC_DEST"
  copy_file "$ZSH_RC_SRC" "$ZSH_RC_DEST"
}

copy_zsh_env() {
  echo "Copying $ZSH_ENV_SRC to $ZSH_ENV_DEST"
  copy_file "$ZSH_ENV_SRC" "$ZSH_ENV_DEST"
}

copy_config_dir() {
  echo "Copying $CONFIG_FOLDER_SRC folder to $CONFIG_FOLDER_DEST"
  copy_dir "$CONFIG_FOLDER_SRC" "$CONFIG_FOLDER_DEST"
}

copy_zsh_dir() {
  echo "Copying $ZSH_FOLDER_SRC folder to $ZSH_FOLDER_DEST"
  copy_dir "$ZSH_FOLDER_SRC" "$ZSH_FOLDER_DEST"
}

main() {
  echo "Working out of script directory $SCRIPT_DIR"

  copy_bash_rc
  copy_git_config
  copy_hushlogin
  copy_input_rc
  copy_zsh_rc
  copy_zsh_env

  copy_config_dir
  copy_zsh_dir
}

main "$@"

