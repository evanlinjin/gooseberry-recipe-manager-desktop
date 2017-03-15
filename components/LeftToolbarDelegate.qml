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
    width: twoPanePossible ?
               (rightPaneOpen ? leftToolbarWidth : leftToolbarMaxWidth) :
               (parent ? parent.width : 0)

    Layout.fillWidth: true
    height: leftToolbarWidth
    RowLayout {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 20
        Icon{
            id: icon
            size: parent.height
            overlay: false
        }
        HeaderLabel {
            id: label
            font.capitalization: Font.MixedCase
        }
    }
    ToolTip.visible: twoPanePossible ?
                         (rightPaneOpen ? hovered : false) :
                         (false)

    ToolTip.text: label.text
}
