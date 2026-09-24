# The Prisoner — an Omarchy theme

A sunny, unofficial tribute to the original 1967 television series: cream
architecture, scarlet, golden yellow, blue, green, and Rover crossing the Village.

## Included

- A light desktop palette with darker, readable text colors drawn from the
  Village's colorful visual language. These are designed colors, not an official
  production palette or exact samples from a film restoration.
- Terminals use cream text on charcoal with bright Village accents. This keeps
  existing terminal applications with dark input/message panels readable when
  switching from a dark theme without restarting those applications.
- Original AI-generated Village wallpaper, a matching empty animation scene,
  and a seaside companion view for the compact right-hand display. The companion
  is also a user-level Omarchy plugin, so it remains visible during regular use.
- Editable Number Six and penny-farthing SVG graphics, plus transparent PNGs.
- A graphical Quickshell screensaver: a shaded white Rover crosses the virtual
  desktop, wobbles, changes direction, and makes a larger pass every third trip.
- Omarchy generates bar, launcher, editor, browser, lock and other supported app
  colors from `theme/colors.toml` using its installed templates. Four explicit
  terminal palettes cover Alacritty, Ghostty, Foot and Kitty.

## Install

Designed for the Quickshell-based Omarchy 4.0.4 installation. Requires Quickshell
and the normal Omarchy commands already supplied by that release. Older Hypridle/
Waybar Omarchy installations have not been tested. No extra fonts or packages.

```sh
./install.sh
```

Installs to your home directory and applies the theme. Backups are stored under
`~/.local/state/the-prisoner/`. No files under `/usr/share/omarchy` are changed.
Keep `~/.local/bin` ahead of `/usr/share/omarchy/bin` in the login shell PATH, as on
the tested machine. The wrapper intercepts the existing screensaver launcher only
when `the-prisoner` is selected; all other themes use the original launcher and
your existing screensaver customization.

```sh
prisoner-screensaver force       # Start now; move the mouse or press a key to exit
prisoner-screensaver --stop      # Stop only the Rover screensaver
./uninstall.sh                  # Restore the previous launcher and theme
```

The installer leaves the configured screensaver and lock deadlines unchanged.
This is a decorative screensaver, not a lock screen. It uses Omarchy's existing
`org.omarchy.screensaver` window identity so idle tracking continues to recognize
its windows; the existing system-lock command terminates it when locking.

## Design and sources

The Village film stills informed the architecture and strong umbrella colors:

- [Portmeirion's Prisoner shop](https://www.portmeiriononline.co.uk/the-prisoner/c140)
- [Village scene in Outcast's article](https://www.outcast.it/home/il-prigioniero-capolavoro-post-moderno)
- [BFI on the original series](https://www.bfi.org.uk/features/prisoner-patrick-mcgoohan-50)

Reference stills, television footage, dialogue recordings, music, and proprietary
typefaces are not included. The wallpaper is an illustration, not a precise
reconstruction of Portmeirion. Graphics are unofficial interpretations. This
project is not affiliated with the programme's rights holders or Portmeirion.

The wallpaper prompts are in `ASSET-PROMPTS.md`. Art was generated with the
built-in image generation tool; the badge, bicycle and animation are editable
code/vector artwork. The unused concept is retained locally under `concepts/`
and is excluded from the release archive.

## Customization

- Palette: `theme/colors.toml`
- Terminal palettes: `theme/alacritty.toml`, `ghostty.conf`, `foot.ini`, `kitty.conf`
- Desktop background: `theme/backgrounds/`
- Compact right display background: `plugin/the-prisoner-seaside/` renders
  `village-seaside.png` permanently on the `DP-3` output; the screensaver uses
  its matching copy in `screensaver/village-seaside.png`.
- Rover motion, scale, and rendering: `screensaver/shell.qml`
- A pass takes 34 seconds. Rover is 29% of desktop height normally and 67% on
  close passes. Frames update at approximately 30 fps.
- The screensaver spans the virtual desktop using monitor coordinates. Disconnected
  outputs and unusual monitor arrangements should be checked before publishing a
  general release. Empty gaps between displays are traversed as physical gaps.

## Verification on the original machine

- Installed and activated on Omarchy 4.0.4-1.
- Two fullscreen windows verified: DP-1 at 1920×1080 and DP-3 at 1024×600,
  with DP-3 offset to desktop position 1920,480.
- A 38-second live pass confirmed Rover appears on the right-hand display.
  `preview/rover-DP-3.png` is the captured animation frame.
- Theme colors parsed; generated configurations had no unresolved placeholders;
  Hyprland reported no configuration errors.
- Main text, accent and regular terminal colors have at least 4.5:1 contrast
  against the cream background. Existing idle configuration was byte-for-byte
  unchanged (30-minute screensaver, two-hour lock on this machine).
- Lock compatibility was checked against Omarchy's installed idle and lock code.
  The two-hour automatic-lock deadline was not waited out during development.
- QML loaded and rendered successfully. Qt emits a non-fatal portal app-ID
  registration warning in this session; QML lint also reports an upstream
  QProcess ExitStatus type-metadata warning at the process exit callback.

Re-run the installer after editing the source. Installation does not publish or
upload anything. The original Matrix screensaver script remains untouched.
