import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.plasma.plasmoid
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.kirigami 2.20 as Kirigami
import org.kde.iconthemes as KIconThemes
import org.kde.commandlauncher 1.0

PlasmoidItem {
    id: root

    property int editIndex: -1
    property var iconPickerTarget: null

    CommandModel {
        id: commandModel
        commandsJson: Plasmoid.configuration.commands
    }

    function updateCommand(index, updater) {
        var list = [];
        try {
            list = JSON.parse(Plasmoid.configuration.commands || "[]");
        } catch (e) {
            list = [];
        }
        if (index < 0 || index >= list.length)
            return;
        updater(list[index]);
        Plasmoid.configuration.commands = JSON.stringify(list);
    }

    function removeCommand(index) {
        var list = [];
        try {
            list = JSON.parse(Plasmoid.configuration.commands || "[]");
        } catch (e) {
            list = [];
        }
        if (index < 0 || index >= list.length)
            return;
        list.splice(index, 1);
        Plasmoid.configuration.commands = JSON.stringify(list);
    }

    KIconThemes.IconDialog {
        id: iconDialog
        onIconNameChanged: iconName => {
            if (root.iconPickerTarget && iconName) {
                root.iconPickerTarget.text = iconName;
            }
        }
    }

    fullRepresentation: Item {
        Layout.minimumWidth: Math.max(column.implicitWidth, Kirigami.Units.gridUnit * 14) + 2 * Kirigami.Units.smallSpacing
        Layout.minimumHeight: column.implicitHeight + 2 * Kirigami.Units.smallSpacing

        ColumnLayout {
            id: column
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: Kirigami.Units.smallSpacing
            spacing: Kirigami.Units.smallSpacing

            RowLayout {
                Layout.fillWidth: true

                Kirigami.Heading {
                    Layout.fillWidth: true
                    level: 3
                    text: i18n("Command Launcher")
                }

                PlasmaComponents3.ToolButton {
                    id: labelModeButton
                    checkable: true
                    icon.name: "utilities-terminal"

                    QQC2.ToolTip.visible: hovered
                    QQC2.ToolTip.text: checked ? i18n("Showing commands – click to show names") : i18n("Showing names – click to show commands")
                }
            }

            Repeater {
                model: commandModel

                delegate: ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Kirigami.Units.smallSpacing

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: Kirigami.Units.smallSpacing

                        PlasmaComponents3.Button {
                            Layout.fillWidth: true
                            visible: root.editIndex !== index
                            text: labelModeButton.checked ? model.command : model.name
                            icon.name: model.icon
                            onClicked: commandModel.executeCommand(index)

                            QQC2.ToolTip.visible: model.description.length > 0 && hovered
                            QQC2.ToolTip.text: model.description
                        }

                        Item {
                            Layout.fillWidth: true
                            visible: root.editIndex === index
                            implicitHeight: 1
                        }

                        PlasmaComponents3.ToolButton {
                            icon.name: root.editIndex === index ? "dialog-cancel" : "document-edit"
                            onClicked: {
                                if (root.editIndex === index) {
                                    root.editIndex = -1;
                                } else {
                                    editNameField.text = model.name;
                                    editCommandField.text = model.command;
                                    editDescriptionField.text = model.description;
                                    editIconField.text = model.icon;
                                    editSudoField.checked = model.sudo;
                                    root.editIndex = index;
                                }
                            }

                            QQC2.ToolTip.visible: hovered
                            QQC2.ToolTip.text: root.editIndex === index ? i18n("Cancel") : i18n("Edit")
                        }

                        PlasmaComponents3.ToolButton {
                            icon.name: "edit-delete"
                            visible: root.editIndex !== index
                            onClicked: root.removeCommand(index)

                            QQC2.ToolTip.visible: hovered
                            QQC2.ToolTip.text: i18n("Delete")
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        visible: root.editIndex === index
                        spacing: Kirigami.Units.smallSpacing

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: Kirigami.Units.smallSpacing

                            PlasmaComponents3.ToolButton {
                                icon.name: editIconField.text
                                onClicked: {
                                    root.iconPickerTarget = editIconField;
                                    iconDialog.open();
                                }

                                QQC2.ToolTip.visible: hovered
                                QQC2.ToolTip.text: i18n("Choose icon")
                            }

                            QQC2.TextField {
                                id: editIconField
                                Layout.fillWidth: true
                                placeholderText: i18n("Icon name")
                            }
                        }

                        QQC2.TextField {
                            id: editNameField
                            Layout.fillWidth: true
                            placeholderText: i18n("Name")
                        }

                        QQC2.TextField {
                            id: editCommandField
                            Layout.fillWidth: true
                            placeholderText: i18n("Shell command to run")
                        }

                        QQC2.TextField {
                            id: editDescriptionField
                            Layout.fillWidth: true
                            placeholderText: i18n("Description (shown as a tooltip)")
                        }

                        QQC2.CheckBox {
                            id: editSudoField
                            text: i18n("Run as administrator")
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: Kirigami.Units.smallSpacing

                            PlasmaComponents3.Button {
                                text: i18n("Save")
                                icon.name: "dialog-ok"
                                onClicked: {
                                    root.updateCommand(index, function (entry) {
                                        entry.name = editNameField.text;
                                        entry.command = editCommandField.text;
                                        entry.description = editDescriptionField.text;
                                        entry.icon = editIconField.text;
                                        entry.sudo = editSudoField.checked;
                                    });
                                    root.editIndex = -1;
                                }
                            }

                            PlasmaComponents3.Button {
                                text: i18n("Cancel")
                                icon.name: "dialog-cancel"
                                onClicked: root.editIndex = -1
                            }
                        }
                    }
                }
            }
        }
    }
}
