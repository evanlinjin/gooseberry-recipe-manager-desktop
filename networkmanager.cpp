#include "networkmanager.h"

NetworkManager::NetworkManager(QString url, QString token, QObject *parent) :
    QObject(parent), m_url(QUrl(url)), m_token(token) {
    nm = new QNetworkAccessManager(this);

    connect(nm, SIGNAL(finished(QNetworkReply*)),
            this, SLOT(handleReply(QNetworkReply*)));
}

void NetworkManager::handleRequest(QString cmd, QJsonValue v, QString id) {
    if (m_cmds.add(cmd) == false) return;

    QNetworkRequest nReq;
    nReq.setUrl(m_url);
    nReq.setRawHeader("Content-Type", "application/json");

    QJsonObject obj;
    obj["cmd"] = cmd;
    obj["token"] = m_token;
    obj["data"] = v;

    QNetworkReply* reply = nm->post(nReq, QJsonDocument(obj).toJson());
    replies[reply] = id;
}

void NetworkManager::handleReply(QNetworkReply* reply) {
    QJsonObject obj = QJsonDocument::fromJson(reply->readAll()).object();
    reply->deleteLater();

    // handle ongoing commands. <-- should probably delete this functionality...
    auto cmd = obj["cmd"].toString();
    m_cmds.remove(cmd);

    // get id.
    auto id = replies[reply];

    auto v = obj["data"];

    auto status = obj["status"].toString();
    if (status == QString(STATUS_ERROR)) emit recieved_error(cmd, v.toString());

    if (cmd == QString("")) return;
    else if (cmd == QString(CMD_GET_MEASUREMENTS))
        process_measurements(v, id);
    else if (cmd == QString(CMD_GET_ALL_INGREDIENTS))
        process_get_all_ingredients(v, id);
    else if (cmd == QString(CMD_GET_INGREDIENT_OF_KEY))
        process_get_ingredient_of_key(v, id);
    else if (cmd == QString(CMD_MODIFY_INGREDIENT))
        process_modify_ingredient(v, id);
    else if (cmd == QString(CMD_ADD_INGREDIENT))
        process_add_ingredient(v, id);
}

/* COMMAND : GET_MEASUREMENTS */

void NetworkManager::get_measurements(QString id) {
    this->handleRequest(CMD_GET_MEASUREMENTS, 0, id);
}

void NetworkManager::process_measurements(QJsonValue v, QString id) {
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
    emit recieved_measurements(mArray, id);
}

/* COMMAND : GET_ALL_INGREDIENTS */

void NetworkManager::get_all_ingredients(QString id) {
    this->handleRequest(CMD_GET_ALL_INGREDIENTS, 0, id);
}

void NetworkManager::process_get_all_ingredients(QJsonValue v, QString id) {
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
    emit recieved_get_all_ingredients(vArray, id);
}

/* COMMAND : GET_INGREDIENT_OF_KEY */

void NetworkManager::get_ingredient_of_key(QString key, QString id) {
    this->handleRequest(CMD_GET_INGREDIENT_OF_KEY, key, id);
}

void NetworkManager::process_get_ingredient_of_key(QJsonValue v, QString id) {
    auto d = v.toObject();
    {
        DSIngredient v;
        v.name = d["name"].toString();
        v.description = d["description"].toString();
        v.kg_per_cup = d["kg_per_cup"].toDouble();
        QJsonArray tags = d["tags"].toArray();
        for (int j = 0; j < tags.size(); j++) {
            v.tags.append(tags.at(j).toString());
        }
        qDebug() << "[GOT INGREDIENT]" << v.name << v.tags << v.kg_per_cup << v.description;
        emit recieved_get_ingredient_of_key(v, id);
    }
}

/* COMMAND : MODIFY_INGREDIENT */

void NetworkManager::modify_ingredient(DSIngredient v, QString id) {
    QJsonObject obj;
    obj["name"] = v.name;
    obj["description"] = v.description;
    obj["kg_per_cup"] = v.kg_per_cup;
    QJsonArray tags;
    for (int i = 0; i < v.tags.size(); i++) {
        tags.append(v.tags.at(i));
    }
    obj["tags"] = tags;
    this->handleRequest(CMD_MODIFY_INGREDIENT, obj, id);
}

void NetworkManager::process_modify_ingredient(QJsonValue v, QString id) {
    auto d = v.toObject();
    {
        DSIngredient v;
        v.name = d["name"].toString();
        v.description = d["description"].toString();
        v.kg_per_cup = d["kg_per_cup"].toDouble();
        QJsonArray tags = d["tags"].toArray();
        for (int j = 0; j < tags.size(); j++) {
            v.tags.append(tags.at(j).toString());
        }
        qDebug() << "[GOT INGREDIENT]" << v.name << v.tags << v.kg_per_cup << v.description;
        emit recieved_modify_ingredient(v, id);
    }
}

/* COMMAND : ADD_INGREDIENT */

void NetworkManager::add_ingredient(DSIngredient v, QString id) {
    QJsonObject obj;
    obj["name"] = v.name;
    obj["description"] = v.description;
    obj["kg_per_cup"] = v.kg_per_cup;
    QJsonArray tags;
    for (int i = 0; i < v.tags.size(); i++) {
        tags.append(v.tags.at(i));
    }
    obj["tags"] = tags;
    this->handleRequest(CMD_ADD_INGREDIENT, obj, id);
}

void NetworkManager::process_add_ingredient(QJsonValue v, QString id) {
    auto d = v.toObject();
    {
        DSIngredient v;
        v.name = d["name"].toString();
        v.description = d["description"].toString();
        v.kg_per_cup = d["kg_per_cup"].toDouble();
        QJsonArray tags = d["tags"].toArray();
        for (int j = 0; j < tags.size(); j++) {
            v.tags.append(tags.at(j).toString());
        }
        qDebug() << "[GOT INGREDIENT]" << v.name << v.tags << v.kg_per_cup << v.description;
        emit recieved_add_ingredient(v, id);
    }
}
