#ifndef INGREDIENTSMODEL_H
#define INGREDIENTSMODEL_H

#include <QObject>
#include <QAbstractListModel>

#include "../dstypes.h"

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
    QList<DSIngredient> m_list;

signals:
    void reload();

public slots:
    void reloadData(QList<DSIngredient> mList);
    void clear();
};

#endif // INGREDIENTSMODEL_H
