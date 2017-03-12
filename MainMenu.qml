import QtQuick 2.7
import Qt.labs.platform 1.0
import "menus"

MenuBar {

    Menu {
        id: fileMenu
        title: qsTr("File")
        Menu {
            title: qsTr("New")
            MenuItem {text: qsTr("Event...")}
            MenuItem {text: qsTr("Recipe...")}
            MenuItem {text: qsTr("Ingredient...")}
        }
        MenuItem {separator: true}
        MenuItem {
            text: qsTr("Quit")
            onTriggered: Qt.quit()
            shortcut: StandardKey.Quit
            role: MenuItem.QuitRole
        }
    }

    Menu {
        id: toolsMenu
        title: qsTr("&Tools")
        MenuItem {
            text: qsTr("Measurements...")
            onTriggered: measurementsWindow.open()
            shortcut: StandardKey.Preferences
            role: MenuItem.ApplicationSpecificRole
        }
        MenuItem {separator: true}
        MenuItem {
            text: qsTr("Settings...")
            shortcut: StandardKey.Preferences
            role: MenuItem.PreferencesRole
        }
    }

    HelpMenu{}
}
