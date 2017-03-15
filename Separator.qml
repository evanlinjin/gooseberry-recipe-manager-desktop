import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1

Pane {
    Material.elevation: 6
    width: 1
    height: parent.height
    Layout.fillHeight: true
    Layout.maximumWidth: 1
    Layout.minimumWidth: 1
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.bottom: parent.bottom
}
