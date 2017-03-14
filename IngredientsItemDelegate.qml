import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

import "components"

ItemDelegate {
    width: parent.width

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 5
        anchors.leftMargin: 15
        anchors.rightMargin: 15
        spacing: 0

        Label {
            id: ingredientName
            text: name
            font.bold: true
            elide: Label.ElideRight
            Layout.fillWidth: true
        }
        Label {
            text: ("%1").arg(tags)
            opacity: 0.6
            font.pixelSize: ingredientName.font.pixelSize*4/5
            elide: Label.ElideRight
            Layout.fillWidth: true
        }
    }
    onClicked: openIngredientEditWindow(this, name)
    ToolTip.visible: hovered
    ToolTip.text: ("Conversion: %1 kg/cup").arg(kg_per_cup)
}
