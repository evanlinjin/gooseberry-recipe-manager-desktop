import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import "../components"
import "../"

ToolBar {
    id: toolBar
    property var leftButtonTrigger: function(){}
    property var searchTrigger: function(v){console.log("Unprocessed Query:", v)}

    Material.elevation: 0
    height: 55
    Material.primary: Material.background
    ColumnLayout {
        anchors.fill: parent

    RowLayout {
        Layout.maximumWidth: maxWidth
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.alignment: Layout.Center

        IconToolButton {
            id: leftButton
            iconName: "back"
            ToolTip.text: "Back"
            visible: true
            onClicked: leftButtonTrigger()
        }

        Item {width: 5; height: 5; visible: !leftButton.visible}

        TextField {
            id: searchField
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.topMargin: 10
            placeholderText: "Search ingredients"
            onAccepted: searchTrigger(text)
            focus: true
            activeFocusOnTab: true
            Component.onCompleted: forceActiveFocus()
            background: Item{anchors.fill: searchField}
        }

        IconToolButton {
            id: clearButton
            iconName: "close"
            ToolTip.text: "Clear"
            onClicked: {searchField.clear(); searchField.forceActiveFocus()}
        }
    }
}
}
