#!/bin/bash

# Remove links installed by this repo. Shared Hyprland loader configuration is
# deliberately retained because tablet and hardware layers may still use it.

set -euo pipefail

repo=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

remove_repo_links() {
  local root link
  for root in "$HOME/.config" "$HOME/.local/bin"; do
    [[ -e $root ]] || continue
    while IFS= read -r -d '' link; do
      if [[ $(readlink "$link") == "$repo/"* ]]; then
        rm "$link"
        echo "Removed $link"
      fi
    done < <(find "$root" -type l -print0 2>/dev/null)
  done
}

restore_backups() {
  local backup target
  while IFS= read -r -d '' backup; do
    target=${backup%.pre-touchscreen}
    if [[ ! -e $target && ! -L $target ]]; then
      mv "$backup" "$target"
      echo "Restored $target"
    fi
  done < <(find "$HOME/.config" -type f -name '*.pre-touchscreen' -print0 2>/dev/null)
}

remove_repo_links
restore_backups
hyprctl reload >/dev/null 2>&1 || true

echo "Removed omarchy-touchscreen. Restart Spotify to return it to its default backend."

