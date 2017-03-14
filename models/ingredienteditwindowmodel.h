#ifndef INGREDIENTEDITWINDOWMODEL_H
#define INGREDIENTEDITWINDOWMODEL_H

#include <QObject>
#include <QDebug>

#include "dstypes.h"
#include "networkmanager.h"
#include "models/measurementsmodel.h"
#include "models/ingredientsmodel.h"

class IngredientEditWindowModel : public Ingredient
{
    Q_OBJECT
    Q_PROPERTY(bool editMode READ editMode NOTIFY editModeChanged)
    Q_PROPERTY(QVariant volumes READ volumes NOTIFY volumesChanged)
    Q_PROPERTY(QVariant weights READ weights NOTIFY weightsChanged)

public:
    explicit IngredientEditWindowModel(QObject *parent = 0);

    bool editMode() const {return m_editMode;}
    QVariant volumes() const {return m_volumes;}
    QVariant weights() const {return m_weights;}

private:
    NetworkManager *nManager;
    MeasurementsModel *mModel;
    IngredientsModel *iModel;

    bool m_editMode;
    QVariant m_volumes, m_weights;

    QObject* getVolumesObj(int i);
    QObject* getWeightsObj(int i);

signals:
    void editModeChanged();
    void volumesChanged();
    void weightsChanged();
    void qmlUpdateNeeded();

public slots:
    void linkUp(QString key, NetworkManager* nm, MeasurementsModel* mm, IngredientsModel *im);
    void addTag(QString v);
    void removeTag(QString v);
    void changeConversion(QString wv, int wu, QString vv, int vu);
    void revertChanges();

private slots:
};

#endif // INGREDIENTEDITWINDOWMODEL_H
