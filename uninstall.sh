#!/bin/bash
set -euo pipefail
state_dir="$HOME/.local/state/the-prisoner"
[[ -f "$state_dir/backup-path" ]] || { echo "No installation record found."; exit 0; }
backup=$(cat "$state_dir/backup-path")
[[ -d "$backup" ]] || { echo "Backup missing: $backup" >&2; exit 1; }
if ! sha256sum --check --status "$state_dir/installed-scripts.sha256"; then
  echo "A launcher changed after installation. Preserve those edits before uninstalling." >&2
  exit 1
fi

"$HOME/.local/bin/prisoner-screensaver" --stop 2>/dev/null || true
# Archive the installed files rather than deleting them.
archive="$state_dir/removed-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$archive"
for relative in .config/omarchy/themes/the-prisoner .config/quickshell/org.omarchy.screensaver.the-prisoner .config/omarchy/plugins/the-prisoner-seaside .config/omarchy/plugins/be-seeing-you .local/bin/omarchy-launch-screensaver .local/bin/prisoner-screensaver; do
  if [[ -e "$HOME/$relative" || -L "$HOME/$relative" ]]; then
    mkdir -p "$archive/$(dirname "$relative")"
    mv "$HOME/$relative" "$archive/$relative"
  fi
  if [[ -e "$backup/$relative" || -L "$backup/$relative" ]]; then
    mkdir -p "$HOME/$(dirname "$relative")"
    cp -a "$backup/$relative" "$HOME/$relative"
  fi
done
previous=$(cat "$state_dir/previous-theme")
if [[ $(cat "$HOME/.local/state/omarchy/current/theme.name") == the-prisoner ]]; then
  omarchy theme set "$previous"
fi
mv "$state_dir/backup-path" "$archive/installation-backup-path"
printf 'Restored the previous screensaver launcher. Recovery files: %s\n' "$backup"
