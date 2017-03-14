#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQuickControls2/QQuickStyle>
#include <QFont>
#include <QtQml/QQmlContext>
#include <QObject>

#include "networkmanager.h"
#include "models/measurementsmodel.h"
#include "models/ingredientsmodel.h"
#include "models/ingredienteditwindowmodel.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

//    QGuiApplication::setFont(QFont("Comic Sans MS"));
//    QQuickStyle::setStyle("Universal");

    QQmlApplicationEngine engine;
    QQmlContext* rc = engine.rootContext();

    // Create objects.
    auto nm = new NetworkManager(
                QString("https://gooseberry-recipe-manager.appspot.com/"),
                QString("b55bev238fkb34g"));

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
    rc->setContextProperty("NetworkManager", nm);
    rc->setContextProperty("MeasurementsModel", measurementsModel);
    rc->setContextProperty("IngredientsModel", ingredientsModel);

    qmlRegisterType<Measurement>("Gooseberry", 1, 0, "MeasurementItem");
    qmlRegisterType<Ingredient>("Gooseberry", 1, 0, "IngredientItem");

    qmlRegisterType<IngredientEditWindowModel>("Gooseberry", 1, 0, "IngredientEditWindowModel");

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    return app.exec();
}
