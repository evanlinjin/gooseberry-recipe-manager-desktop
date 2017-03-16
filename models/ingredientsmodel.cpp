#include "ingredientsmodel.h"

IngredientsModel::IngredientsModel(QObject *parent) :
    QAbstractListModel(parent), m_searchMode(false) {
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

    connect(nm, SIGNAL(recieved_search_ingredients(QList<DSIngredient>,QString)),
            this, SLOT(process_recieved_searched_ingredients(QList<DSIngredient>,QString)));

    this->reload();
}

void IngredientsModel::initiateSearchMode() {
    m_searchMode = true; emit searchModeChanged();
//    this->clear();
}

void IngredientsModel::endSearchMode() {
    m_searchMode = false; emit searchModeChanged();
    this->clear();
    nManager->get_all_ingredients(nid);
}

void IngredientsModel::search(QString v) {
    this->clear();
    if (v.size() == 0) return;
    nManager->search_ingredients(v, nid);
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
    this->clear();
    nManager->get_all_ingredients(nid);
}

void IngredientsModel::clear() {
    if (m_list.count() == 0) return;
    beginRemoveRows(QModelIndex(), 0, m_list.count()-1);
    m_list.clear();
    endRemoveRows();
}

void IngredientsModel::process_recieved_ingredients(QList<DSIngredient> list, QString id) {
    if (id != nid || m_searchMode) return;
    this->reloadData(list);
}

void IngredientsModel::process_recieved_searched_ingredients(QList<DSIngredient> list, QString id) {
    qDebug() << "GOT IT! (" << list.size() << "results )";
    qDebug() << "IS SEARCH MODE?" << m_searchMode;
    qDebug() << "ID? Got:" << id << ", Expected:" << nid;
    if (id != nid || !m_searchMode) return;
    this->reloadData(list);
}

void IngredientsModel::process_recieved_ingredient(DSIngredient v) {
    if (v.name.size() == 0) return;
    int insertPos = 0;

    for (int i = 0; i < m_list.size(); i++) {
        if (v.name > m_list.at(i).name) {
            insertPos = i+1;
        }
        else if (m_list.at(i).name == v.name) {
            beginRemoveRows(QModelIndex(), i, i);
            m_list.removeAt(i);
            endRemoveRows();
            beginInsertRows(QModelIndex(), i, i);
            m_list.insert(i, v);
            endInsertRows();
            return;
        }
    }
    if (m_searchMode) return;
    beginInsertRows(QModelIndex(), insertPos, insertPos);
    m_list.insert(insertPos, v);
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
