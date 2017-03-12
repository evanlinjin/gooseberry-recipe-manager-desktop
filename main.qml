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
    Material.theme: Material.Dark
    Material.primary: "#111111"
    Material.background: "#1e1e1e"

    header: MainMenu{}

    Row {
        anchors.fill: parent
        spacing: 0
        anchors.margins: spacing

        PanePage {
            id: eventsPane
            titleLabel: "Events"
        }

        PanePage {
            id: recipesPane
            titleLabel: "Recipes"
        }

        PanePage {
            id: ingredientsPane
            titleLabel: "Ingredients"
        }
    }

    RowLayout {
        anchors.fill: parent
        Item{}
        Separator{}
        Item{}
        Separator{}
        Item{}
        Separator{}
    }

    MeasurementsWindow{id: measurementsWindow}
    MeasurementsListModel {id: measurementsModel}
    WorkerScript {id: measurementsWorker; source: "MeasurementsWorker.js"}

    Component.onCompleted: {
        WSClient.onMsg.connect(function(msg) {
            var obj = JSON.parse(msg)

            switch (obj.cmd) {
            case "get_measurements":
                measurementsModel.processReload(obj.cmd, obj.status, obj.res)
            }
        })
    }
}
