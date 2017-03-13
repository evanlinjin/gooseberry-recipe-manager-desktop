import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

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
        RowLayout {
            spacing: 0
            anchors.fill: parent
            anchors.leftMargin: 15

            Label {
                id: titleLabel
                elide: Label.ElideRight
                font.capitalization: Font.AllUppercase
                font.bold: true
                Layout.fillWidth: true
            }

            ToolButton {
                id: addButton
                anchors.bottom: parent.bottom
                anchors.top: parent.top
                Icon {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    name: "add"
                }
                ToolTip.visible: hovered
                ToolTip.text: "New " + handleType
                onClicked: addTrigger()
            }

            ToolButton {
                id: reloadButton
                anchors.bottom: parent.bottom
                anchors.top: parent.top
                Icon {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    name: "refresh"
                }
                ToolTip.visible: hovered
                ToolTip.text: "Reload " + handleType + "s"
                onClicked: reloadTrigger()
            }

            ToolButton {
                id: searchButton
                anchors.bottom: parent.bottom
                anchors.top: parent.top
                Icon {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    name: "find"
                }
                ToolTip.visible: hovered
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
