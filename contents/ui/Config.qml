import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.iconthemes as KIconThemes

QQC2.Control {
    id: page

    property string cfg_commands: "[]"
    property int iconPickerIndex: -1

    ListModel {
        id: commandsModel
    }

    function loadFromJson() {
        commandsModel.clear();
        var list = [];
        try {
            list = JSON.parse(cfg_commands || "[]");
        } catch (e) {
            list = [];
        }
        for (var i = 0; i < list.length; ++i) {
            var entry = list[i] || {};
            commandsModel.append({
                name: entry.name || "",
                command: entry.command || "",
                description: entry.description || "",
                icon: entry.icon || "utilities-terminal",
                sudo: !!entry.sudo
            });
        }
    }

    function saveToJson() {
        var list = [];
        for (var i = 0; i < commandsModel.count; ++i) {
            var item = commandsModel.get(i);
            list.push({
                name: item.name,
                command: item.command,
                description: item.description,
                icon: item.icon,
                sudo: item.sudo
            });
        }
        cfg_commands = JSON.stringify(list);
    }

    Component.onCompleted: loadFromJson()

    KIconThemes.IconDialog {
        id: iconDialog
        onIconNameChanged: iconName => {
            if (page.iconPickerIndex >= 0 && iconName) {
                commandsModel.setProperty(page.iconPickerIndex, "icon", iconName);
                saveToJson();
            }
        }
    }

    contentItem: ColumnLayout {
        QQC2.ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ListView {
                id: commandListView
                model: commandsModel
                spacing: Kirigami.Units.smallSpacing
                clip: true

                delegate: Kirigami.AbstractCard {
                    width: commandListView.width

                    contentItem: ColumnLayout {
                        RowLayout {
                            Layout.fillWidth: true

                            QQC2.Button {
                                Layout.preferredWidth: Kirigami.Units.iconSizes.medium + Kirigami.Units.smallSpacing
                                Layout.preferredHeight: Layout.preferredWidth
                                icon.name: model.icon
                                onClicked: {
                                    page.iconPickerIndex = index;
                                    iconDialog.open();
                                }
                                QQC2.ToolTip.visible: hovered
                                QQC2.ToolTip.text: i18n("Choose icon")
                            }

                            QQC2.TextField {
                                Layout.fillWidth: true
                                text: model.name
                                placeholderText: i18n("Name")
                                onTextEdited: {
                                    commandsModel.setProperty(index, "name", text);
                                    saveToJson();
                                }
                            }

                            QQC2.Button {
                                icon.name: "go-up"
                                enabled: index > 0
                                onClicked: {
                                    commandsModel.move(index, index - 1, 1);
                                    saveToJson();
                                }
                            }

                            QQC2.Button {
                                icon.name: "go-down"
                                enabled: index < commandsModel.count - 1
                                onClicked: {
                                    commandsModel.move(index, index + 1, 1);
                                    saveToJson();
                                }
                            }

                            QQC2.Button {
                                icon.name: "edit-delete"
                                onClicked: {
                                    commandsModel.remove(index);
                                    saveToJson();
                                }
                            }
                        }

                        QQC2.TextField {
                            Layout.fillWidth: true
                            text: model.command
                            placeholderText: i18n("Shell command to run")
                            onTextEdited: {
                                commandsModel.setProperty(index, "command", text);
                                saveToJson();
                            }
                        }

                        QQC2.TextField {
                            Layout.fillWidth: true
                            text: model.description
                            placeholderText: i18n("Description (shown as a tooltip)")
                            onTextEdited: {
                                commandsModel.setProperty(index, "description", text);
                                saveToJson();
                            }
                        }

                        QQC2.CheckBox {
                            text: i18n("Run as administrator")
                            checked: model.sudo
                            onToggled: {
                                commandsModel.setProperty(index, "sudo", checked);
                                saveToJson();
                            }
                        }
                    }
                }
            }
        }

        QQC2.Button {
            text: i18n("Add Command")
            icon.name: "list-add"
            onClicked: {
                commandsModel.append({
                    name: "",
                    command: "",
                    description: "",
                    icon: "utilities-terminal",
                    sudo: false
                });
                saveToJson();
            }
        }
    }
}
