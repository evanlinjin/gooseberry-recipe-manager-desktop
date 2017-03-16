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

    if (nManager == nullptr) {
        qDebug() << "[IngredientsModel::linkUp] recieved nullptr!?";
        return;
    }

    connect(nm, SIGNAL(recieved_get_all_ingredients(QList<DSIngredient>,QString)),
            this, SLOT(process_recieved_ingredients(QList<DSIngredient>,QString)));

    connect(nm, SIGNAL(recieved_add_ingredient(DSIngredient,QString)),
            this, SLOT(process_recieved_ingredient(DSIngredient)));

    connect(nm, SIGNAL(recieved_get_ingredient_of_key(DSIngredient,QString)),
            this, SLOT(process_recieved_ingredient(DSIngredient)));

    connect(nm, SIGNAL(recieved_modify_ingredient(DSIngredient,QString)),
            this, SLOT(process_recieved_ingredient(DSIngredient)));

    connect(nm, SIGNAL(recieved_delete_ingredient(QString,QString)),
            this, SLOT(process_delete_ingredient(QString)));

    this->reload();
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

void IngredientsModel::process_recieved_ingredients(QList<DSIngredient> list, QString id) {
    if (id != nid) return;
    this->reloadData(list);
}

void IngredientsModel::process_recieved_ingredient(DSIngredient v) {
    for (int i = 0; i < m_list.size(); i++) {
        if (m_list.at(i).name == v.name) {
            beginRemoveRows(QModelIndex(), i, i);
            m_list.removeAt(i);
            endRemoveRows();
            beginInsertRows(QModelIndex(), i, i);
            m_list.insert(i, v);
            endInsertRows();
            return;
        }
    }
    beginInsertRows(QModelIndex(), m_list.size(), m_list.size());
    m_list.append(v);
    endInsertRows();
}

void IngredientsModel::process_delete_ingredient(QString v) {
    for (int i = 0; i < m_list.size(); i++) {
        if (m_list.at(i).name == v) {
            beginRemoveRows(QModelIndex(), i, i);
            m_list.removeAt(i);
            endRemoveRows();
            return;
        }
    }
}
