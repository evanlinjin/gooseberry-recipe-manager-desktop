import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import "../components"
import "../"

Page {
    id: panePage
    height: parent.height
    width: parent.width/3 - parent.spacing
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
            height: parent.height
            width: parent.width < maxWidth ? parent.width : maxWidth
            spacing: 0
            IconToolButton {
                id: menuButton
                iconName: "contents"
                ToolTip.text: "Menu "
                enabled: !showLeftToolbar
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
        Material.accent: Material.primary
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
        //        add: Transition {
        //            NumberAnimation { properties: "x"; from: 0; duration: 220 }
        //        }
        populate: Transition {
            NumberAnimation { properties: "y"; duration: 260 }
        }
    }
}
