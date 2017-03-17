import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import "../components"
import "../toolbars"
import "../"

GridView {
    id: grid
    anchors.centerIn: parent
    height: parent.height
    width: Math.floor((parent.width < maxWidth ? parent.width : maxWidth)/cellWidth)*cellWidth
    clip: true
    ScrollBar.vertical: ScrollBar {
        parent: grid.parent
        anchors.top: grid.top
        anchors.bottom: grid.bottom
        anchors.right: grid.right
        anchors.rightMargin: -((grid.parent.width - grid.width)/2)
    }
//    populate: Transition {
//        NumberAnimation { properties: "opacity"; from: 0; to: 1; duration: 220 }
//    }
//    add: Transition {
//        NumberAnimation { properties: "opacity"; from: 0; to: 1; duration: 220 }
//    }
//    remove: Transition {
//        NumberAnimation { properties: "opacity"; from: 1; to: 0; duration: 220 }
//    }
}
