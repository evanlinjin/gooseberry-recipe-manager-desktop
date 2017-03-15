#ifndef INGREDIENTSMODEL_H
#define INGREDIENTSMODEL_H

#include <QObject>
#include <QAbstractListModel>

#include "../dstypes.h"
#include "networkmanager.h"

class IngredientsModel : public QAbstractListModel
{
    Q_OBJECT
public:
    IngredientsModel(QObject *parent = 0);

    enum Roles {
        nameRole = Qt::UserRole + 1,
        descriptionRole,
        kgPerCupRole,
        tagsRole
    };

    QHash<int, QByteArray> roleNames() const;
    QVariant data(const QModelIndex &index, int role) const;
    int rowCount(const QModelIndex &parent = QModelIndex()) const;

private:
    NetworkManager* nManager;
    QList<DSIngredient> m_list;
    QString nid;

signals:
//    void reload(QString);

public slots:
    void linkUp(NetworkManager* nm, QString id);
    void reload();
    void clear();

private slots:
    void process_recieved_measurements(QList<DSIngredient> list, QString id);
    void reloadData(QList<DSIngredient> mList);
};

#endif // INGREDIENTSMODEL_H
