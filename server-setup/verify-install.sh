#!/usr/bin/env bash
set -u

check() {
  if command -v "$1" >/dev/null 2>&1; then
    printf "OK   %-18s %s\n" "$1" "$(command -v "$1")"
  else
    printf "MISS %-18s\n" "$1"
  fi
}

for cmd in \
  git python3 ffmpeg convert blender \
  node npm \
  docker tmux \
  rg jq sqlite3 rsync tree \
  gcc g++ make cmake
do
  check "$cmd"
done

echo
docker --version 2>/dev/null || true
docker compose version 2>/dev/null || true
python3 --version 2>/dev/null || true
git --version 2>/dev/null || true
blender --version 2>/dev/null | head -1 || true
