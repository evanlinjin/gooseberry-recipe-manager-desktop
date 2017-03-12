#ifndef WSCLIENT_H
#define WSCLIENT_H

#include <QObject>
#include <QWebSocket>
#include <QDebug>

class WSClient : public QObject
{
    Q_OBJECT
public:
    explicit WSClient(const QUrl &url, bool debug = false, QObject *parent = 0);
    ~WSClient();

signals:
    void opened();
    void closed();
    void msg(QString msg);

public slots:
    void open(const QUrl &url);
    bool isOpen();
    bool sendMsg(QString msg);

private slots:
    void onConnected();
    void onDisconnected();
    void onMessage(QString msg);

private:
    QWebSocket m_ws;
    QUrl m_url;
    bool m_debug, m_active;
};

#endif // WSCLIENT_H
