import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2
import QtQuick.Controls.Material 2.1
import QtWebSockets 1.1

Window {
    id: thisWindow
    width: 580
    height: 340
    minimumWidth: 290
    minimumHeight: 170
    title: qsTr("Measurements - Recipe Manager")
    Material.theme: Material.Dark
    Material.primary: "#111111"
    Material.background: "#1e1e1e"
    modality: Qt.ApplicationModal

    Page {
        anchors.fill: parent
        header: MeasurementsMenu{id: menu }

        ToolBar {
            id: toolbar
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 30
            Row {
                anchors.fill: parent
                anchors.leftMargin: spacing
                spacing: 10
                MeasurementsLabel {text: "Name"; font.bold: true}
                MeasurementsLabel {text: "Symbol"; font.bold: true}
                MeasurementsLabel {text: "Multiply"; font.bold: true}
                MeasurementsLabel {text: "Type"; font.bold: true}
            }
        }

        ListView {
            anchors.top: toolbar.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            clip: true

            model: measurementsModel

            delegate: ItemDelegate {
                Row {
                    anchors.fill: parent
                    anchors.leftMargin: spacing
                    spacing: 10
                    MeasurementsLabel {text: name}
                    MeasurementsLabel {text: symbol}
                    MeasurementsLabel {text: multiply}
                    MeasurementsLabel {text: type}
                }
                width: parent.width
                height: 40
            }

            ScrollBar.vertical: ScrollBar {}
        }

        RowLayout {
            anchors.fill: parent
            Item{}
            Separator{}
            Item{}
            Separator{}
            Item{}
            Separator{}
            Item{}
            Separator{}
        }
    }

    function open() {
        thisWindow.visible = true
        if (measurementsModel.count == 0) {
            measurementsModel.reload()
        }
    }

    function close() {
        thisWindow.visible = false
    }
}
