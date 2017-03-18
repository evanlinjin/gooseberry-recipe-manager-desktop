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

QString IngredientEditWindowModel::get_nid() {
    return QString("ingredient_edit_window_model ") + name();
}

void IngredientEditWindowModel::linkUp(QString key, NetworkManager* nm, MeasurementsModel *mm, IngredientsModel *im) {
    this->setNotReady();
    this->nManager = nm; this->mModel = mm; this->iModel = im;

    if (nm == nullptr || mm == nullptr || im == nullptr) {
        qDebug() << "[IngredientEditWindowModel::linkUp] recieved nullptr!?";
        return;
    }

    this->reloadMeasurements();

    this->m_editMode = (key != QString("")); emit editModeChanged();

    foreach (auto var, connections) QObject::disconnect(var);
    connections.clear();

    connections << connect(nm, SIGNAL(recieved_get_ingredient_of_key(DSIngredient,QString)),
                           this, SLOT(process_get_ingredient_of_key_reply(DSIngredient,QString)));

    connections << connect(nm, SIGNAL(recieved_add_ingredient(DSIngredient,QString)),
                           this, SLOT(process_add_ingredient_reply(DSIngredient,QString)));

    connections << connect(nm, SIGNAL(recieved_modify_ingredient(DSIngredient,QString)),
                           this, SLOT(process_modify_ingredient_reply(DSIngredient,QString)));

    connections << connect(nm, SIGNAL(recieved_delete_ingredient(QString,QString)),
                           this, SLOT(process_delete_ingredient_reply(QString,QString)));

    nm->get_ingredient_of_key(key, get_nid());
}

void IngredientEditWindowModel::addTag(QString v) {
    v = v.trimmed().toLower();
    auto newTags = this->tags();
    for (int i = 0; i < newTags.size(); i++) {
        if (newTags.at(i) == v) return;
    }
    if (v != QString("")) newTags.append(v);
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

//void IngredientEditWindowModel::changeConversion(QString wv, int wu, QString vv, int vu) {
//    double weightValue = wv.toDouble();
//    double weightMultiply = getWeightsObj(wu)->property("multiply").toDouble();
//    double volumeValue = vv.toDouble();
//    double volumeMultiply = getVolumesObj(vu)->property("multiply").toDouble();

//    if (weightValue <= 0 || weightMultiply <= 0 || volumeValue <= 0 || volumeMultiply <= 0) {
//        qDebug() << "Invalid input...";
//        return;
//    }

//    double kgs = (weightValue * weightMultiply) / 1000;
//    double cps = (volumeValue * volumeMultiply) / 0.24;
//}

void IngredientEditWindowModel::process_get_ingredient_of_key_reply(DSIngredient v, QString id) {
    if (id != get_nid()) return;
    this->setM(v);
    emit qmlUpdateNeeded();
    this->setReady();
}

void IngredientEditWindowModel::process_add_ingredient_reply(DSIngredient v, QString id) {
    if (id != get_nid()) return;
    this->setM(v);
    this->m_editMode = (v.name != QString("")); emit editModeChanged();
    this->setReady(); emit qmlUpdateNeeded();
}

void IngredientEditWindowModel::process_modify_ingredient_reply(DSIngredient v, QString id) {
    if (id != get_nid()) return;
    this->setM(v);
    this->setReady(); emit qmlUpdateNeeded();
}

void IngredientEditWindowModel::process_delete_ingredient_reply(QString v, QString id) {
    if (id != get_nid()) return;
    DSIngredient newM; this->setM(newM);
    this->m_editMode = false; emit editModeChanged();
    this->setReady(); emit qmlUpdateNeeded();
    qDebug() << "Deleted Ingredient:" << v;
}

void IngredientEditWindowModel::reloadMeasurements() {
    this->m_volumes = mModel->getVolumeMeasurements(); emit volumesChanged();
    this->m_weights = mModel->getWeightMeasurements(); emit weightsChanged();
}

void IngredientEditWindowModel::deleteIngredient() {
    setNotReady();
    nManager->delete_ingredient(this->name(), get_nid());
}

void IngredientEditWindowModel::revertChanges() {
    setNotReady();
    nManager->get_ingredient_of_key(this->name(), get_nid());
}

void IngredientEditWindowModel::submitChanges() {
    setNotReady();
    if (editMode()) {
        nManager->modify_ingredient(this->getM(), get_nid());
    } else {
        nManager->add_ingredient(this->getM(), get_nid());
    }
}

void IngredientEditWindowModel::clear() {
    setNotReady();
    DSIngredient v;
    setM(v);
    emit qmlUpdateNeeded();
}
