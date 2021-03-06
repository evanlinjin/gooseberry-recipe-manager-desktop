#ifndef MEASUREMENTSMODEL_H
#define MEASUREMENTSMODEL_H

#include <QObject>
#include <QAbstractListModel>
#include <QDebug>
#include <QVariant>

#include "../dstypes.h"
#include "networkmanager.h"

class MeasurementsModel : public QAbstractListModel
{
    Q_OBJECT
public:
    MeasurementsModel(QObject *parent = 0);

    enum Roles {
        nameRole = Qt::UserRole + 1,
        multiplyRole,
        symbolRole,
        typeRole
    };

    QHash<int, QByteArray> roleNames() const;
    QVariant data(const QModelIndex &index, int role) const;
    int rowCount(const QModelIndex &parent = QModelIndex()) const;

private:
    QList<DSMeasurement> m_list;
    NetworkManager* nManager;
    QString nid;

public slots:
    void linkUp(NetworkManager* nm, QString id);
    void reload();
    void clear();

    QVariant getVolumeMeasurements();
    QVariant getWeightMeasurements();

private slots:
    void process_recieved_measurements(QList<DSMeasurement> list, QString id);
    void reloadData(QList<DSMeasurement> mList);
};

#endif // MEASUREMENTSMODEL_H
