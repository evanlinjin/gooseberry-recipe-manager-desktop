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

#define CMD_GET_MEASUREMENTS "get_measurements"
#define STATUS_OK "OK"
#define STATUS_ERROR "ERROR"

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

signals:
    void recieved_error(QString cmd, QString msg);
    void recieved_measurements(QList<DSMeasurement>);

public slots:
    void get_measurements();

private slots:
    void handleRequest(QString cmd, QJsonValue v);
    void handleReply(QNetworkReply* reply);

    void process_measurements(QJsonValue v);
};

#endif // NETWORKMANAGER_H
