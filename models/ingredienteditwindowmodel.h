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
    Q_PROPERTY(bool ready READ ready NOTIFY readyChanged)
    Q_PROPERTY(QVariant volumes READ volumes NOTIFY volumesChanged)
    Q_PROPERTY(QVariant weights READ weights NOTIFY weightsChanged)

public:
    explicit IngredientEditWindowModel(QObject *parent = 0);

    // nid is name() for this class ;)

    bool editMode() const {return m_editMode;}
    bool ready() const {return m_ready;}
    QVariant volumes() const {return m_volumes;}
    QVariant weights() const {return m_weights;}

private:
    NetworkManager *nManager;
    MeasurementsModel *mModel;
    IngredientsModel *iModel;

    bool m_editMode, m_ready;
    QVariant m_volumes, m_weights;

    QObject* getVolumesObj(int i);
    QObject* getWeightsObj(int i);
    QString get_nid();

signals:
    void editModeChanged();
    void readyChanged();
    void volumesChanged();
    void weightsChanged();

    void qmlUpdateNeeded();
    void qmlCloseWindowReq();

public slots:
    void linkUp(QString key, NetworkManager* nm, MeasurementsModel* mm, IngredientsModel *im);
    void addTag(QString v);
    void removeTag(QString v);
    void changeConversion(QString wv, int wu, QString vv, int vu);
    void revertChanges();
    void submitChanges();

private slots:
    void process_get_ingredient_of_key_reply(DSIngredient v, QString id);
    void setReady() {m_ready = true; emit readyChanged();}
    void setNotReady() {m_ready = false; emit readyChanged();}
};

#endif // INGREDIENTEDITWINDOWMODEL_H
