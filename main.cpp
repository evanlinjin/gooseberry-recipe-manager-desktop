#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQuickControls2/QQuickStyle>
#include <QFont>
#include <QtQml/QQmlContext>
#include "wsclient.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

//    QGuiApplication::setFont(QFont("URW Gothic L"));
//    QQuickStyle::setStyle("Universal");

    QQmlApplicationEngine engine;
    QQmlContext* rc = engine.rootContext();

    auto wsClient = new WSClient(QUrl("ws://localhost:8080/ws"), false);
    wsClient->sendMsg(QString("Hello!"));

    // Expose objects.
    rc->setContextProperty("WSClient", wsClient);

    engine.load(QUrl(QLatin1String("qrc:/main.qml")));
    return app.exec();
}
