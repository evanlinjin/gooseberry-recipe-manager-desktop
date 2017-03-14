import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import "../"

ToolButton {
    property alias iconName: icon.name
    ToolTip.text: ""
    onClicked: {}

    anchors.bottom: parent.bottom
    anchors.top: parent.top
    ToolTip.visible: hovered

    Icon {
        id: icon
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }

}
