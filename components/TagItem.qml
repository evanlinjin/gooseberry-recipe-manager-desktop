import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import "../"

Pane {
    id: frame
    property alias text: textLabel.text
    property alias xButton: mouseArea
    property var trigger: function(x){console.log(x)}
    width: rowed.width + 15
    height: textLabel.height + 10

    Row {
        id: rowed
        spacing: 5
//        anchors.fill: parent
        anchors.centerIn: parent
        Label {
            id: textLabel
            verticalAlignment: Label.AlignVCenter
            horizontalAlignment: Label.AlignHCenter
            elide: Label.ElideRight
        }
        Icon {
            name: "close"
            size: 12
            anchors.verticalCenter: parent.verticalCenter
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                anchors.margins: -5
                enabled: frame.enabled
                onClicked: trigger(textLabel.text)
            }
            overlay: true
        }
    }
    Material.theme: Material.Dark
}
