import QtQuick 2.7
import QtQuick.Controls 2.1

ItemDelegate {
    width: parent.width
    Label {
        text: name
        font.bold: true
        elide: Label.ElideRight
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: editButton.left
        anchors.leftMargin: 20
    }

    ToolButton {
        id: editButton
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        Icon {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            name: "edit"
            opacity: editButton.hovered ? 1 : 0.1
        }

        ToolTip.visible: hovered
        ToolTip.text: "Edit entry"
        onClicked: ingredientEditWindow.open(model)
    }

    ToolTip.visible: hovered
    ToolTip.text: ("Description: %1\nTags: %2\nKg/Cup: %3").arg(description).arg(tags).arg(kg_per_cup)
}
