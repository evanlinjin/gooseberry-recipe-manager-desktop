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
                    iconName: "back"
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
                }

                IconToolButton {
                    iconName: "revert"
                    ToolTip.text: "Revert Changes"
                    onClicked: m.revertChanges()
                }

                IconToolButton {
                    iconName: "tick"
                    ToolTip.text: "Submit Changes"
                    onClicked: thisWindow.close()
                }
            }
        }

        Flickable {
            anchors.fill: parent
            contentHeight: layoutFields.height + 40
            clip: true
            ScrollBar.vertical: ScrollBar {}

            ColumnLayout {
                id: layoutFields
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 20
                spacing: 20

                GroupBox {
                    title: "Name & Description"
                    Layout.fillWidth: true

                    ColumnLayout {
                        anchors.fill: parent

                        TextField {
                            id: name_input
                            placeholderText: "Name"
                            Layout.fillWidth: true
                            enabled: !m.editMode
                        }

                        TextArea {
                            id: desc_input
                            placeholderText: "Enter description"
                            Layout.fillWidth: true
                            wrapMode: TextArea.Wrap
                        }
                    }
                }

                GroupBox {
                    title: "Tags"
                    Layout.fillWidth: true

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
                            }

                            IconToolButton {
                                id: addButton
                                iconName: "add"
                                ToolTip.text: "Add tag"
                                onClicked: {m.addTag(addTagField.text); addTagField.clear()}
                            }
                        }
                    }
                }

                GroupBox {
                    title: "Weight / Volume Conversion"
                    Layout.fillWidth: true

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
                            }
                            IconToolButton {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                Layout.rowSpan: 2
                                iconName: "refresh"
                                ToolTip.text: "Change conversion"
                                enabled: parseFloat(weight_value_input.text) >= 0 &&
                                         parseFloat(volume_value_input.text) >= 0
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
                            }
                            ComboBox {
                                id: volume_unit_input
                                Layout.fillWidth: true
                                textRole: "symbol"
                                displayText: currentIndex === -1 ? "" : model[currentIndex].symbol
                                model: m.volumes
                                Material.elevation: 0
                            }
                        }
                    }
                }
            }
        }
    }

    function open(model) {
        m.linkUp(model.name, NetworkManager, MeasurementsModel, IngredientsModel)

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

        onEditModeChanged: console.log("editMode:", editMode)
    }

}
