import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1

ToolBar {
    height: 30
    Material.primary: Material.background
    Row {
        anchors.fill: parent
        ToolButton {
            text: "File"
            height: parent.height
            onClicked: fileMenu.open()
        }
        ToolButton {
            text: "Edit"
            height: parent.height
            onClicked: editMenu.open()
        }

        ToolButton {
            text: "Help"
            height: parent.height
            onClicked: helpMenu.open()
        }
    }

    Menu {
        id: fileMenu
        y: 30
        MenuItem {
            text: "Close"
            onClicked: measurementsWindow.close()
        }
    }

    Menu {
        id: editMenu
        y: 30
        MenuItem {
            text: "Reload"
            onClicked: MeasurementsModel.reload()
        }
    }

    Menu {
        id: helpMenu
        y: 30
        MenuItem {
            text: "About..."
        }
    }
}
