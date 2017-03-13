#include "networkmanager.h"

NetworkManager::NetworkManager(QString url, QString token, QObject *parent) :
    QObject(parent), m_url(QUrl(url)), m_token(token)
{
    nm = new QNetworkAccessManager(this);

    connect(nm, SIGNAL(finished(QNetworkReply*)),
            this, SLOT(handleReply(QNetworkReply*)));
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

    auto v = obj["data"];

    auto status = obj["status"].toString();
    if (status == QString(STATUS_ERROR)) emit recieved_error(cmd, v.toString());

    if (cmd == QString("")) return;
    else if (cmd == QString(CMD_GET_MEASUREMENTS)) process_measurements(v);
    else if (cmd == QString(CMD_GET_ALL_INGREDIENTS)) process_get_all_ingredients(v);
}

/* COMMAND : GET_MEASUREMENTS */

void NetworkManager::get_measurements()
{
    this->handleRequest(CMD_GET_MEASUREMENTS, 0);
}

void NetworkManager::process_measurements(QJsonValue v)
{
    QList<DSMeasurement> mArray;
    auto dataArray = v.toArray();
    qDebug() << "::: MEASUREMENTS >>>";
    for (int i = 0; i < dataArray.size(); i++) {
        auto d = dataArray.at(i).toObject();
        DSMeasurement m;
        m.name = d["name"].toString();
        m.multiply = d["multiply"].toDouble();
        m.symbol = d["symbol"].toString();
        m.type = d["type"].toString();
        qDebug() << "\t" << m.name << m.multiply << m.symbol << m.type;
        mArray.append(m);
    }
    qDebug() << "";
    emit recieved_measurements(mArray);
}

/* COMMAND : GET_ALL_INGREDIENTS */

void NetworkManager::get_all_ingredients()
{
    this->handleRequest(CMD_GET_ALL_INGREDIENTS, 0);
}

void NetworkManager::process_get_all_ingredients(QJsonValue v)
{
    QList<DSIngredient> vArray;
    auto dataArray = v.toArray();
    qDebug() << "::: INGREDIENTS >>>";
    for (int i = 0; i < dataArray.size(); i++) {
        auto d = dataArray.at(i).toObject();
        DSIngredient v;
        v.name = d["name"].toString();
        v.description = d["description"].toString();
        v.kg_per_cup = d["kg_per_cup"].toDouble();
        QJsonArray tags = d["tags"].toArray();
        for (int j = 0; j < tags.size(); j++) {
            v.tags.append(tags.at(j).toString());
        }
        qDebug() << "\t" << v.name << v.tags << v.kg_per_cup << v.description;
        vArray.append(v);
    }
    qDebug() << "";
    emit recieved_get_all_ingredients(vArray);
}
