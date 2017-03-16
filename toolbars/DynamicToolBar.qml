import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import "../components"
import "../"

ToolBar {
    id: toolBar
    property alias leftButtonVisible: leftButton.visible
    property alias leftButtonIcon: leftButton.iconName
    property string leftButtonToolTip: "Back"
    property var leftButtonTrigger: function(){}

    property alias headerText: header.text

    property alias showRevert: revertButton.visible
    property var revertTrigger: function(){}

    property alias showDelete: deleteButton.visible
    property var deleteTrigger: function(){}

    property alias showReload: reloadButton.visible
    property var reloadTrigger: function(){}

    property alias showSearch: searchButton.visible
    property var searchTrigger: function(){}

    property alias showSubmit: submitButton.visible
    property var submitTrigger: function(){}

    Material.elevation: 1
    height: 55

    RowLayout {
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: parent.width < maxWidth ? 0 : spacing
        height: parent.height
        width: (parent.width < maxWidth ? parent.width : maxWidth) - spacing*2

        IconToolButton {
            id: leftButton
            iconName: ""
            ToolTip.text: leftButtonToolTip
            visible: iconName != ""
            onClicked: leftButtonTrigger()
        }

        Item {width: 5; height: 5; visible: !leftButton.visible}

        HeaderLabel {
            id: header
        }

        IconToolButton {
            id: revertButton
            iconName: "revert"
            ToolTip.text: "Revert Changes"
            onClicked: revertTrigger()
            visible: false
        }

        IconToolButton {
            id: deleteButton
            iconName: "delete"
            ToolTip.text: "Delete"
            onClicked: deleteTrigger()
            visible: false
        }

        IconToolButton {
            id: reloadButton
            iconName: "refresh"
            ToolTip.text: "Reload"
            onClicked: reloadTrigger()
            visible: false
        }

        IconToolButton {
            id: searchButton
            iconName: "find"
            ToolTip.text: "Search"
            onClicked: searchTrigger()
            visible: false
        }

        IconToolButton {
            id: submitButton
            iconName: "tick"
            ToolTip.text: "Submit"
            onClicked: submitTrigger()
            visible: false
        }
    }
}
