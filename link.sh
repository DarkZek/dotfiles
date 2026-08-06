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
  .config/git
  .config/nvim
  .config/ov
  .config/ranger
  .config/textual
  .config/tmux
  .config/todotxt-tui

  .todo.cfg
)

# Needs to exist before linking
CONFIG_DIR=~/.config

if [ ! -d "$CONFIG_DIR" ]; then
  mkdir -p $CONFIG_DIR

  success "Config dir" "created"
else
  skip "Config dir" "already exists, skipping…"
fi

for symlink in ${symlinks[@]}; do
  if [ -e "$HOME/$symlink" ] && ! [ -h "$HOME/$symlink" ]; then
    warn "$symlink" "exists. Please backup and/or remove this first"
  elif [ -h "$HOME/$symlink" ]; then
    skip "$symlink" "already linked, skipping…"
  else
    ln -s "$(pwd)/$symlink" "$HOME/$symlink"
    success "$symlink" "linked"
  fi
done

VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
VSCODE_SETTINGS="$VSCODE_USER_DIR/settings.json"

mkdir -p "$VSCODE_USER_DIR"

if [ -e "$VSCODE_SETTINGS" ] && ! [ -h "$VSCODE_SETTINGS" ]; then
  warn "VS Code settings" "exists. Please backup and/or remove this first"
elif [ -h "$VSCODE_SETTINGS" ]; then
  skip "VS Code settings" "already linked, skipping…"
else
  ln -s "$(pwd)/vscode/settings.json" "$VSCODE_SETTINGS"
  success "VS Code settings" "linked"
fi
