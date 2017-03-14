#include "ingredienteditwindowmodel.h"

IngredientEditWindowModel::IngredientEditWindowModel(QObject *parent) : Ingredient(parent)
{

}

void IngredientEditWindowModel::linkUp(NetworkManager* nm, MeasurementsModel *mm, IngredientsModel *im) {
    this->nManager = nm; this->mModel = mm; this->iModel = im;

    if (nm == nullptr || mm == nullptr || im == nullptr) {
        qDebug() << "[IngredientEditWindowModel::linkUp] recieved nullptr!?";
        return;
    }

    this->m_volumes = mm->getVolumeMeasurements(); emit volumesChanged();
    this->m_weights = mm->getWeightMeasurements(); emit weightsChanged();
}
