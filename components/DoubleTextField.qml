import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

TextField {
    Layout.fillWidth: true
    inputMethodHints: Qt.ImhFormattedNumbersOnly
    validator: DoubleValidator{}
}
