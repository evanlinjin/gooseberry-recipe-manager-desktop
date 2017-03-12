//#include <QGuiApplication>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQuickControls2/QQuickStyle>
#include <QFont>
#include <QtQml/QQmlContext>
#include <QObject>

#include "wsclient.h"
#include "networkmanager.h"
#include "models/measurementsmodel.h"

int main(int argc, char *argv[])
{
//    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
//    QGuiApplication app(argc, argv);
    QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);

    QGuiApplication::setFont(QFont("URW Gothic L"));
    QQuickStyle::setStyle("Material");

    QQmlApplicationEngine engine;
    QQmlContext* rc = engine.rootContext();

    // Create objects.
    auto wsClient = new WSClient(QUrl("ws://localhost:8080/ws"), false);
    wsClient->sendMsg(QString("Hello!"));

    auto nm = new NetworkManager(
                QString("https://gooseberry-recipe-manager.appspot.com/"),
                QString(""));


    auto measurementsModel = new MeasurementsModel();

    // Signals and slots.
    QObject::connect(nm, SIGNAL(recieved_measurements(QList<DSMeasurement>)),
                     measurementsModel, SLOT(reload(QList<DSMeasurement>)));

    // Run.
    nm->get_measurements();

    // Expose objects.
    rc->setContextProperty("WSClient", wsClient);
    rc->setContextProperty("MeasurementsModel", measurementsModel);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    return app.exec();
}
