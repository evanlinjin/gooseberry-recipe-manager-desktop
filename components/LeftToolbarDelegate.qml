import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import Gooseberry 1.0
import "../components"
import "../"

ItemDelegate {
    property alias icon: icon.name
    property alias label: label.text
    width: rightPaneOpen ? leftToolbarWidth : leftToolbarMaxWidth
    Layout.fillWidth: true
    height: leftToolbarWidth
    RowLayout {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 20
        Icon{
            id: icon
            size: parent.height
        }
        HeaderLabel {
            id: label
            font.capitalization: Font.MixedCase
        }
    }
    ToolTip.visible: rightPaneOpen ? hovered : false
    ToolTip.text: label.text
}
