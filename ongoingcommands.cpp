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
        return false;
    }
    m_cmds.insert(cmd, true);
    emit this->added(cmd);
    return true;
}

bool OngoingCommands::remove(QString cmd)
{
    if (m_cmds.value(cmd, false)) {
        return false;
    }
    m_cmds.insert(cmd, false);
    emit this->removed(cmd);
    return true;
}
