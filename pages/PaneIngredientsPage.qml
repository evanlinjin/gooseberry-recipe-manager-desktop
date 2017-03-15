import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import Gooseberry 1.0
import "../"

PaneGridPage {
    id: ingredientsPane
    anchors.fill: parent
    titleLabel: "Ingredients"
    handleType: "Ingredient"
    objectName: "__ingredients__"

    model: mainIngredientsModel
    delegate: ingredientDelegate

    cellWidth: 240
    cellHeight: 80

    reloadTrigger: mainIngredientsModel.reload
    addTrigger: openEditIngredient

    Component {
        id: ingredientDelegate
        IngredientsItemDelegate{
            width: ingredientsPane.cellWidth
            height: ingredientsPane.cellHeight
        }
    }
    Separator{}
}
