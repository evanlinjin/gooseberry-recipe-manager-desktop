#ifndef NETWORKMANAGER_H
#define NETWORKMANAGER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QUrl>
#include <QJsonObject>
#include <QJsonDocument>
#include <QJsonArray>
#include <QDebug>

#include "dstypes.h"
#include "ongoingcommands.h"

class NetworkManager : public QObject
{
    Q_OBJECT
public:
    explicit NetworkManager(QString url, QString token, QObject *parent = 0);

private:
    QNetworkAccessManager* nm;
    OngoingCommands m_cmds;
    QUrl m_url;
    QString m_token;
    QHash<QNetworkReply*, QString> replies;

    void getIngredient(QJsonValue &v, DSIngredient &vItem);
    void getIngredientList(QJsonValue &v, QList<DSIngredient> &vArray);
    void getIngredientJsonObj(DSIngredient &v, QJsonObject &obj);

signals:
    void recieved_error(QString cmd, QString msg);

    void recieved_measurements(QList<DSMeasurement>,QString);
    void recieved_get_all_ingredients(QList<DSIngredient>,QString);
    void recieved_get_ingredient_of_key(DSIngredient,QString);
    void recieved_modify_ingredient(DSIngredient,QString);
    void recieved_add_ingredient(DSIngredient,QString);
    void recieved_delete_ingredient(QString,QString);
    void recieved_search_ingredients(QList<DSIngredient>,QString);

public slots:
    void get_measurements(QString id);
    void get_all_ingredients(QString id);
    void get_ingredient_of_key(QString key, QString id);
    void modify_ingredient(DSIngredient v, QString id);
    void add_ingredient(DSIngredient v, QString id);
    void delete_ingredient(QString v, QString id);
    void search_ingredients(QString v, QString id);

private:
    void process_measurements(QJsonValue &v, QString &id);
    void process_get_all_ingredients(QJsonValue &v, QString &id);
    void process_get_ingredient_of_key(QJsonValue &v, QString &id);
    void process_modify_ingredient(QJsonValue &v, QString &id);
    void process_add_ingredient(QJsonValue &v, QString &id);
    void process_delete_ingredient(QJsonValue &v, QString &id);
    void process_search_ingredients(QJsonValue &v, QString &id);

    void handleRequest(QString cmd, QJsonValue v, QString &id);

private slots:
    void handleReply(QNetworkReply* reply);
};

#endif // NETWORKMANAGER_H
