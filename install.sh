#!/bin/bash
set -euo pipefail
source_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
theme_dir="$HOME/.config/omarchy/themes/the-prisoner"
saver_dir="$HOME/.config/quickshell/org.omarchy.screensaver.the-prisoner"
plugin_dir="$HOME/.config/omarchy/plugins/the-prisoner-seaside"
state_dir="$HOME/.local/state/the-prisoner"

for command in omarchy quickshell python3; do
  command -v "$command" >/dev/null || { echo "Missing requirement: $command" >&2; exit 1; }
done
extras="$source_dir/extras"
[[ -s "$source_dir/backgrounds/01-the-village.png" && -s "$extras/screensaver/village-empty.png" && -s "$extras/screensaver/village-seaside.png" && -s "$extras/plugin/the-prisoner-seaside/SeasideBackground.qml" && -s "$extras/plugin/the-prisoner-seaside/village-seaside.png" ]] || {
  echo "The wallpaper assets are missing; use the complete release." >&2; exit 1;
}

mkdir -p "$state_dir" "$HOME/.local/bin"
if [[ ! -f "$state_dir/backup-path" ]]; then
  backup="$state_dir/backup-$(date +%Y%m%d-%H%M%S)"
  mkdir -p "$backup"
  # Record every directly replaced item and the active theme before installing.
  for relative in .config/omarchy/themes/the-prisoner .config/quickshell/org.omarchy.screensaver.the-prisoner .config/omarchy/plugins/the-prisoner-seaside .local/bin/omarchy-launch-screensaver .local/bin/prisoner-screensaver .local/state/omarchy/current .config/omarchy/shell.json; do
    if [[ -e "$HOME/$relative" || -L "$HOME/$relative" ]]; then
      mkdir -p "$backup/$(dirname "$relative")"
      cp -a "$HOME/$relative" "$backup/$relative"
    fi
  done
  # Theme application uses Omarchy's regular app integration. Preserve common
  # app settings as additional recovery material, without copying caches.
  for relative in .config/Code/User/settings.json .config/VSCodium/User/settings.json .config/Cursor/User/settings.json .config/ghostty/config .config/alacritty/alacritty.toml .config/kitty/kitty.conf .config/foot/foot.ini .config/tmux/tmux.conf; do
    if [[ -e "$HOME/$relative" ]]; then
      mkdir -p "$backup/$(dirname "$relative")"
      cp -a "$HOME/$relative" "$backup/$relative"
    fi
  done
  cp "$HOME/.local/state/omarchy/current/theme.name" "$state_dir/previous-theme"
  printf '%s\n' "$backup" > "$state_dir/backup-path"
fi

mkdir -p "$theme_dir" "$saver_dir" "$plugin_dir"
# The theme lives at the repository root so `omarchy theme install` also works.
# Copy only the theme files; the installed copy has no .git, so Omarchy keeps
# the hand-tuned terminal palettes and dark Neovim colors.
cp -a "$source_dir/colors.toml" "$source_dir/icons.theme" "$source_dir/preview.png" \
  "$source_dir/alacritty.toml" "$source_dir/foot.ini" "$source_dir/ghostty.conf" "$source_dir/kitty.conf" \
  "$source_dir/neovim.lua" "$source_dir/backgrounds" "$theme_dir/"
cp "$extras/screensaver/shell.qml" "$extras/screensaver/village-empty.png" "$extras/screensaver/village-seaside.png" "$saver_dir/"
cp -a "$extras/plugin/the-prisoner-seaside/." "$plugin_dir/"
install -m755 "$extras/screensaver/launch" "$HOME/.local/bin/prisoner-screensaver"
install -m755 "$extras/screensaver/omarchy-launch-screensaver" "$HOME/.local/bin/omarchy-launch-screensaver"
sha256sum "$HOME/.local/bin/prisoner-screensaver" "$HOME/.local/bin/omarchy-launch-screensaver" > "$state_dir/installed-scripts.sha256"

omarchy theme set the-prisoner
omarchy-shell -q shell rescanPlugins
omarchy plugin enable uk.co.mkultrausa.the-prisoner-seaside || true
printf '\nInstalled The Prisoner. Preview: prisoner-screensaver force\nBackup: %s\n' "$(cat "$state_dir/backup-path")"
