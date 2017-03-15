import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import Gooseberry 1.0

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 960; height: 640
    minimumWidth: 280; minimumHeight: 280
    title: qsTr("Dash - Recipe Manager")
    header: MainMenu{}

    property int maxWidth: 1024

    PanePage {
        id: ingredientsPane
        anchors.fill: parent
        titleLabel: "Ingredients"
        handleType: "Ingredient"

        model: mainIngredientsModel
        delegate: ingredientDelegate

        cellWidth: 240
        cellHeight: 80

        reloadTrigger: mainIngredientsModel.reload
        addTrigger: openIngredientEditWindow

        Component {
            id: ingredientDelegate
            IngredientsItemDelegate{
                width: ingredientsPane.cellWidth
                height: ingredientsPane.cellHeight
            }
        }
    }

    MeasurementsWindow{id: measurementsWindow}

    MeasurementsModel {
        id: mainMeasurementsModel
        Component.onCompleted: linkUp(NetworkManager, "main_measurements_model")
    }

    IngredientsModel {
        id: mainIngredientsModel
        Component.onCompleted: linkUp(NetworkManager, "main_ingredients_model")
    }

    function openIngredientEditWindow(windowParent, model) {
        Qt.createComponent("qrc:/IngredientEditWindow.qml"
                           ).createObject(windowParent).open(model)
    }
}
