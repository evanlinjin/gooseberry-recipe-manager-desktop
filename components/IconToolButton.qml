import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1

import "../"

ToolButton {
    property alias iconName: icon.name
    property alias iconColor: icon.color
    ToolTip.text: ""
    onClicked: {}

    anchors.bottom: parent.bottom
    anchors.top: parent.top
    ToolTip.visible: hovered

    Icon {
        id: icon
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        opacity: parent.enabled ? 1 : 0.2
        overlay: true
        color: Material.foreground
    }

}
