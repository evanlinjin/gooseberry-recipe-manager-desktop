#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQuickControls2/QQuickStyle>
#include <QFont>
#include <QtQml/QQmlContext>
#include <QObject>

#include "networkmanager.h"
#include "models/measurementsmodel.h"
#include "models/ingredientsmodel.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    QGuiApplication::setFont(QFont("URW Gothic L"));
    QQuickStyle::setStyle("Material");

    QQmlApplicationEngine engine;
    QQmlContext* rc = engine.rootContext();

    // Create objects.
    auto nm = new NetworkManager(
                QString("https://gooseberry-recipe-manager.appspot.com/"),
                QString("b55bev238fkb34g"));
//    nm->get_all_ingredients();

    auto measurementsModel = new MeasurementsModel();
    auto ingredientsModel = new IngredientsModel();

    // Signals and slots.
    QObject::connect(nm, SIGNAL(recieved_measurements(QList<DSMeasurement>)),
                     measurementsModel, SLOT(reloadData(QList<DSMeasurement>)));
    QObject::connect(measurementsModel, SIGNAL(reload()),
                     nm, SLOT(get_measurements()));

    QObject::connect(nm, SIGNAL(recieved_get_all_ingredients(QList<DSIngredient>)),
                     ingredientsModel, SLOT(reloadData(QList<DSIngredient>)));
    QObject::connect(ingredientsModel, SIGNAL(reload()),
                     nm, SLOT(get_all_ingredients()));

    // Expose objects.
    rc->setContextProperty("MeasurementsModel", measurementsModel);
    rc->setContextProperty("IngredientsModel", ingredientsModel);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    return app.exec();
}
