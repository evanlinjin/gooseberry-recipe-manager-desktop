import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1

Rectangle {
    gradient: Gradient {
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 0.2; color: Material.foreground }
        }
    opacity: 0.1
    width: 1
    height: parent.height
    Layout.fillHeight: true
}
