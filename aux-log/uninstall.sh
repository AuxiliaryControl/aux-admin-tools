#!/bin/bash

set -e

INSTALL_DIR="/usr/local/bin"

echo "Uninstalling aux-log tools..."

# Check if we need sudo
if [ ! -w "$INSTALL_DIR" ]; then
  SUDO="sudo"
  echo "Note: sudo access required to uninstall from $INSTALL_DIR"
else
  SUDO=""
fi

# Remove symlinks
for cmd in log question todo; do
  if [ -L "$INSTALL_DIR/$cmd" ]; then
    echo "Removing '$cmd' command..."
    $SUDO rm "$INSTALL_DIR/$cmd"
  fi
done

# Remove main script
if [ -f "$INSTALL_DIR/aux-log_main" ]; then
  echo "Removing main script..."
  $SUDO rm "$INSTALL_DIR/aux-log_main"
fi

echo ""
echo "✓ Uninstall complete!"
echo ""
echo "Note: Your data in logs/, questions/, and todos/ has NOT been deleted."
