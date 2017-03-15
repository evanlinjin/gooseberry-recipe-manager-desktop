#include "ingredientsmodel.h"

IngredientsModel::IngredientsModel(QObject *parent) : QAbstractListModel(parent)
{

}

QHash<int, QByteArray> IngredientsModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[nameRole] = "name";
    roles[descriptionRole] = "description";
    roles[kgPerCupRole] = "kg_per_cup";
    roles[tagsRole] = "tags";
    return roles;
}

QVariant IngredientsModel::data(const QModelIndex &index, int role) const {
    if (index.row() < 0 || index.row() >= m_list.size()) {
        return QVariant();
    }
    int i = index.row();
    switch (role) {
    case nameRole: return m_list[i].name;
    case descriptionRole: return m_list[i].description;
    case kgPerCupRole: return m_list[i].kg_per_cup;
    case tagsRole: return m_list[i].tags;
    }
    return QVariant();
}

int IngredientsModel::rowCount(const QModelIndex &) const {
    return m_list.size();
}

void IngredientsModel::linkUp(NetworkManager *nm, QString id) {
    this->nManager = nm;
    this->nid = id;

    connect(nm, SIGNAL(recieved_get_all_ingredients(QList<DSIngredient>,QString)),
            this, SLOT(process_recieved_measurements(QList<DSIngredient>,QString)));
}

void IngredientsModel::reloadData(QList<DSIngredient> mList)
{
    this->clear();
    beginInsertRows(QModelIndex(), 0, mList.count()-1);
    m_list = mList;
    endInsertRows();
}

void IngredientsModel::reload() {
    if (nManager == nullptr) return;
    nManager->get_all_ingredients(nid);
}

void IngredientsModel::clear() {
    if (m_list.count() == 0) return;
    beginRemoveRows(QModelIndex(), 0, m_list.count()-1);
    m_list.clear();
    endRemoveRows();
}

void IngredientsModel::process_recieved_measurements(QList<DSIngredient> list, QString id) {
    if (id != nid) return;
    this->reloadData(list);
}
