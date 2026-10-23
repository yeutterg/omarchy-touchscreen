#!/bin/bash

# Install the generic touchscreen layer for Omarchy.
# Safe to re-run. Real files replaced by links are preserved as
# <file>.pre-touchscreen.

set -euo pipefail

repo=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

backup_path() {
  local source=$1 backup="$1.pre-touchscreen"
  if [[ -e $backup || -L $backup ]]; then
    backup="$backup.$(date +%s)"
  fi
  mv "$source" "$backup"
  echo "Moved existing $source to $backup"
}

link_tree() {
  local rel target
  while IFS= read -r -d '' rel; do
    rel=${rel#./}
    target=$HOME/$rel
    mkdir -p "$(dirname "$target")"

    if [[ -e $target && ! -L $target ]]; then
      backup_path "$target"
    fi

    ln -sfn "$repo/home/$rel" "$target"
    echo "Linked $target"
  done < <(cd "$repo/home" && find . -type f -print0)
}

ensure_hypr_extras_loader() {
  local config=$HOME/.config/hypr/hyprland.lua
  local loader='for file in io.popen("find -L ~/.config/hypr/extras -maxdepth 1 -type f -name '\''*.lua'\'' 2>/dev/null | sort"):lines() do dofile(file) end'
  [[ -f $config ]] || return 0
  grep -qF "$loader" "$config" && return 0

  local block="
-- Drop-in files from touchscreen, tablet, and hardware layers, loaded in name order.
$loader"
  if grep -q '^require("default.hypr.toggles")' "$config"; then
    BLOCK=$block awk '{ print } /^require\("default\.hypr\.toggles"\)/ { print ENVIRON["BLOCK"] }' "$config" >"$config.tmp"
    mv "$config.tmp" "$config"
  else
    printf '%s\n' "$block" >>"$config"
  fi
  echo "Added the Hyprland extras loader to $config"
}

link_tree
ensure_hypr_extras_loader

# Apply the mapping to this session too; the Hyprland start hook handles later
# logins. It is harmless when no compositor or touchscreen is present.
"$HOME/.local/bin/omarchy-touchscreen-bind" || true

hyprctl reload >/dev/null 2>&1 || true
echo "Done. Restart Spotify to move it from XWayland to native Wayland."

