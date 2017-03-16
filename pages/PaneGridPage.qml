import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import "../components"
import "../toolbars"
import "../"

Page {
    id: panePage
    height: parent ? parent.height : 0
    width: parent ? parent.width/3 - parent.spacing : 0
    property alias titleLabel: dynamicTB.headerText
    property string handleType: ""
    property alias cellHeight: listView.cellHeight
    property alias cellWidth: listView.cellWidth
    property alias model: listView.model
    property alias delegate: listView.delegate

    property var addTrigger: function(){}
    property alias reloadTrigger: dynamicTB.reloadTrigger
    property alias searchTrigger: dynamicTB.searchTrigger

    header: DynamicToolBar {
        id: dynamicTB
        leftButtonVisible: !showLeftToolbar
        leftButtonIcon: "contents"
        leftButtonToolTip: "Menu"
        leftButtonTrigger: function() {drawer.open()}
        showReload: true
        showSearch: true
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
    }
}
