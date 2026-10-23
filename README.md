# Omarchy touchscreen support

The base touchscreen layer for Omarchy laptops, tablets and detachables. It
fixes desktop-app touch behavior without adding tablet-mode UI, an on-screen
keyboard, rotation controls or mobile-oriented window gestures.

## What it configures

| Area | Change |
|---|---|
| Display mapping | Maps the touchscreen and pen to the active built-in `eDP`, `LVDS` or `DSI` display instead of Hyprland's currently focused monitor. |
| Spotify | Runs Spotify through native Wayland so its Chromium runtime receives native touch events. |

The display mapping matters on multi-monitor systems: without it, a tap on the
built-in panel can be routed to whichever external monitor currently has
keyboard focus. Native Wayland is preferred to globally converting touch into
mouse events, because conversion would discard multitouch and interfere with
applications that already support touch correctly.

This repo is intentionally narrower than
[omarchy-tablet](https://github.com/yeutterg/omarchy-tablet). The tablet repo
installs this layer, then adds features for detached/mobile use. Hardware repos
such as
[omarchy-rog-flow-z13](https://github.com/yeutterg/omarchy-rog-flow-z13) can
install this layer directly for normal desktop use without inheriting the
tablet interface.

## Install

```bash
git clone https://github.com/yeutterg/omarchy-touchscreen ~/dotfiles/omarchy-touchscreen
~/dotfiles/omarchy-touchscreen/install.sh
```

The installer links the tracked `home/` files into `$HOME`, preserves replaced
regular files as `<file>.pre-touchscreen`, enables sorted Hyprland drop-ins,
and applies the display mapping to the current session. It is safe to rerun.

The mapper normally discovers the built-in display. For an unusual connector
name, run it with the desired Hyprland output:

```bash
omarchy-touchscreen-bind YOUR-OUTPUT
```

Restart Spotify after installation so it launches on native Wayland.

## Remove

```bash
~/dotfiles/omarchy-touchscreen/uninstall.sh
```

