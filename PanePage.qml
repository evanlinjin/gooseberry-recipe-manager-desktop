import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

Page {
    id: panePage
    height: parent.height
    width: parent.width/3 - parent.spacing
    property alias titleLabel: titleLabel.text

    header: ToolBar {
        RowLayout {
            spacing: 0
            anchors.fill: parent
            anchors.leftMargin: 15

            Label {
                id: titleLabel
//                font.bold: true
                elide: Label.ElideRight
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
            }
        }
    }
    Label {
        anchors.centerIn: parent
        text: "test"
    }
}
