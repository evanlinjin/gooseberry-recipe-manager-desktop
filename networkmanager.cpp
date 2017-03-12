#include "networkmanager.h"

NetworkManager::NetworkManager(QString url, QString token, QObject *parent) :
    QObject(parent), m_url(QUrl(url)), m_token(token)
{
    nm = new QNetworkAccessManager(this);

    connect(nm, SIGNAL(finished(QNetworkReply*)),
            this, SLOT(handleReply(QNetworkReply*)));
}

void NetworkManager::get_measurements()
{
    this->handleRequest(CMD_GET_MEASUREMENTS, 0);
}

void NetworkManager::handleRequest(QString cmd, QJsonValue v)
{
    if (m_cmds.add(cmd) == false) return;

    QNetworkRequest nReq;
    nReq.setUrl(m_url);
    nReq.setRawHeader("Content-Type", "application/json");

    QJsonObject obj;
    obj["cmd"] = cmd;
    obj["token"] = m_token;
    obj["data"] = v;

    nm->post(nReq, QJsonDocument(obj).toJson());
}

void NetworkManager::handleReply(QNetworkReply* reply)
{
    QJsonObject obj = QJsonDocument::fromJson(reply->readAll()).object();
    reply->deleteLater();

    auto cmd = obj["cmd"].toString();
    m_cmds.remove(cmd);

    auto status = obj["status"].toString();
    if (status == QString(STATUS_ERROR)) emit recieved_error(cmd, obj["data"].toString());

    if (cmd == QString("")) return;
    else if (cmd == QString(CMD_GET_MEASUREMENTS)) process_measurements(obj["data"]);
}

void NetworkManager::process_measurements(QJsonValue v)
{
    QList<DSMeasurement> mArray;
    auto dataArray = v.toArray();
    for (int i = 0; i < dataArray.size(); i++) {
        auto d = dataArray.at(i).toObject();
        DSMeasurement m;
        m.name = d["name"].toString();
        m.multiply = d["multiply"].toDouble();
        m.symbol = d["symbol"].toString();
        m.type = d["type"].toString();
        qDebug() << m.name << m.multiply << m.symbol << m.type;
        mArray.append(m);
    }
    emit recieved_measurements(mArray);
}
