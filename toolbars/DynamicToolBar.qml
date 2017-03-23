import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import "../components"
import "../"

ToolBar {
    id: toolBar

    property alias component: loader.sourceComponent

    Material.elevation: 0
    height: 55
    Material.primary: Material.background

    ColumnLayout {
        anchors.fill: parent
        Loader {
            id: loader
            Layout.maximumWidth: maxWidth
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Layout.Center
        }
    }
}
