#!/bin/bash

# Define the local install prefix (same as in compile.sh)
INSTALL_PREFIX="$HOME/.local"

# Add the specific path where the plugin was installed
# Based on the cmake output: ~/.local/lib/qt6/qml
export QML_IMPORT_PATH="$INSTALL_PREFIX/lib/qml:$QML_IMPORT_PATH"

# Ensure XDG_DATA_DIRS includes the local share directory for the plasmoid itself
if [[ ":$XDG_DATA_DIRS:" != *":$INSTALL_PREFIX/share:"* ]]; then
    export XDG_DATA_DIRS="$INSTALL_PREFIX/share:$XDG_DATA_DIRS"
fi

echo "Environment configured."
echo "QML_IMPORT_PATH is now: $QML_IMPORT_PATH"
