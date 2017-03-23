import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2
import QtQuick.Controls.Material 2.1
import Gooseberry 1.0
import "../components"
import "../toolbars"
import "../"

Page {
    id: page
    anchors.fill: parent
    enabled: m.ready

    header: DynamicToolBar {
        component: RowLayout {
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
                ToolTip.text: "Delete"
                visible: m.editMode
                onClicked: deleteDialog.open()
            }
            IconToolButton {
                iconName: "tick"
                ToolTip.text: "Done"
                enabled: m.name != ""
                onClicked: {m.submitChanges(); closeRightPane()}
            }
        }
    }

    ListView {
        id: flickable
        anchors.fill: parent
        clip: true
        ScrollBar.vertical: ScrollBar {}
        model: VisualItemModel {
            ColumnLayout {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 10
                Spacer {}
                Label {text: "Name"; font.bold: true; visible: !m.editMode}
                TitleTextField {
                    id: nameField
                    visible: !m.editMode
                    placeholderText: "Name"
                }
                Spacer {}
                Label {text: "Tags"; font.bold: true}
                Spacer {visible: tagsFlow.visible}
                Flow {
                    id: tagsFlow
                    Layout.fillWidth: true
                    spacing: 10
                    visible: m.tags.length > 0
                    Component.onCompleted: m.onTagsChanged.connect(reloadTags)
                }
                TextField {
                    id: addTagField
                    placeholderText: "Add tag..."
                    Layout.fillWidth: true
                    validator: RegExpValidator {regExp: /^[a-z ]+$/}
                    onAccepted: {m.addTag(text); clear()}
                }
            }
        }
    }

    BusyIndicator {
        anchors.centerIn: parent
        running: !m.ready
        z: flickable.z + 100
    }

    Dialog {
        id: deleteDialog
        x: (parent.width - width)/2
        y: (parent.height - height)/2
        parent: ApplicationWindow.overlay
        title: ("Delete ingredient?")
        modal: true
        Label {
            anchors.centerIn: parent
            text: "Are you sure you want to delete %1?".arg(m.name)
        }
        standardButtons: Dialog.Ok | Dialog.Cancel
        onAccepted: {m.deleteIngredient(); closeRightPane()}
    }

    IngredientEditWindowModel {
        id: m
        name: nameField.text
        onQmlUpdateNeeded: {
            nameField.text = name
            name = Qt.binding(function() {return nameField.text})
            mainSelectedIngredient = name
        }
    }

    function reloadTags() {
        for (var i = 0; i < tagsFlow.data.length; i++) {
            tagsFlow.data[i].destroy()
        }
        for (i = 0; i < m.tags.length; i++) {
            Qt.createComponent("qrc:/components/TagItem.qml").createObject( tagsFlow,
                        {text: m.tags[i], trigger: function(n) {m.removeTag(n)}})
        }
    }

    function open(name) {
        m.linkUp(name, NetworkManager, mainMeasurementsModel, mainIngredientsModel)
    }
}
