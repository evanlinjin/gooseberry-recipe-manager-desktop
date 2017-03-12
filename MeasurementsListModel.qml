import QtQuick 2.7

ListModel {
    id: measurementsModel

    function reload() {
        WSClient.sendMsg("get_measurements")
    }

    function processReload(cmd, status, res) {
        if (status !== "done") {
            WSClient.sendMsg(cmd)
            return
        }
        var m = {"action": "reload", "model": measurementsModel, "res": res}
        measurementsWorker.sendMessage(m)
    }
}
