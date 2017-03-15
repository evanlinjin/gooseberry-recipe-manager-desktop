import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import "../components"
import "../"

Page {
    id: panePage
    height: parent ? parent.height : 0
    width: parent ? parent.width/3 - parent.spacing : 0
    property alias titleLabel: titleLabel.text
    property string handleType: ""
    property alias cellHeight: listView.cellHeight
    property alias cellWidth: listView.cellWidth
    property alias model: listView.model
    property alias delegate: listView.delegate

    property var addTrigger: function(){}
    property var reloadTrigger: function(){}
    property var searchTrigger: function(){}

    header: ToolBar {
        Material.elevation: 1
        RowLayout {
            anchors.centerIn: parent
//            anchors.horizontalCenterOffset: parent.width < maxWidth ? spacing
            height: parent.height
            width: (parent.width < maxWidth ? parent.width : maxWidth) - spacing*2

            IconToolButton {
                id: menuButton
                iconName: "contents"
                ToolTip.text: "Menu "
                visible: !showLeftToolbar
                onClicked: drawer.open()
            }
            HeaderLabel {
                id: titleLabel
            }
            IconToolButton {
                id: reloadButton
                iconName: "refresh"
                ToolTip.text: "Reload " + handleType + "s"
                onClicked: reloadTrigger()
            }
            IconToolButton {
                id: searchButton
                iconName: "find"
                ToolTip.text: "Search " + handleType + "s"
                onClicked: searchTrigger()
            }
        }
    }
    RoundButton {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 30
        background.opacity: 1
        width: 60
        height: 60
        z: listView.z + 10
        Icon {
            name: "add"
            anchors.centerIn: parent
            overlay: true
            color: Material.background
        }
        highlighted: true
        Material.accent: Material.Green
        ToolTip.text: "Add " + handleType
        ToolTip.visible: hovered
        onClicked: addTrigger()
    }


    GridView {
        id: listView
        anchors.centerIn: parent
        height: parent.height
        width:  Math.floor((parent.width < maxWidth ? parent.width : maxWidth)/cellWidth)*cellWidth
        clip: true
        onContentWidthChanged: console.log(contentWidth)
        ScrollBar.vertical: ScrollBar {
            parent: listView.parent
            anchors.top: listView.top
            anchors.bottom: listView.bottom
            anchors.right: listView.right
            anchors.rightMargin: -((panePage.width - listView.width)/2)
        }
        populate: Transition {
            NumberAnimation { properties: "opacity"; from: 0; to: 1; duration: 220 }
        }
        add: Transition {
            NumberAnimation { properties: "opacity"; from: 0; to: 1; duration: 220 }
        }
//        rows: 2
    }
}
