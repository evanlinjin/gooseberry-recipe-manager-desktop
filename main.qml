import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import Gooseberry 1.0
import "pages"

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 960; height: 640
    minimumWidth: 280; minimumHeight: 280
    title: qsTr("Dash - Recipe Manager")

    // For dynamic layout >>>

    property int maxWidth: 1024

    property int leftToolbarWidth: 65
    property int leftToolbarMaxWidth: 220
    property int leftPaneMinWidth: 280
    property int rightPaneMinWidth: 400

    property bool twoPanePossible: width > leftToolbarWidth + leftPaneMinWidth + rightPaneMinWidth
    property bool rightPaneOpen: false

    property bool showLeftToolbar: twoPanePossible
    property bool showLeftPane: twoPanePossible || !rightPaneOpen
    property bool showRightPane: rightPaneOpen

    // For Selection >>>

    property string mainSelectedIngredient: ""

    GridLayout {
        id: mainGrid
        anchors.fill: parent
        columnSpacing: 0
        rowSpacing: 0
        columns: 3
        rows: 1
        Loader{
            id: toolbarLoader
            sourceComponent: leftToolbarPane
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.maximumWidth: rightPaneOpen ? leftToolbarWidth : leftToolbarMaxWidth
            Layout.minimumWidth: rightPaneOpen ? leftToolbarWidth : leftToolbarMaxWidth
            visible: showLeftToolbar
        }
        Loader{
            id: leftPaneLoader
            sourceComponent: ingredientsPane
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.maximumWidth: showRightPane ? leftPaneMinWidth : -1
            Layout.minimumWidth: leftPaneMinWidth
            visible: showLeftPane

        }
        Loader{
            id: rightPaneLoader
            Layout.fillHeight: true
            Layout.fillWidth: true
            visible: showRightPane
        }
    }

    Drawer {
        id: drawer
        width: showLeftToolbar ? 0 : (leftToolbarMaxWidth*1.2 > mainWindow.width ? mainWindow.width : leftToolbarMaxWidth*1.2)
        height: showLeftToolbar ? 0 : mainWindow.height
        Loader {
            anchors.fill: parent
            sourceComponent: showLeftToolbar ? undefined : leftToolbarPane
        }
    }

    Component {id: leftToolbarPane; LeftToolbar{} }
    Component {id: ingredientsPane; PaneIngredientsPage{} }
    Component {id: ingredientEditPane; PaneEditIngredientPage{} }
    Component {id: measurementsPane; PaneMeasurementsPage{} }

    MeasurementsModel {
        id: mainMeasurementsModel
        Component.onCompleted: linkUp(NetworkManager, "main_measurements_model")
    }

    IngredientsModel {
        id: mainIngredientsModel
        Component.onCompleted: linkUp(NetworkManager, "main_ingredients_model")
    }

    function openIngredients() {
        leftPaneLoader.sourceComponent = ingredientsPane
        closeRightPane()
    }

    function openMeasurements() {
        leftPaneLoader.sourceComponent = measurementsPane
        closeRightPane()
    }

    function openEditIngredient(name) {
        ingredientPopup.open()
        peipView.open(name)
    }

    function closeRightPane() {
        drawer.close()
        rightPaneLoader.sourceComponent = null
        rightPaneOpen = false

        // reset properties.
        mainSelectedIngredient = ""
        ingredientPopup.close()
    }

    Component.onCompleted: {
        NetworkManager.onRecieved_error.connect(printErr)
    }

    function printErr(cmd, msg) {
        console.log("[GOT ERROR FROM SERVER]\n\n\tFOR CMD:", cmd,
                    "\n\tERROR MESSAGE:\n", msg)
        console.log("[END ERROR FROM SERVER]\n")
    }

    Popup {
        id: ingredientPopup
        parent: leftPaneLoader
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: twoPanePossible ? maxWidth/2 : parent.width
        height: twoPanePossible ? (parent.height < 600 ? parent.height : 600) : parent.height
        modal: true
        padding: 0
        PaneEditIngredientPage {
            id: peipView
        }
        onClosed: mainSelectedIngredient = ""
    }
}
