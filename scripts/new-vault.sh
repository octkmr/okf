#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "使い方: scripts/new-vault.sh <名前>" >&2
  echo "  docs/ をコピーして新しいvaultを作る。例: scripts/new-vault.sh work" >&2
}

if [ $# -ne 1 ]; then
  usage
  exit 1
fi

name=$1

case "$name" in
  docs)  echo "docs はコピー元なので使えない" >&2; exit 1 ;;
  .*|*/*) echo "使えない名前: $name" >&2; exit 1 ;;
esac

root=$(git rev-parse --show-toplevel)
cd "$root"

if [ ! -d docs ]; then
  echo "docs/ がない。コピー元がないので作れない" >&2
  exit 1
fi

if [ -e "$name" ]; then
  echo "$name はもうある" >&2
  exit 1
fi

cp -R docs "$name"
rm -f "$name/.obsidian/workspace.json" "$name/.obsidian/workspace-mobile.json"
find "$name" -name .DS_Store -delete
git add "$name"

echo "$name/ を作った。"
echo "1. Obsidianの Open folder as vault で $root/$name を開く"
echo "2. git commit -m \"$name vaultを追加\""
