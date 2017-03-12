import QtQuick 2.7
import Qt.labs.platform 1.0
import "menus"

MenuBar {

    Menu {
        id: fileMenu
        title: qsTr("File")
        MenuItem {
            text: qsTr("Close")
            shortcut: StandardKey.Close
            onTriggered: measurementsWindow.close()
        }
    }

    Menu {
        id: editMenu
        title: qsTr("&Edit")
        MenuItem {
            text: qsTr("Refresh")
            shortcut: StandardKey.Refresh
            onTriggered: {}
        }
    }

    HelpMenu{}
}
