import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.commandlauncher 1.0

PlasmoidItem {
    id: root

    CommandModel {
        id: commandModel
    }

    fullRepresentation: Item {
        Layout.minimumWidth: row.implicitWidth
        Layout.minimumHeight: row.implicitHeight
        
        Row {
            id: row
            spacing: Kirigami.Units.smallSpacing
            
            Repeater {
                model: commandModel
                
                PlasmaComponents3.Button {
                    text: model.name
                    icon.name: model.icon
                    onClicked: commandModel.executeCommand(index)
                }
            }
        }
    }
    
    contextualActions: [
        Kirigami.Action {
            text: i18n("Configure...")
            icon.name: "configure"
            onTriggered: commandModel.configure()
        }
    ]
}