#ifndef INGREDIENTEDITWINDOWMODEL_H
#define INGREDIENTEDITWINDOWMODEL_H

#include <QObject>
//#include <QList>
//#include <QMap>

#include "dstypes.h"
#include "networkmanager.h"
#include "models/measurementsmodel.h"
#include "models/ingredientsmodel.h"

class IngredientEditWindowModel : public Ingredient
{
    Q_OBJECT
    Q_PROPERTY(QVariant volumes READ volumes NOTIFY volumesChanged)
    Q_PROPERTY(QVariant weights READ weights NOTIFY weightsChanged)

public:
    explicit IngredientEditWindowModel(QObject *parent = 0);

    QVariant volumes() const {return m_volumes;}
    QVariant weights() const {return m_weights;}

private:
    NetworkManager *nManager;
    MeasurementsModel *mModel;
    IngredientsModel *iModel;

    QVariant m_volumes, m_weights;

signals:
    void volumesChanged();
    void weightsChanged();

public slots:
    void linkUp(NetworkManager* nm, MeasurementsModel* mm, IngredientsModel *im);
};

#endif // INGREDIENTEDITWINDOWMODEL_H
