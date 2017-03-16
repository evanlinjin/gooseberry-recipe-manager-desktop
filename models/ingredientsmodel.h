#ifndef INGREDIENTSMODEL_H
#define INGREDIENTSMODEL_H

#include <QObject>
#include <QAbstractListModel>
#include <QDebug>

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
    void process_recieved_ingredients(QList<DSIngredient> list, QString id);
    void process_recieved_ingredient(DSIngredient v);
    void process_delete_ingredient(QString v);

    void reloadData(QList<DSIngredient> mList);
};

#endif // INGREDIENTSMODEL_H
