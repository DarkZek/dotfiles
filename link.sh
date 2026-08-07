#!/usr/bin/env bash

source "$(dirname "$0")/setup/util.sh"

title "Linking Dotfiles"

symlinks=(
  .aliases
  .editorconfig
  .functions

  .gitconfig
  .gitconfig.local
  .gitignore-global

  .zsh
  .zshrc
  .zprofile

  .scripts

  .copilot

  .config/ghostty

  .todo.cfg
)

# Needs to exist before linking
CONFIG_DIR=~/.config

if [ ! -d "$CONFIG_DIR" ]; then
  mkdir -p "$CONFIG_DIR"

  success "Config dir" "created"
else
  skip "Config dir" "already exists, skipping…"
fi

link_dotfile() {
  local source="$1"
  local target="$2"
  local name="$3"

  if [ -e "$target" ] && ! [ -h "$target" ]; then
    warn "$name" "exists. Please backup and/or remove this first"
  elif [ -h "$target" ]; then
    skip "$name" "already linked, skipping…"
  else
    ln -s "$(pwd)/$source" "$target"
    success "$name" "linked"
  fi
}

for symlink in "${symlinks[@]}"; do
  link_dotfile "$symlink" "$HOME/$symlink" "$symlink"
done

VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
VSCODE_SETTINGS="$VSCODE_USER_DIR/settings.json"
VSCODE_EXTENSIONS=".config/vscode/extensions.txt"

mkdir -p "$VSCODE_USER_DIR"
link_dotfile ".config/vscode/settings.json" "$VSCODE_SETTINGS" "VS Code settings"

if command -v code >/dev/null 2>&1; then
  while IFS= read -r extension; do
    [ -z "$extension" ] || code --install-extension "$extension"
  done < "$VSCODE_EXTENSIONS"
  success "VS Code extensions" "installed"
else
  warn "VS Code extensions" "code command not found, skipping"
fi
