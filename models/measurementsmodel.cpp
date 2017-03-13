#include "measurementsmodel.h"

MeasurementsModel::MeasurementsModel(QObject *parent) : QAbstractListModel(parent)
{

}

QHash<int, QByteArray> MeasurementsModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[nameRole] = "name";
    roles[multiplyRole] = "multiply";
    roles[symbolRole] = "symbol";
    roles[typeRole] = "type";
    return roles;
}

QVariant MeasurementsModel::data(const QModelIndex &index, int role) const {
    if (index.row() < 0 || index.row() >= m_list.size()) {
        return QVariant();
    }
    int i = index.row();
    switch (role) {
    case nameRole: return m_list[i].name;
    case multiplyRole: return m_list[i].multiply;
    case symbolRole: return m_list[i].symbol;
    case typeRole: return m_list[i].type;
    }
    return QVariant();
}

int MeasurementsModel::rowCount(const QModelIndex &) const {
    return m_list.size();
}

void MeasurementsModel::reloadData(QList<DSMeasurement> mList)
{
    this->clear();
    beginInsertRows(QModelIndex(), 0, mList.count()-1);
    m_list = mList;
    endInsertRows();
}

void MeasurementsModel::clear()
{
    if (m_list.count() == 0) return;
    beginRemoveRows(QModelIndex(), 0, m_list.count()-1);
    m_list.clear();
    endRemoveRows();
}
