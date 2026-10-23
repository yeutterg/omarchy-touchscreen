# Changes from Omarchy defaults

## Built-in display mapping and native Spotify touch — 2026-10-23

- `home/.local/bin/omarchy-touchscreen-bind` discovers the active built-in
  `eDP`, `LVDS` or `DSI` output and assigns Hyprland's touchscreen and tablet
  input categories to it. This prevents focus on an external monitor from
  redirecting taps away from the physical built-in panel.
- `home/.config/hypr/extras/40-touchscreen.lua` discovers the internal
  connector from kernel display state during every config load, so the mapping
  survives `hyprctl reload`; it reruns the mapper when a new Hyprland session
  starts. `install.sh` also applies it immediately.
- `home/.config/spotify-flags.conf` selects Spotify's native Wayland backend
  plus Wayland decorations and fractional scaling. This preserves native touch
  instead of globally translating touchscreen events to mouse clicks.
- Tablet-mode usability remains in `omarchy-tablet`; model-specific input and
  firmware behavior remains in hardware repos.
