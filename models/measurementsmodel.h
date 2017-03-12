#ifndef MEASUREMENTSMODEL_H
#define MEASUREMENTSMODEL_H

#include <QObject>
#include <QAbstractListModel>

#include "../dstypes.h"

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

public slots:
    void reload(QList<DSMeasurement> mList);
    void clear();
};

#endif // MEASUREMENTSMODEL_H
