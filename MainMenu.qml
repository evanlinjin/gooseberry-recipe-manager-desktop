import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1

ToolBar {
    height: 30
    Material.primary: Material.background
    Material.elevation: 0
    Row {
        anchors.fill: parent
        ToolButton {
            text: "File"
            height: parent.height
            onClicked: fileMenu.open()
        }
        ToolButton {
            text: "Tools"
            height: parent.height
            onClicked: toolsMenu.open()
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
            text: "New..."
        }
        MenuSeparator{}
        MenuItem {
            text: "Settings..."
        }
        MenuSeparator{}
        MenuItem {
            text: "Quit"
            onClicked: Qt.quit()
        }
    }

    Menu {
        id: toolsMenu
        y: 30
        MenuItem {
            text: "Measurements..."
            onClicked: measurementsWindow.open()
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
