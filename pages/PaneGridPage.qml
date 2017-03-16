import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import "../components"
import "../toolbars"
import "../views"
import "../"

Page {
    id: panePage
    height: parent ? parent.height : 0
    width: parent ? parent.width/3 - parent.spacing : 0
    property string handleType: ""
    property alias cellHeight: listView.cellHeight
    property alias cellWidth: listView.cellWidth
    property alias model: listView.model
    property alias delegate: listView.delegate

    property var addTrigger: function(){}

    property alias titleLabel: headerLoader.item.headerText
    property alias reloadTrigger: headerLoader.item.reloadTrigger
    property alias searchTrigger: headerLoader.item.searchTrigger

    property alias dynamicTB: headerLoader.item

    header: Loader {
        id: headerLoader
        sourceComponent: dynamicTB
    }

    Component {
        id: dynamicTB
        DynamicToolBar {
            leftButtonVisible: !showLeftToolbar
            leftButtonIcon: "contents"
            leftButtonToolTip: "Menu"
            leftButtonTrigger: function() {drawer.open()}
            showReload: true
            showSearch: true
        }
    }

    BottomRoundButton {
        iconName: "add"
        z: listView.z + 10
        ToolTip.text: "Add " + handleType
        onClicked: addTrigger()
    }


    CenteringGridView {
        id: listView
    }
}
