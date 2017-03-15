import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import "../"

Pane {
    id: frame
    property alias text: textLabel.text
    property alias xButton: mouseArea
    width: rowed.width + 15
    height: textLabel.height + 10
    Material.elevation: 1

    Row {
        id: rowed
        spacing: 5
        anchors.centerIn: parent
        Label {
            id: textLabel
            anchors.verticalCenter: parent.verticalCenter
        }
        Icon {
            name: "close"
            size: parent.height
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                enabled: frame.enabled
            }
            overlay: true
            color: Material.primary
        }
    }
}
