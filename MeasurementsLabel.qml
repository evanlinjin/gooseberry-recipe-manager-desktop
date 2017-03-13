import QtQuick 2.7
import QtQuick.Controls 2.1

Label {
    property bool heading: false
    elide: Label.ElideRight
    width: parent.width/4 - parent.spacing/2
    anchors.verticalCenter: parent.verticalCenter
    font.capitalization: heading ? Font.AllUppercase : Font.MixedCase
    font.bold: heading
}
