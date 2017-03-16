import QtQuick 2.7
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.1

Item {
    width: image.width
    height: image.height

    property alias size: image.width
    property alias color: overlay.color
    property alias overlay: overlay.visible
    property string name

    Image {
        id: image
        width: 18
        height: width
        smooth: true
//        mipmap: true
        visible: true
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        fillMode: Image.PreserveAspectCrop
        source: ("qrc:/icons/%1.svg").arg(name)

        onSourceChanged: {
            overlay.source = image
        }
        enabled: parent.enabled
        opacity: enabled ? 0.9 : 0.7
    }

    ColorOverlay {
        id: overlay
        anchors.fill: image
        source: image
        color: Material.foreground
        visible: false
        enabled: parent.enabled
        opacity: enabled ? 1 : 0.3
    }

    enabled: parent.enabled
}
