#!/usr/bin/env bash
#
# Build this working copy of Dash to Panel and install it for the current user,
# so that the development version (including the experimental "live window
# thumbnail instead of the app icon" option) can be tested in a real session.
#
# Usage: ./test-install.sh

set -euo pipefail

readonly UUID='dash-to-panel@jderose9.github.com'
readonly INSTALL_DIR="${HOME}/.local/share/gnome-shell/extensions/${UUID}"

# Always work from the root of the repository, wherever the script is called from.
cd "$(dirname "$(readlink -f "$0")")"

echo '==> Building the extension (make)'
make

echo
echo '==> Installing the build for the current user (make install-local)'
make install-local

echo
echo "==> Installed to ${INSTALL_DIR}"
echo
cat <<'EOF'
Next steps:

  1. Restart GNOME Shell so that it picks up the new version:
       - X11:    press Alt+F2, type "r" and press Enter
       - Wayland: log out and log back in (Alt+F2 "r" is not available)
  2. Make sure the extension is enabled (the restart usually keeps it enabled):
       gnome-extensions enable dash-to-panel@jderose9.github.com
     You can also enable it from the "Extensions" application.
  3. Open the preferences and turn on "Show live window thumbnail instead of
     app icon" (Behavior > Hover) to test the new feature. It is disabled by
     default, so nothing changes for users who do not enable it.
  4. Watch the journal for errors while testing:
       journalctl -f -o cat /usr/bin/gnome-shell

To undo all of this, run ./cleanup-revert.sh
EOF
