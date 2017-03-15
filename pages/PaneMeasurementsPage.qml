import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2
import QtQuick.Controls.Material 2.1
import "../components"
import "../"

Page {
    id: panePage
    anchors.fill: parent
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
                text: "Measurements"
            }
            IconToolButton {
                id: reloadButton
                iconName: "refresh"
                ToolTip.text: "Reload"
                onClicked: mainMeasurementsModel.reload()
            }
        }
    }

    objectName: "__measurements__"

    ToolBar {
        id: toolbar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 30
        Material.elevation: 1
        Row {
            anchors.centerIn: parent
            height: parent.height
            width: (parent.width < maxWidth ? parent.width : maxWidth) - spacing*2
            spacing: 10
            MeasurementsLabel {text: "Name"; heading: true}
            MeasurementsLabel {text: "Symbol"; heading: true}
            MeasurementsLabel {text: "Multiply"; heading: true}
            MeasurementsLabel {text: "Type"; heading: true}
        }
    }

    ListView {
        id: listView
        anchors.fill: parent
        anchors.topMargin: toolbar.height
        height: parent.height
        width: parent.width
        clip: true

        model: mainMeasurementsModel

        delegate: ItemDelegate {
            width: parent.width
            height: 40
            Row {
//                anchors.fill: parent
//                anchors.leftMargin: spacing
                anchors.centerIn: parent
//                anchors.verticalCenterOffset: toolbar.height
                height: parent.height
                width: (parent.width < maxWidth ? parent.width : maxWidth) - spacing*2
                spacing: 10
                MeasurementsLabel {text: name}
                MeasurementsLabel {text: symbol}
                MeasurementsLabel {text: multiply}
                MeasurementsLabel {text: type}
            }
        }

        ScrollBar.vertical: ScrollBar {
            parent: listView.parent
            anchors.top: listView.top
            anchors.bottom: listView.bottom
            anchors.right: listView.right
            anchors.rightMargin: -((panePage.width - listView.width)/2)
        }

        populate: Transition {
            NumberAnimation { properties: "y"; duration: 260 }
        }
    }

    RowLayout {
        anchors.centerIn: parent
        height: parent.height
        width: (parent.width < maxWidth ? parent.width : maxWidth) - spacing*2
        Item{Layout.fillWidth: true}
        Separator{anchors.right: undefined; Material.elevation: 1; Material.background: "black"; opacity: 0.1}
        Item{Layout.fillWidth: true}
        Separator{anchors.right: undefined; Material.elevation: 1; Material.background: "black"; opacity: 0.1}
        Item{Layout.fillWidth: true}
        Separator{anchors.right: undefined; Material.elevation: 1; Material.background: "black"; opacity: 0.1}
        Item{Layout.fillWidth: true}
    }
}
