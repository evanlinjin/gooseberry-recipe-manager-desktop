WorkerScript.onMessage = function(msg) {
    switch (msg.action) {
    case "reload":
        reload(msg.model, msg.res)
    }
}

function reload(model, res) {
    model.clear()
    for (var i = 0; i < res.length; i++) {
        var m = res[i]
        model.append({
                         "name": m.name,
                         "symbol": m.symbol,
                         "multiply": m.multiply,
                         "type": m.type
                     })
    }
    model.sync()
}
