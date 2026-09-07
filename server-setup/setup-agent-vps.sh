#!/usr/bin/env bash
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
  echo "Lance ce script avec sudo/root."
  exit 1
fi

apt update

apt install -y \
  git git-lfs \
  curl wget \
  jq \
  rsync \
  tree \
  lsof \
  zip unzip \
  tmux \
  sqlite3 \
  build-essential \
  gcc g++ make \
  cmake pkg-config \
  ffmpeg \
  imagemagick \
  blender \
  python3 python3-dev python3-venv \
  docker.io docker-compose-v2 \
  ripgrep

if ! id agent >/dev/null 2>&1; then
  useradd -m -s /bin/bash agent
fi

usermod -aG docker agent
systemctl enable --now docker

if ! swapon --show | grep -q '/swapfile'; then
  fallocate -l 4G /swapfile
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile

  if ! grep -q '^/swapfile ' /etc/fstab; then
    echo '/swapfile none swap sw 0 0' >> /etc/fstab
  fi
fi

echo "Installation système terminée."


# Node.js 22
curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
apt install -y nodejs

# Tailscale
curl -fsSL https://tailscale.com/install.sh | sh

echo
echo "Node : $(node --version 2>/dev/null || true)"
echo "npm  : $(npm --version 2>/dev/null || true)"
echo "Tailscale installé. Connexion à faire ensuite avec : sudo tailscale up"
