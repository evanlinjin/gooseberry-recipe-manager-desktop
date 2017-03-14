import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import "components"

Page {
    id: panePage
    height: parent.height
    width: parent.width/3 - parent.spacing
    property alias titleLabel: titleLabel.text
    property string handleType: ""
    property alias model: listView.model
    property alias delegate: listView.delegate

    property var addTrigger: function(){}
    property var reloadTrigger: function(){}
    property var searchTrigger: function(){}

    header: ToolBar {
        Material.elevation: 0
        RowLayout {
            spacing: 0
            anchors.fill: parent
            anchors.leftMargin: 15

            HeaderLabel {
                id: titleLabel
            }

            IconToolButton {
                id: addButton
                iconName: "add"
                ToolTip.text: "New " + handleType
                onClicked: addTrigger()
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
    ListView {
        id: listView
        anchors.fill: parent
        clip: true
        ScrollBar.vertical: ScrollBar {}
    }
}
