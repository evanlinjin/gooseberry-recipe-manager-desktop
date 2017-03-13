#ifndef ONGOINGCOMMANDS_H
#define ONGOINGCOMMANDS_H

#include <QObject>
#include <QString>
#include <QMap>
#include <QDebug>

class OngoingCommands : public QObject
{
    Q_OBJECT
public:
    explicit OngoingCommands(QObject *parent = 0);

private:
    QMap<QString, bool> m_cmds;

signals:
    void added(QString cmd);
    void removed(QString cmd);

public slots:
    bool has(QString cmd);
    bool add(QString cmd);
    bool remove(QString cmd);
};

#endif // ONGOINGCOMMANDS_H
