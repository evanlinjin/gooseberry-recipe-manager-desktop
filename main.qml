import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 960
    height: 640
    minimumWidth: 520
    minimumHeight: 280
    title: qsTr("Dash - Recipe Manager")
    header: MainMenu{}

    Row {
        anchors.fill: parent
        spacing: 0
        anchors.margins: spacing

        PanePage {
            id: eventsPane
            titleLabel: "Events"
            handleType: "Event"
        }

        PanePage {
            id: recipesPane
            titleLabel: "Recipes"
            handleType: "Recipe"
        }

        PanePage {
            id: ingredientsPane
            titleLabel: "Ingredients"
            handleType: "Ingredient"

            model: IngredientsModel
            delegate: IngredientsItemDelegate{}

            reloadTrigger: IngredientsModel.reload
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0
        Item{}
        Separator{}
        Item{}
        Separator{}
        Item{}
        Separator{}
    }

    MeasurementsWindow{id: measurementsWindow}

    Component.onCompleted: {
        MeasurementsModel.reload()
        IngredientsModel.reload()
    }

    function openIngredientEditWindow(windowParent, model) {
        Qt.createComponent("qrc:/IngredientEditWindow.qml"
                           ).createObject(windowParent).open(model)
    }
}
