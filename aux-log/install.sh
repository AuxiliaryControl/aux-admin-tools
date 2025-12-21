#!/bin/bash

set -e

# Get the directory where this install script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Installation target
INSTALL_DIR="/usr/local/bin"
INSTALLED_SCRIPT="$INSTALL_DIR/aux-log_main"

echo "Installing aux-log tools..."
echo "Repository location: $SCRIPT_DIR"

# Check if we need sudo
if [ ! -w "$INSTALL_DIR" ]; then
  SUDO="sudo"
  echo "Note: sudo access required to install to $INSTALL_DIR"
else
  SUDO=""
fi

# Create the actual script with hardcoded path
echo "Creating main script with hardcoded path..."
sed "s|__INSTALL_PATH__|$SCRIPT_DIR|g" "$SCRIPT_DIR/aux-log.sh" > /tmp/aux-log_main
chmod +x /tmp/aux-log_main

# Install the main script
echo "Installing main script to $INSTALLED_SCRIPT..."
$SUDO mv /tmp/aux-log_main "$INSTALLED_SCRIPT"

# Create symlinks for each command
for cmd in log question todo; do
  echo "Creating symlink for '$cmd' command..."
  $SUDO ln -sf "$INSTALLED_SCRIPT" "$INSTALL_DIR/$cmd"
done

echo ""
echo "✓ Installation complete!"
echo ""
echo "You can now use the following commands from anywhere:"
echo "  - log \"your message\""
echo "  - question \"your question\"  (or just 'question' to answer interactively)"
echo "  - todo \"your task\"  (or just 'todo' to complete interactively)"
echo ""
echo "Data will be stored in: $SCRIPT_DIR"
echo "  - logs/"
echo "  - questions/"
echo "  - todos/"
