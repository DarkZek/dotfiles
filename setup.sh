#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/setup/util.sh"

# Link dotfiles
./link.sh

# Install Git and Jujutsu
./setup/git

# Install Brew packages
./setup/brew ./Brewfile.base

# Install global npm packages
./setup/npm ./npmfile.base

title "Set up GitHub"

if gh auth status >/dev/null 2>&1; then
  skip "GitHub" "already logged in, skipping"
else
  gh auth login
fi

if ! jj root >/dev/null 2>&1; then
  jj git init --colocate
fi

jj git remote set-url origin git@github.com:darkzek/dotfiles.git
success "Dotfiles remote updated for write access"
