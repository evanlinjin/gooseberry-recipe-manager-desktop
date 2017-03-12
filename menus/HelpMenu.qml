import Qt.labs.platform 1.0
import QtQuick 2.7

Menu {
    id: helpMenu
    title: qsTr("&Help")
    MenuItem {
        text: qsTr("About Qt...")
        role: MenuItem.AboutQtRole
    }
    MenuItem {
        text: qsTr("About Recipe Manager...")
        role: MenuItem.AboutRole
    }
}
