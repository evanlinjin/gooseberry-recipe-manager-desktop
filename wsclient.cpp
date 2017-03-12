#include "wsclient.h"

WSClient::WSClient(const QUrl &url, bool debug, QObject *parent) :
    QObject(parent), m_url(url), m_debug(debug), m_active(false)
{
    if (m_debug) qDebug() << "WebSocket server:" << url;
    connect(&m_ws, &QWebSocket::connected, this, &WSClient::onConnected);
    connect(&m_ws, &QWebSocket::disconnected, this, &WSClient::onDisconnected);
    connect(&m_ws, &QWebSocket::textMessageReceived, this, &WSClient::onMessage);
    m_ws.open(QUrl(url));
}

WSClient::~WSClient()
{
    m_ws.close();
}

void WSClient::open(const QUrl &url)
{
    m_ws.open(QUrl(url));
}

bool WSClient::isOpen()
{
    return m_active;
}

bool WSClient::sendMsg(QString msg)
{
    if (m_active == false) {
        return false;
    }
    m_ws.sendTextMessage(msg);
    if (m_debug) qDebug() << "WebSocket message sent:" << msg;
    return true;
}

void WSClient::onConnected()
{
    m_active = true;
    if (m_debug) qDebug() << "WebSocket connected.";
    emit opened();
}

void WSClient::onDisconnected()
{
    m_active = false;
    if (m_debug) qDebug() << "WebSocket disconnected.";
    emit closed();
}

void WSClient::onMessage(QString msg)
{
    if (m_debug) qDebug() << "WebSocket message recieved:" << msg;
    emit this->msg(msg);
}
