#!/usr/bin/env bash
set -euo pipefail

if ! command -v fzf >/dev/null 2>&1; then
  echo "fzf がない。brew install fzf などで入れる" >&2
  exit 1
fi

root=$(git rev-parse --show-toplevel)

script=$(
  cd "$root/scripts" &&
  find . -maxdepth 1 -type f -name '*.sh' -perm -u+x |
  sed 's|^\./||' |
  sort |
  fzf --prompt='script> ' --height=40% --reverse \
      --preview="sed -n '1,25p' $root/scripts/{}" \
      --preview-window=right:60%
)

if [ -z "$script" ]; then
  exit 0
fi

if [ $# -gt 0 ]; then
  args=("$@")
else
  read -r -p "引数（なければEnter）: " line
  args=()
  if [ -n "$line" ]; then
    read -r -a args <<< "$line"
  fi
fi

echo "> scripts/$script ${args[*]:-}"
exec "$root/scripts/$script" ${args[@]+"${args[@]}"}
