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
    measurementsModel->linkUp(nm, "main_measurements_model");

    auto ingredientsModel = new IngredientsModel();
    ingredientsModel->linkUp(nm, "main_ingredients_model");

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
