#!/bin/bash
CODENAME="org.kde.commandlauncher"
LOCAL_INSTALL_DIR="$HOME/.local/share/plasma/plasmoids/$CODENAME"

rm -rf build
rm -rf "$LOCAL_INSTALL_DIR"

cmake -B build -S . -DCMAKE_BUILD_TYPE=Debug
cmake --build build
cmake --install build --prefix ~/.local