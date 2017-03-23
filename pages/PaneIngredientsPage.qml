import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import Gooseberry 1.0
import "../components"
import "../toolbars"
import "../views"
import "../"

Page {
    id: page
    anchors.fill: parent
    objectName: "__ingredients__"

    header: Loader {
        id: hLoader
        sourceComponent: mainIngredientsModel.searchMode ? dynamicSB : dynamicTB
    }

    Component {
        id: dynamicTB
        DynamicToolBar {
            component: RowLayout {
                IconToolButton {
                    id: menuButton
                    iconName: "contents"
                    ToolTip.text: "Menu"
                    visible: !showLeftToolbar
                    onClicked: drawer.open()
                }
                Spacer {
                    visible: !menuButton.visible
                }
                HeaderLabel {
                    text: "Ingredients"
                }
                IconToolButton {
                    iconName: "refresh"
                    ToolTip.text: "Reload"
                    onClicked: mainIngredientsModel.reload()
                }
                IconToolButton {
                    iconName: "find"
                    ToolTip.text: "Search"
                    onClicked: mainIngredientsModel.initiateSearchMode()
                }
            }
        }
    }

    Component {
        id: dynamicSB
        DynamicSearchBar {
            leftButtonTrigger: mainIngredientsModel.endSearchMode
            searchTrigger: mainIngredientsModel.search
        }
    }

    CenteringGridView {
        id: gridView
        delegate: ingredientDelegate
        model: mainIngredientsModel
        implicitWidth: 220
        cellWidth: implicitWidth*2 > page.width ? page.width : implicitWidth
        cellHeight: 80
    }

    Component {
        id: ingredientDelegate
        IngredientsItemDelegate{
            width: gridView.cellWidth
            height: gridView.cellHeight
        }
    }

    BottomRoundButton {
        iconName: "add"
        ToolTip.text: "New Ingredient"
        onClicked: openEditIngredient()
    }
}
