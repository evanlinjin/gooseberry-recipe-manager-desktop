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
            leftButtonVisible: !showLeftToolbar
            leftButtonIcon: "contents"
            leftButtonToolTip: "Menu"
            leftButtonTrigger: function() {drawer.open()}
            headerText: "Ingredients"
            showReload: true
            reloadTrigger: mainIngredientsModel.reload
            showSearch: true
            searchTrigger: mainIngredientsModel.initiateSearchMode
        }
    }

    Component {
        id: dynamicSB
        DynamicSearchBar {
            leftButtonVisible: !showLeftToolbar
            leftButtonIcon: "contents"
            leftButtonToolTip: "Menu"
            leftButtonTrigger: function() {drawer.open()}
            searchTrigger: mainIngredientsModel.search
            closeTrigger: mainIngredientsModel.endSearchMode
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
//        z: listView.z + 10
        ToolTip.text: "Add "
        onClicked: openEditIngredient()
    }

    Separator{}
}
