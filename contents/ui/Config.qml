import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.kquickcontrols

QQC2.Control {
    id: page
    
    property alias cfg_commands: commandList.model
    
    contentItem: ColumnLayout {
        QQC2.ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            ListView {
                id: commandList
                model: cfg_commands
                spacing: Kirigami.Units.smallSpacing
                
                delegate: RowLayout {
                    width: commandList.width
                    
                    QQC2.TextField {
                        text: modelData.name
                        placeholderText: i18n("Command name")
                        onTextEdited: {
                            var list = cfg_commands;
                            list[index].name = text;
                            cfg_commands = list;
                        }
                        Layout.fillWidth: true
                    }
                    
                    QQC2.TextField {
                        text: modelData.command
                        placeholderText: i18n("Shell command")
                        onTextEdited: {
                            var list = cfg_commands;
                            list[index].command = text;
                            cfg_commands = list;
                        }
                        Layout.fillWidth: true
                    }
                    
                    QQC2.Button {
                        icon.name: "edit-delete"
                        onClicked: {
                            var list = cfg_commands;
                            list.splice(index, 1);
                            cfg_commands = list;
                        }
                    }
                    
                    QQC2.Button {
                        icon.name: "go-up"
                        enabled: index > 0
                        onClicked: {
                            var list = cfg_commands;
                            var temp = list[index-1];
                            list[index-1] = list[index];
                            list[index] = temp;
                            cfg_commands = list;
                        }
                    }
                    
                    QQC2.Button {
                        icon.name: "go-down"
                        enabled: index < count - 1
                        onClicked: {
                            var list = cfg_commands;
                            var temp = list[index+1];
                            list[index+1] = list[index];
                            list[index] = temp;
                            cfg_commands = list;
                        }
                    }
                }
            }
        }
        
        QQC2.Button {
            text: i18n("Add Command")
            icon.name: "list-add"
            onClicked: {
                var list = cfg_commands;
                list.push({"name": "", "command": "", "icon": "utilities-terminal"});
                cfg_commands = list;
            }
        }
    }
}   