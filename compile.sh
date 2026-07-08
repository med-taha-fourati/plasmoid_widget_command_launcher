#!/bin/bash
CODENAME="org.kde.commandlauncher"
LOCAL_INSTALL_DIR="$HOME/.local/share/plasma/plasmoids/$CODENAME"
# Must match plasmashell's QML_IMPORT_PATH (see ~/.config/plasma-workspace/env/qt6-qml.sh),
# otherwise plasmashell can't find (or finds a stale copy of) the plugin.
QML_INSTALL_DIR="$HOME/.local/lib/qt6/qml/org/kde/commandlauncher"

rm -rf build
rm -rf "$LOCAL_INSTALL_DIR"
rm -rf "$QML_INSTALL_DIR"
# Also clean up the legacy install path from before KDE_INSTALL_QMLDIR was pinned.
rm -rf "$HOME/.local/lib/qml/org/kde/commandlauncher"

cmake -B build -S . -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=~/.local -DKDE_INSTALL_QMLDIR=lib/qt6/qml
cmake --build build
cmake --install build


# Manually install qmldir if it wasn't
# cp qmldir $HOME/.local/lib/qt6/qml/org/kde/commandlauncher/


echo ""
echo "Build and installation complete."
echo "The plugin library was installed to: $HOME/.local/lib/qt6/qml/org/kde/commandlauncher/"
echo ""
echo "IMPORTANT: To run the plasmoid, you likely need to update your QML_IMPORT_PATH."
echo "Run the following command before starting plasmoidviewer:"
echo ""
echo "    source env_setup.sh"
echo ""