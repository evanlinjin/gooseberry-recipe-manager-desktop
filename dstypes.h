#ifndef DSTYPES_H
#define DSTYPES_H

#include <QString>

#define CMD_GET_MEASUREMENTS "get_measurements"
#define CMD_GET_ALL_INGREDIENTS "get_all_ingredients"

#define STATUS_OK "OK"
#define STATUS_ERROR "ERROR"

struct DSMeasurement {
    QString name;
    double multiply;
    QString symbol;
    QString type;
};

struct DSIngredient {
    QString name;
    QString description;
    double kg_per_cup;
    QStringList tags;
};

#endif // DSTYPES_H
