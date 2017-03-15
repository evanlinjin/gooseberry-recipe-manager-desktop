import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2
import QtQuick.Controls.Material 2.1
import Gooseberry 1.0
import "../"

Pane {
    id: frame
    property bool showFrame: false
    property alias content: loader.sourceComponent
    property alias item: loader.item
    Material.elevation: showFrame ? 1 : 0
    Layout.fillWidth: true
    Loader {
        id: loader
        anchors.fill: parent;
//        anchors.margins: showFrame ? 0 : -15
    }
}
