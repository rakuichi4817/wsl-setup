#!/usr/bin/env bash
set -Eeuo pipefail

# エラー発生箇所を表示
trap 'echo; echo "❌ Setup failed at line $LINENO"; echo "Command: $BASH_COMMAND"' ERR

# ------------------------------
# Setup
# ------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# mise / OpenCode のインストール先を先に PATH へ追加
# インストール直後でも command -v で検出できるようにする
export PATH="$HOME/.local/bin:$HOME/.opencode/bin:$PATH"

echo "======================================"
echo " WSL Development Environment Setup"
echo "======================================"

# ------------------------------
# Ubuntu update
# ------------------------------
echo
echo "==> Updating Ubuntu..."

sudo apt update
sudo apt upgrade -y

# ------------------------------
# Base packages
# ------------------------------
echo
echo "==> Installing base packages..."

sudo apt install -y \
  build-essential \
  ca-certificates \
  curl \
  wget \
  git \
  zsh \
  direnv \
  unzip \
  jq \
  locales

# ------------------------------
# Japanese locale
# ------------------------------
echo
echo "==> Setting Japanese locale..."

sudo locale-gen ja_JP.UTF-8

# ------------------------------
# mise
# ------------------------------
echo
echo "==> Installing mise..."

if ! command -v mise >/dev/null 2>&1; then
  curl -fsSL https://mise.run | sh
else
  echo "✓ mise already installed"
fi

# ------------------------------
# Oh My Zsh
# ------------------------------
echo
echo "==> Installing Oh My Zsh..."

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "✓ Oh My Zsh already installed"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# ------------------------------
# Zsh plugins
# ------------------------------
echo
echo "==> Installing Zsh plugins..."

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone \
    https://github.com/zsh-users/zsh-autosuggestions \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
  echo "✓ zsh-autosuggestions already installed"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  git clone \
    https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
  echo "✓ zsh-syntax-highlighting already installed"
fi

# ------------------------------
# GitHub CLI
# ------------------------------
echo
echo "==> Installing GitHub CLI..."

if ! command -v gh >/dev/null 2>&1; then
  sudo mkdir -p -m 755 /etc/apt/keyrings

  wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null

  sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg

  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null

  sudo apt update
  sudo apt install -y gh
else
  echo "✓ GitHub CLI already installed"
fi

# ------------------------------
# OpenCode
# ------------------------------
echo
echo "==> Installing OpenCode..."

if ! command -v opencode >/dev/null 2>&1; then
  curl -fsSL https://opencode.ai/install | bash
else
  echo "✓ OpenCode already installed"
fi

# ------------------------------
# .zshrc
# ------------------------------
echo
echo "==> Installing .zshrc..."

cp "$SCRIPT_DIR/dotfiles/.zshrc" "$HOME/.zshrc"

# ------------------------------
# Default shell
# ------------------------------
echo
echo "==> Setting zsh as default shell..."

ZSH_PATH="$(command -v zsh)"
CURRENT_SHELL="$(getent passwd "$USER" | cut -d: -f7)"

if [ "$CURRENT_SHELL" != "$ZSH_PATH" ]; then
  chsh -s "$ZSH_PATH"
else
  echo "✓ zsh is already the default shell"
fi

# ------------------------------
# Docker Desktop integration
# ------------------------------
echo
echo "==> Checking Docker Desktop integration..."

if command -v docker >/dev/null 2>&1; then
  echo "✓ Docker CLI detected"

  if docker info >/dev/null 2>&1; then
    echo "✓ Docker Desktop integration detected"
  else
    echo "⚠ Docker CLI detected, but Docker daemon is unavailable"
    echo "  Check Docker Desktop and WSL Integration."
  fi
else
  echo "⚠ Docker CLI not found"
  echo "  Enable this distro in:"
  echo "  Docker Desktop > Settings > Resources > WSL Integration"
fi

# ------------------------------
# Install result
# ------------------------------
echo
echo "======================================"
echo " Installed versions"
echo "======================================"

command -v git >/dev/null 2>&1 \
  && echo "✓ Git        $(git --version)"

command -v zsh >/dev/null 2>&1 \
  && echo "✓ Zsh        $(zsh --version)"

command -v mise >/dev/null 2>&1 \
  && echo "✓ mise       $(mise --version)"

command -v direnv >/dev/null 2>&1 \
  && echo "✓ direnv     $(direnv version)"

command -v gh >/dev/null 2>&1 \
  && echo "✓ GitHub CLI $(gh --version | head -n 1)"

command -v opencode >/dev/null 2>&1 \
  && echo "✓ OpenCode   $(opencode --version)"

command -v docker >/dev/null 2>&1 \
  && echo "✓ Docker     $(docker --version)"

echo
echo "======================================"
echo " Setup completed!"
echo "======================================"
echo
echo "Next:"
echo "  exec zsh"
echo "  gh auth login"
