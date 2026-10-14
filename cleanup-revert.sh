#!/usr/bin/env bash
#
# Remove the development build installed by ./test-install.sh and reset the
# Dash to Panel settings that may have been changed while testing it.
#
# Usage: ./cleanup-revert.sh

set -uo pipefail

readonly UUID='dash-to-panel@jderose9.github.com'
readonly INSTALL_DIR="${HOME}/.local/share/gnome-shell/extensions/${UUID}"
readonly SETTINGS_PATH='/org/gnome/shell/extensions/dash-to-panel/'

echo '==> Disabling the extension (if it is enabled)'
gnome-extensions disable "${UUID}" || true

echo
echo '==> Removing the locally installed development build'
if [[ -d "${INSTALL_DIR}" ]]; then
	rm -rf "${INSTALL_DIR}"
	echo "Removed ${INSTALL_DIR}"
else
	echo "Nothing to remove: ${INSTALL_DIR} does not exist"
fi

echo
echo '==> Resetting the Dash to Panel GSettings'
if command -v dconf >/dev/null 2>&1; then
	dconf reset -f "${SETTINGS_PATH}" || true
	echo "Reset ${SETTINGS_PATH}"
else
	echo 'dconf is not available, skipping the settings reset'
fi

echo
cat <<'EOF'
Next steps:

  1. Restart GNOME Shell to unload the development build:
       - X11:    press Alt+F2, type "r" and press Enter
       - Wayland: log out and log back in (Alt+F2 "r" is not available)
  2. If you want to keep using Dash to Panel, install the released version from
     the official source again and enable it:
       - extensions.gnome.org: https://extensions.gnome.org/extension/1160/dash-to-panel/
       - or your distribution's package, then
           gnome-extensions enable dash-to-panel@jderose9.github.com
EOF
