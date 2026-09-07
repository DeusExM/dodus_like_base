#!/usr/bin/env bash
set -euo pipefail

mkdir -p "$HOME/.npm-global"
npm config set prefix "$HOME/.npm-global"

if ! grep -q '.npm-global/bin' "$HOME/.bashrc"; then
  echo 'export PATH="$HOME/.npm-global/bin:$PATH"' >> "$HOME/.bashrc"
fi

export PATH="$HOME/.npm-global/bin:$PATH"

npm install -g opencode-ai@1.18.29
npm install -g playwright@1.63.0
npm install -g pnpm

playwright install chromium

echo
echo "Installation utilisateur agent terminée."
echo "OpenCode : $(opencode --version 2>/dev/null || echo non détecté)"
echo "Node     : $(node --version 2>/dev/null || echo non détecté)"
echo "npm      : $(npm --version 2>/dev/null || echo non détecté)"
