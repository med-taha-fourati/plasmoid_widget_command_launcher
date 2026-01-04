cmake_minimum_required(VERSION 3.20)
project(commandlauncher)

set(QT_MAJOR_VERSION 6)
set(KF_MAJOR_VERSION 6)

find_package(ECM REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings NO_POLICY_SCOPE)

find_package(Qt6 REQUIRED COMPONENTS Core Qml Quick)
find_package(KF6 REQUIRED COMPONENTS Config I18n)
find_package(Plasma REQUIRED)
find_package(PlasmaQuick REQUIRED)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

qt_add_qml_module(commandlauncherplugin
    URI org.kde.commandlauncher
    VERSION 1.0
    SOURCES
        contents/code/commandmodel.cpp
        #contents/code/commandmodel.h
)

# add_library(commandlauncherplugin SHARED
#     contents/code/commandmodel.cpp
#     #contents/code/commandmodel.h
# )

target_include_directories(commandlauncherplugin PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/contents/code)

target_link_libraries(commandlauncherplugin
    PRIVATE
    Qt6::Core
    Qt6::Qml
    Qt6::Quick
    Plasma::Plasma
    Plasma::PlasmaQuick
    KF6::ConfigCore
    KF6::I18n
)

# install(TARGETS commandlauncherplugin
#     DESTINATION ${KDE_INSTALL_DATADIR}/plasma/plasmoids/org.kde.commandlauncher/contents/code
# )

install(TARGETS commandlauncherplugin
    DESTINATION ${KDE_INSTALL_QMLDIR}/org/kde/commandlauncher
)

install(DIRECTORY contents/ui
    DESTINATION ${KDE_INSTALL_DATADIR}/plasma/plasmoids/org.kde.commandlauncher/contents
)

install(FILES metadata.json
    DESTINATION ${KDE_INSTALL_DATADIR}/plasma/plasmoids/org.kde.commandlauncher
)

#install(FILES contents/code/qmldir DESTINATION ${KDE_INSTALL_DATADIR}/plasma/plasmoids/org.kde.commandlauncher/contents/code)