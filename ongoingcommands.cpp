#include "ongoingcommands.h"

OngoingCommands::OngoingCommands(QObject *parent) : QObject(parent)
{

}

bool OngoingCommands::has(QString cmd)
{
    return m_cmds.value(cmd, false);
}

bool OngoingCommands::add(QString cmd)
{
    if (m_cmds.value(cmd, false)) {
        qDebug() << "[OngoingCommands] IGNORING:" << cmd;
        return false;
    }
    qDebug() << "[OngoingCommands] PROCESSING:" << cmd;
    m_cmds.insert(cmd, true);
    emit this->added(cmd);
    return true;
}

bool OngoingCommands::remove(QString cmd)
{
    if (m_cmds.value(cmd, false) == false) {
        qDebug() << "[OngoingCommands] ALREADY DONE:" << cmd;
        return false;
    }
    qDebug() << "[OngoingCommands] DONE:" << cmd;
    m_cmds.insert(cmd, false);
    emit this->removed(cmd);
    return true;
}
