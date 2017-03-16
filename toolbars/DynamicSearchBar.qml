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
    property var searchTrigger: function(v){console.log("Unprocessed Query:", v)}
    property var closeTrigger: function(){}

    Material.elevation: 1
    height: 55
    Material.primary: "white"
    Material.foreground: "black"

    RowLayout {
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: parent.width < maxWidth ? 0 : spacing
        height: parent.height
        width: (parent.width < maxWidth ? parent.width : maxWidth) - spacing*2

        IconToolButton {
            id: leftButton
            iconName: "back"
            ToolTip.text: leftButtonToolTip
            visible: false
            onClicked: leftButtonTrigger()
        }

        Item {width: 5; height: 5; visible: !leftButton.visible}

        TextField {
            id: searchField
            Layout.fillHeight: true
            Layout.fillWidth: true
            placeholderText: "Search ingredients..."
            onAccepted: searchTrigger(text)
            focus: true
            activeFocusOnTab: true
            Component.onCompleted: forceActiveFocus()
        }

        IconToolButton {
            id: closeButton
            iconName: "close"
            ToolTip.text: "Close"
            onClicked: closeTrigger()
        }
    }
}
