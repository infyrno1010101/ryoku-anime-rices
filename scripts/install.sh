#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
rice_root="$repo_root/rices"
destination="${XDG_CONFIG_HOME:-$HOME/.config}/ryoku/rices"
selection="${1:-}"

usage() {
  printf 'Usage: %s all|<rice-slug>\n' "${0##*/}" >&2
  exit 2
}

[[ -n "$selection" ]] || usage
mkdir -p "$destination"

install_one() {
  local slug=$1 source="$rice_root/$1" target="$destination/$1"
  [[ -f "$source/rice.json" && -f "$source/wall.mp4" ]] || {
    printf 'Unknown or incomplete rice: %s\n' "$slug" >&2
    exit 1
  }
  rm -rf -- "$target.tmp"
  cp -a -- "$source" "$target.tmp"
  rm -rf -- "$target"
  mv -- "$target.tmp" "$target"
  printf 'Installed: %s\n' "$slug"
}

if [[ "$selection" == all ]]; then
  for source in "$rice_root"/*; do
    [[ -d "$source" ]] && install_one "${source##*/}"
  done
else
  install_one "$selection"
fi

printf '\nInstalled under %s\n' "$destination"
printf 'List:  ryoku-hub rice list\n'
printf 'Check: ryoku-hub rice preflight <slug>\n'
printf 'Apply: ryoku-hub rice apply <slug>\n'
