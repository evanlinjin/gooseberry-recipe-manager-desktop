import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2
import QtQuick.Controls.Material 2.1
import Gooseberry 1.0
import "../components"
import "../"

Page {
    id: page
    anchors.fill: parent
    enabled: m.ready

    BusyIndicator {
        anchors.centerIn: parent
        running: !m.ready
    }

    header: ToolBar {
        Material.elevation: 1
        RowLayout {
            anchors.centerIn: parent
            height: parent.height
            width: parent.width < maxWidth ? parent.width : maxWidth
            spacing: 0

            IconToolButton {
                iconName: twoPanePossible ? "close" : "back"
                ToolTip.text: twoPanePossible ? "Close" : "Back"
                onClicked: closeRightPane()
            }

            HeaderLabel {
                text: m.editMode ? m.name : "New Ingredient"
            }

            IconToolButton {
                iconName: "delete"
                ToolTip.text: "Delete Ingredient"
                onClicked: closeRightPane()
                enabled: m.editMode
            }

            IconToolButton {
                iconName: "revert"
                ToolTip.text: "Revert Changes"
                onClicked: m.revertChanges()
                enabled: m.editMode
            }

            IconToolButton {
                iconName: "save"
                ToolTip.text: "Save Changes"
                onClicked: {m.submitChanges()}
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
            property int maxWidth1: 670
            property int maxWidth2: rows === 2 ? maxWidth*2/6 : maxWidth1
            property int switchWidth: 210
            width: (parent.width < maxWidth ? (parent.width < maxWidth1 ? parent.width : (rows == 2 ? parent.width : maxWidth1 ) ) : maxWidth) - spacing*2
            rows: parent.width > maxWidth - switchWidth ? 2 : -1
            columnSpacing: spacing
            rowSpacing: spacing

            flow: GridLayout.TopToBottom

            Pane {
                id: nameGroup
                Layout.fillWidth: true
                Layout.maximumWidth: parent.maxWidth1
                Layout.minimumHeight: conversionGroup.height
                Material.elevation: 1

                ColumnLayout {
                    anchors.fill: parent

                    TitleTextField {
                        id: name_input
                        placeholderText: "Name"
                        enabled: !m.editMode
//                        font.bold: false
                    }

                    TextArea {
                        id: desc_input
                        placeholderText: "Enter description"
                        Layout.fillWidth: true
                        wrapMode: TextArea.Wrap
                    }
                }
            }

            Pane {
                Layout.fillWidth: true
                Layout.maximumWidth: parent.maxWidth1
                Material.elevation: 1

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
                            validator: RegExpValidator {regExp: /^[a-z]+$/}
                            onAccepted: {m.addTag(text); clear()}
                        }

                        RoundButton {
                            id: addButton
                            Icon {
                                name: "add"
                                anchors.centerIn: parent
                                overlay: true
                                color: Material.primary
                            }
                            flat: true
                            ToolTip.text: "Add tag"
                            onClicked: {m.addTag(addTagField.text); addTagField.clear()}
                        }
                    }
                }
            }

            Pane {
                id: conversionGroup
                Layout.fillWidth: true
                Layout.maximumWidth: parent.maxWidth2
                Material.elevation: 1

                ColumnLayout {
                    anchors.fill: parent
                    Pane {
                        Layout.fillWidth: true
                        Material.elevation: 1
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
                        RoundButton {
                            Layout.rowSpan: 2
                            Icon {
                                name: "foward"
                                anchors.centerIn: parent
                                overlay: true
                                color: Material.primary
                            }
                            flat: true
                            ToolTip.text: "Submit new conversion"
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
//                            flat: true
                            Material.elevation: 1
                        }
                        ComboBox {
                            id: volume_unit_input
                            Layout.fillWidth: true
                            textRole: "symbol"
                            displayText: currentIndex === -1 ? "" : model[currentIndex].symbol
                            model: m.volumes
//                            flat: true
                            Material.elevation: 1
                        }
                    }
                }
            }
        }
    }
    Separator{}

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


    function open(name) {
        m.linkUp(name, NetworkManager, mainMeasurementsModel, mainIngredientsModel)
    }
}
