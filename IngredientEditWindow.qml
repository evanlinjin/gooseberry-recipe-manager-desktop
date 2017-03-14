import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2
import QtQuick.Controls.Material 2.1
import Gooseberry 1.0
import "components"

Window {
    id: thisWindow
    title: (m.editMode ? "Edit Ingredient" : "New Ingredient") + " - Recipe Manager"
    width: 480; height: 620
    minimumWidth: 480; minimumHeight: 320
    flags: Qt.Dialog; modality: Qt.WindowModal



    Page {
        id: page
        anchors.fill: parent

        header: ToolBar {
            Material.elevation: 0

            RowLayout {
                anchors.fill: parent
                spacing: 0

                IconToolButton {
                    iconName: "close"
                    ToolTip.text: "Cancel"
                    onClicked: thisWindow.close()
                }

                HeaderLabel {
                    text: m.name
                }

                IconToolButton {
                    iconName: "delete"
                    ToolTip.text: "Delete Ingredient"
                    onClicked: thisWindow.close()
                    enabled: m.ready
                }

                IconToolButton {
                    iconName: "revert"
                    ToolTip.text: "Revert Changes"
                    onClicked: m.revertChanges()
                    enabled: m.ready
                }

                IconToolButton {
                    iconName: "save"
                    ToolTip.text: "Save Changes"
                    onClicked: {m.submitChanges(); thisWindow.close()}
                    enabled: m.ready
                }
            }
        }

        Flickable {
            anchors.fill: parent
            clip: true
            contentHeight: layoutFields.height + layoutFields.spacing*2
            ScrollBar.vertical: ScrollBar {}

            GridLayout {
                id: layoutFields
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.margins: spacing
                property int spacing: 20
                property int maxWidth: 1024
                property int maxWidth1: 670
                property int maxWidth2: rows === 2 ? maxWidth*2/6 : maxWidth1
                property int switchWidth: 210
                width: (parent.width < maxWidth ? (parent.width < maxWidth1 ? parent.width : (rows == 2 ? parent.width : maxWidth1 ) ) : maxWidth) - spacing*2
                rows: parent.width > maxWidth - switchWidth ? 2 : -1
                columnSpacing: spacing
                rowSpacing: spacing

                flow: GridLayout.TopToBottom

                GroupBox {
                    id: nameGroup
                    title: "Name & Description"
                    Layout.fillWidth: true
                    Layout.maximumWidth: parent.maxWidth1
                    Layout.minimumHeight: conversionGroup.height

                    ColumnLayout {
                        anchors.fill: parent

                        TextField {
                            id: name_input
                            placeholderText: "Name"
                            Layout.fillWidth: true
                            enabled: m.ready && !m.editMode
                        }

                        TextArea {
                            id: desc_input
                            placeholderText: "Enter description"
                            Layout.fillWidth: true
                            wrapMode: TextArea.Wrap
                            enabled: m.ready
                        }
                    }
                }

                GroupBox {
                    title: "Tags"
                    Layout.fillWidth: true
                    Layout.maximumWidth: parent.maxWidth1

                    ColumnLayout {
                        anchors.fill: parent

                        Item {
                            height: 2.5
                            Layout.fillWidth: true
                        }

                        ListView {
                            id: tagsView
                            Layout.fillWidth: true
                            height: contentHeight
                            width: parent.width
                            contentHeight: 40
                            spacing: 10
                            orientation: ListView.Horizontal
                            clip: true
                            model: m.tags
                            delegate: TagItem {
                                text: modelData
                                xButton.onClicked: m.removeTag(modelData)
                                enabled: m.ready
                            }
                            ScrollBar.horizontal: ScrollBar {}
                        }

                        RowLayout {
                            Layout.fillWidth: true

                            TextField {
                                id: addTagField
                                placeholderText: "Add tag..."
                                Layout.fillWidth: true
                                onAccepted: {m.addTag(text); clear()}
                                enabled: m.ready
                            }

                            IconToolButton {
                                id: addButton
                                iconName: "add"
                                ToolTip.text: "Add tag"
                                onClicked: {m.addTag(addTagField.text); addTagField.clear()}
                                enabled: m.ready
                            }
                        }
                    }
                }

                GroupBox {
                    id: conversionGroup
                    title: "Weight / Volume Conversion"
                    Layout.fillWidth: true
                    Layout.maximumWidth: parent.maxWidth2

                    ColumnLayout {
                        anchors.fill: parent
                        Frame {
                            Layout.fillWidth: true
                            Label {
                                anchors.fill: parent
                                text: ("<b>Current:</b> %1 Kg/Cup").arg(m.kgPCup)
                            }
                        }

                        GridLayout {
                            columns: 4
                            rowSpacing: 0
                            Layout.fillWidth: true

                            DoubleTextField {
                                id: weight_value_input
                                placeholderText: "Weight"
                                Layout.fillWidth: true
                                enabled: m.ready
                            }
                            Label {
                                text: "<h1>  =  </h1>"
                                Layout.minimumWidth: 30
                                horizontalAlignment: Label.AlignHCenter
                                Layout.rowSpan: 2
                            }
                            DoubleTextField {
                                id: volume_value_input
                                placeholderText: "Volume"
                                Layout.fillWidth: true
                                enabled: m.ready
                            }
                            IconToolButton {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                Layout.rowSpan: 2
                                iconName: "refresh"
                                ToolTip.text: "Change conversion"
                                enabled: parseFloat(weight_value_input.text) >= 0 &&
                                         parseFloat(volume_value_input.text) >= 0 &&
                                         m.ready
                                onClicked: {
                                    m.changeConversion(
                                                weight_value_input.text,
                                                weight_unit_input.currentIndex,
                                                volume_value_input.text,
                                                volume_unit_input.currentIndex)
                                    weight_value_input.clear()
                                    volume_value_input.clear()
                                }
                            }
                            ComboBox {
                                id: weight_unit_input
                                Layout.fillWidth: true
                                textRole: "symbol"
                                displayText: currentIndex === -1 ? "" : model[currentIndex].symbol
                                model: m.weights
                                Material.elevation: 0
                                enabled: m.ready
                            }
                            ComboBox {
                                id: volume_unit_input
                                Layout.fillWidth: true
                                textRole: "symbol"
                                displayText: currentIndex === -1 ? "" : model[currentIndex].symbol
                                model: m.volumes
                                Material.elevation: 0
                                enabled: m.ready
                            }
                        }
                    }
                }
            }
        }
    }

    function open(name) {
        m.linkUp(name, NetworkManager, MeasurementsModel, IngredientsModel)

        if (thisWindow.visible === true) {
            thisWindow.raise()
        }
        thisWindow.show()
    }

    onClosing: thisWindow.destroy()

    IngredientEditWindowModel {
        id: m
        name: name_input.text
        desc: desc_input.text

        onQmlUpdateNeeded: {
            name_input.text = name
            name = Qt.binding(function() {return name_input.text})

            desc_input.text = desc
            desc = Qt.binding(function() {return desc_input.text})
        }
    }
}
