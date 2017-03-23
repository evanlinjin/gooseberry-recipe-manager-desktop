import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import Gooseberry 1.0
import "../components"
import "../toolbars"
import "../"

Page{
    Material.theme: Material.Dark
    header: DynamicToolBar {
        component: RowLayout {
            IconToolButton {
                id: backButton
                iconName: "back"
                ToolTip.text: "Back"
                visible: !showLeftToolbar
                onClicked: drawer.close()
            }
            Spacer { visible: !backButton.visible }
            HeaderLabel { text: "Menu" }
        }
    }

    ListView {
        anchors.fill: parent
        model: VisualItemModel {
            LeftToolbarDelegate {
                icon: "large/events"
                label: "Events"
                highlighted: leftPaneLoader.item ? leftPaneLoader.item.objectName === "__events__" : false
            }
            LeftToolbarDelegate {
                icon: "large/recipes"
                label: "Recipies"
                highlighted: leftPaneLoader.item ? leftPaneLoader.item.objectName === "__recipies__" : false
            }
            LeftToolbarDelegate {
                icon: "large/ingredients"
                label: "Ingredients"
                highlighted: leftPaneLoader.item ? leftPaneLoader.item.objectName === "__ingredients__" : false
                onClicked: openIngredients()
            }
            LeftToolbarDelegate {
                icon: "large/measurements"
                label: "Measurements"
                highlighted: leftPaneLoader.item ? leftPaneLoader.item.objectName === "__measurements__" : false
                onClicked: openMeasurements()
            }
        }
    }
}
