import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2
import QtQuick.Controls.Material 2.1

Window {
    id: thisWindow
    title: editMode ? "Edit Ingredient" : "Add Ingredient";
    width: 420; height: page.height
    minimumWidth: width; minimumHeight: height
    maximumWidth: width; maximumHeight: height
    flags: Qt.WindowCloseButtonHint; modality: Qt.WindowModal

    Material.theme: Material.Dark
    Material.primary: "#111111"; Material.background: "#1e1e1e"
    Material.accent: Material.Grey

    property bool editMode: true
    property string m_name: ""
    property string m_description: ""
    property var m_tags: []
    property double m_kg_per_cup: 0.0

    Page {
        id: page
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: layoutFields.height + 15

        ColumnLayout {
            id: layoutFields
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 15

            Label {
                text: "Name"
                font.pixelSize: 11
                font.bold: true
            }

            TextField {
                placeholderText: "Name"
                text: m_name
                font.capitalization: Font.AllUppercase
                font.bold: true
                Layout.fillWidth: true
                onTextChanged: m_name = text
                enabled: !editMode
            }

            Label {
                text: "Description"
                font.pixelSize: 11
                font.bold: true
            }

            Flickable {
                Layout.fillWidth: true
                height: 120
                TextArea.flickable: TextArea {
                    placeholderText: "Enter description"
                    text: m_description
                    wrapMode: TextArea.Wrap
                    onTextChanged: m_description = text
                }
                ScrollBar.vertical: ScrollBar { }
            }

            Label {
                text: "Tags"
                font.pixelSize: 11
                font.bold: true
            }

            Item {
                height: 5
                width: 5
            }

            ListView {
                id: tagsView
                Layout.fillWidth: true
                height: 30
                spacing: 10
                clip: true
                orientation: ListView.Horizontal
                ScrollBar.horizontal: ScrollBar { }

                model: m_tags
                delegate: Rectangle {
                    color: Material.primary
                    radius: 2
                    width: rowed.width + 15
                    height: rowed.height + 10
                    Row {
                        id: rowed
                        spacing: 5
                        anchors.centerIn: parent
                        Label {
                            id: textLabel
                            text: modelData
                        }
                        Icon {
                            name: "close"
                            size: parent.height
                            MouseArea {
                                anchors.fill: parent
                                onClicked: removeTag(modelData)
                            }
                        }
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true

                TextField {
                    id: addTagField
                    placeholderText: "Add tag..."
                    Layout.fillWidth: true
                    onAccepted: addTag(text)
                }

                ToolButton {
                    id: addButton
                    Icon {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        name: "add"
                    }
                    ToolTip.visible: hovered
                    ToolTip.text: "New tag"
                    onClicked: addTag(addTagField.text)
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
}
