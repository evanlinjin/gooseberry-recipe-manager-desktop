import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1

import "components"

Item {
    id: item
    property int spacing: 10
    width: 360
    height: 360

    Pane {
        id: frame
        anchors.centerIn: parent
        anchors.verticalCenterOffset: item.spacing/2
        width: parent.width - item.spacing*2
        height: parent.height - item.spacing*2
        Material.theme: Material.Dark
        Material.elevation: 0//ingredientsPane.implicitWidth*2 > ingredientsPane.width ? 0 : 1

        ItemDelegate {
            id: delegate
            anchors.fill: parent
            anchors.margins: -item.spacing
            onClicked: openEditIngredient(name)
            highlighted: name === mainSelectedIngredient

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: item.spacing
                Label {
                    id: ingredientName
                    text: name
                    font.bold: true
                    elide: Label.ElideRight
                    Layout.fillWidth: true
                }
                Label {
                    text: tags.join(", ")
                    opacity: 0.6
                    font.pixelSize: ingredientName.font.pixelSize*4/5
                    font.italic: true
                    elide: Label.ElideRight
                    Layout.fillWidth: true
                }
            }
        }
    }
}
