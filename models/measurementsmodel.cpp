#include "measurementsmodel.h"

MeasurementsModel::MeasurementsModel(QObject *parent) :
    QAbstractListModel(parent) {
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

void MeasurementsModel::linkUp(NetworkManager* nm, QString id) {
    this->nManager = nm;
    this->nid = id;

    connect(nm, SIGNAL(recieved_measurements(QList<DSMeasurement>,QString)),
            this, SLOT(process_recieved_measurements(QList<DSMeasurement>,QString)));
}

void MeasurementsModel::reload() {
    if (nManager == nullptr) return;
    nManager->get_measurements(nid);
}

void MeasurementsModel::clear() {
    if (m_list.count() == 0) return;
    beginRemoveRows(QModelIndex(), 0, m_list.count()-1);
    m_list.clear();
    endRemoveRows();
}

QVariant MeasurementsModel::getVolumeMeasurements() {
    QList<QObject*> list;
    for (int i = 0; i < m_list.size(); i++) {
        auto v = m_list.at(i);
        if (v.type == TYPE_VOLUME) {
            auto obj = new Measurement(); obj->setM(v);
            list.append(obj);
        }
    }
    qDebug() << QVariant::fromValue(list);
    return QVariant::fromValue(list);
}

QVariant MeasurementsModel::getWeightMeasurements() {
    QList<QObject*> list;
    for (int i = 0; i < m_list.size(); i++) {
        auto v = m_list.at(i);
        if (v.type == TYPE_WEIGHT) {
            auto obj = new Measurement(); obj->setM(v);
            list.append(obj);
        }
    }
    qDebug() << QVariant::fromValue(list);
    return QVariant::fromValue(list);
}

void MeasurementsModel::process_recieved_measurements(QList<DSMeasurement> list, QString id) {
    if (id != nid) return;
    this->reloadData(list);
}

void MeasurementsModel::reloadData(QList<DSMeasurement> mList) {
    this->clear();
    beginInsertRows(QModelIndex(), 0, mList.count()-1);
    m_list = mList;
    endInsertRows();
}
