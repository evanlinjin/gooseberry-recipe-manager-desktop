import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2
import QtQuick.Controls.Material 2.1
import Gooseberry 1.0
import "components"

Window {
    id: thisWindow
    title: editMode ? "Edit Ingredient" : "Add Ingredient";
    width: 420; height: 420
    minimumWidth: 320; minimumHeight: 320
    flags: Qt.Dialog; modality: Qt.WindowModal

    property bool editMode: true
    property string m_name: ""
    property string m_description: ""
    property var m_tags: []
    property double m_kg_per_cup: 0.0

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
                    text: m_name
                }

                IconToolButton {
                    iconName: "save"
                    ToolTip.text: "Save"
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
                            placeholderText: "Name"
                            text: m_name
                            Layout.fillWidth: true
                            onTextChanged: m_name = text
                            enabled: !editMode
                        }

                        TextArea {
                            placeholderText: "Enter description"
                            text: m_description
                            Layout.fillWidth: true
                            wrapMode: TextArea.Wrap
                            onTextChanged: m_description = text
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
                            model: m_tags
                            delegate: TagItem {
                                text: modelData
                                mouseArea.onClicked: removeTag(modelData)
                            }
                            ScrollBar.horizontal: ScrollBar {}
                        }

                        RowLayout {
                            Layout.fillWidth: true

                            TextField {
                                id: addTagField
                                placeholderText: "Add tag..."
                                Layout.fillWidth: true
                                onAccepted: addTag(text)
                            }

                            IconToolButton {
                                id: addButton
                                iconName: "add"
                                ToolTip.text: "Add tag"
                                onClicked: addTag(addTagField.text)
                            }
                        }
                    }
                }

                GroupBox {
                    title: "Weight / Volume Conversion"
                    Layout.fillWidth: true

                    GridLayout {
                        anchors.fill: parent
                        columns: 3

                        Label {text: "Weight"}
                        Label {}
                        Label {text: "Volume"}

                        DoubleTextField {}
                        Label {text: "="}
                        DoubleTextField {}

                        ComboBox {
                            Layout.fillWidth: true
                            textRole: "symbol"
                            displayText: model[currentIndex].symbol
                            model: windowModel.weights
                            Material.elevation: 0
                            flat: true
                        }
                        Label {}
                        ComboBox {
                            Layout.fillWidth: true
                            textRole: "symbol"
                            displayText: model[currentIndex].symbol
                            model: windowModel.volumes
                            Material.elevation: 0
                            flat: true
                        }
                    }
                }
            }
        }
    }

    function open(model) {
        if (model === undefined) {
            thisWindow.editMode = false
            return
        }
        thisWindow.editMode = true
        m_name = model.name
        m_description = model.description
        m_tags = model.tags
        m_kg_per_cup = model.kg_per_cup

        if (thisWindow.visible === true) {
            thisWindow.raise()
        }
        thisWindow.show()
    }

    function removeTag(str) {
        for (var i = 0; i < m_tags.length; i++) {
            if (m_tags[i] === str) m_tags.splice(i, 1)
        }
        m_tags.sort()
        tagsView.model = m_tags
        tagsView.update()
        console.log("CHANGED: tags:", m_tags)
    }

    function addTag(str) {
        addTagField.clear()
        str = str.trim().toLowerCase()
        if (str === "") return
        for (var i = 0; i < m_tags.length; i++) {
            if (m_tags[i] === str) return
        }
        m_tags.push(str)
        m_tags.sort()
        tagsView.model = m_tags
        tagsView.update()
        console.log("CHANGED: tags:", m_tags)
    }

    onM_nameChanged: console.log("CHANGED: name:", m_name)
    onM_descriptionChanged: console.log("CHANGED: description:", m_description)

    onClosing: {
        thisWindow.destroy()
    }

    IngredientEditWindowModel {
        id: windowModel
        Component.onCompleted: linkUp(NetworkManager, MeasurementsModel, IngredientsModel)
    }
}
