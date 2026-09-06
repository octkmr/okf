#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "使い方: scripts/sync-vaults.sh [--apply]" >&2
  echo "  docs/ と各vaultの差分を出す。--apply を付けると docs/ の内容を各vaultに配る。" >&2
  echo "  対象は _templates/ と .obsidian/ だけ。ノートとTIMELINE.baseには触らない。" >&2
}

apply=0
case "${1:-}" in
  "")      ;;
  --apply) apply=1 ;;
  *)       usage; exit 1 ;;
esac

root=$(git rev-parse --show-toplevel)
cd "$root"

if [ ! -d docs ]; then
  echo "docs/ がない。配布元がないので何もできない" >&2
  exit 1
fi

excludes=(--exclude workspace.json --exclude workspace-mobile.json --exclude .DS_Store)
targets="_templates .obsidian"
found=0
changed=0

for dir in */; do
  vault=${dir%/}
  if [ "$vault" = docs ] || [ ! -d "$vault/.obsidian" ]; then
    continue
  fi
  found=1

  for t in $targets; do
    [ -d "docs/$t" ] || continue
    out=$(rsync -ricn "${excludes[@]}" "docs/$t/" "$vault/$t/")
    [ -n "$out" ] || continue
    changed=1
    if [ "$apply" -eq 1 ]; then
      rsync -rc "${excludes[@]}" "docs/$t/" "$vault/$t/"
      echo "更新: $vault/$t"
    else
      echo "== $vault/$t"
      echo "$out" | sed 's/^/   /'
    fi
  done
done

if [ "$found" -eq 0 ]; then
  echo "vaultが1つもない。scripts/new-vault.sh で作る" >&2
  exit 1
fi

if [ "$changed" -eq 0 ]; then
  echo "差分なし"
elif [ "$apply" -eq 0 ]; then
  echo
  echo "配るなら: scripts/sync-vaults.sh --apply"
fi
