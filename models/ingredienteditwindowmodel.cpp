#include "ingredienteditwindowmodel.h"

IngredientEditWindowModel::IngredientEditWindowModel(QObject *parent) :
    Ingredient(parent), m_editMode(true), m_ready(false) {
}

QObject* IngredientEditWindowModel::getVolumesObj(int i) {
    return m_volumes.value<QList<QObject*> >().at(i);
}

QObject* IngredientEditWindowModel::getWeightsObj(int i) {
    return m_weights.value<QList<QObject*> >().at(i);
}

void IngredientEditWindowModel::linkUp(QString key, NetworkManager* nm, MeasurementsModel *mm, IngredientsModel *im) {
    this->nManager = nm; this->mModel = mm; this->iModel = im;

    if (nm == nullptr || mm == nullptr || im == nullptr) {
        qDebug() << "[IngredientEditWindowModel::linkUp] recieved nullptr!?";
        return;
    }

    this->m_volumes = mm->getVolumeMeasurements(); emit volumesChanged();
    this->m_weights = mm->getWeightMeasurements(); emit weightsChanged();

    this->m_editMode = (key != QString("")); emit editModeChanged();
    if (!m_editMode) {
        setReady();
        return;
    }

    connect(nm, SIGNAL(recieved_get_ingredient_of_key(DSIngredient)),
            this, SLOT(setM(DSIngredient)));
    connect(nm, SIGNAL(recieved_get_ingredient_of_key(DSIngredient)),
            this, SIGNAL(qmlUpdateNeeded()));
    connect(nm, SIGNAL(recieved_get_ingredient_of_key(DSIngredient)),
            this, SLOT(setReady()));

    nm->get_ingredient_of_key(key);
}

void IngredientEditWindowModel::addTag(QString v) {
    v = v.trimmed().toLower();
    auto newTags = this->tags();
    for (int i = 0; i < newTags.size(); i++) {
        if (newTags.at(i) == v) return;
    }
    newTags.append(v);
    newTags.sort();
    this->setTags(newTags);
}

void IngredientEditWindowModel::removeTag(QString v) {
    v = v.trimmed().toLower();
    auto newTags = this->tags();
    for (int i = 0; i < newTags.size(); i++) {
        if (newTags.at(i) == v) newTags.removeAt(i);
    }
    newTags.sort();
    this->setTags(newTags);
}

void IngredientEditWindowModel::changeConversion(QString wv, int wu, QString vv, int vu) {
    double weightValue = wv.toDouble();
    double weightMultiply = getWeightsObj(wu)->property("multiply").toDouble();
    double volumeValue = vv.toDouble();
    double volumeMultiply = getVolumesObj(vu)->property("multiply").toDouble();

    if (weightValue <= 0 || weightMultiply <= 0 || volumeValue <= 0 || volumeMultiply <= 0) {
        qDebug() << "Invalid input...";
        return;
    }

    double kgs = (weightValue * weightMultiply) / 1000;
    double cps = (volumeValue * volumeMultiply) / 0.24;
    setKgPCup(kgs/cps);
}

void IngredientEditWindowModel::revertChanges() {
    setNotReady();
    nManager->get_ingredient_of_key(this->name());
}

void IngredientEditWindowModel::submitChanges() {
    if (editMode()) {
        nManager->modify_ingredient(this->getM());
    } else {
        nManager->add_ingredient(this->getM());
    }
}
