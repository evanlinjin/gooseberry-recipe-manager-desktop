import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import "../toolbars"
import "../views"
import "../"

RoundButton {
    onClicked: {}
    ToolTip.text: ""
    property alias iconName: icon.name

    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.margins: 15
    background.opacity: 1
    width: 65
    height: 65
    z: parent.z + 10
    Icon {
        id: icon
        name: "add"
        anchors.centerIn: parent
        overlay: true
        color: Material.background
        size: 14
    }
    highlighted: true
    Material.accent: Material.Green
    ToolTip.visible: hovered
}
