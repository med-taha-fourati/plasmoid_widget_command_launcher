#include "commandmodel.h"
#include <KConfigGroup>
#include <KSharedConfig>
#include <KLocalizedString>

CommandModel::CommandModel(QObject *parent)
    : QAbstractListModel(parent)
    , m_process(new QProcess(this))
{
    loadCommands();
}

int CommandModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return m_commands.count();
}

QVariant CommandModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_commands.count())
        return QVariant();
        
    const Command &cmd = m_commands.at(index.row());
    
    switch (role) {
    case NameRole:
        return cmd.name;
    case CommandRole:
        return cmd.command;
    case IconRole:
        return cmd.icon;
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> CommandModel::roleNames() const
{
    static QHash<int, QByteArray> roles;
    if (roles.isEmpty()) {
        roles[NameRole] = "name";
        roles[CommandRole] = "command";
        roles[IconRole] = "icon";
    }
    return roles;
}

void CommandModel::executeCommand(int index)
{
    if (index < 0 || index >= m_commands.count())
        return;
        
    const QString &command = m_commands.at(index).command;
    if (command.isEmpty())
        return;
        
    m_process->start("sh", {"-c", command});
}

void CommandModel::configure()
{
    // Handled by QML
}

QStringList CommandModel::commands() const
{
    QStringList result;
    for (const auto &cmd : m_commands) {
        result << QString("%1||%2||%3").arg(cmd.name, cmd.command, cmd.icon);
    }
    return result;
}

void CommandModel::setCommands(const QStringList &commands)
{
    beginResetModel();
    m_commands.clear();
    
    for (const QString &entry : commands) {
        QStringList parts = entry.split("||");
        if (parts.size() < 2)
            continue;
            
        Command cmd;
        cmd.name = parts[0];
        cmd.command = parts[1];
        cmd.icon = parts.size() > 2 ? parts[2] : "utilities-terminal";
        m_commands.append(cmd);
    }
    
    endResetModel();
    saveCommands();
    emit commandsChanged();
}

void CommandModel::loadCommands()
{
    KConfigGroup cfg = KSharedConfig::openConfig()->group("CommandLauncher");
    QStringList commandList = cfg.readEntry("Commands", QStringList());
    
    beginResetModel();
    m_commands.clear();
    
    for (const QString &entry : commandList) {
        QStringList parts = entry.split("||");
        if (parts.size() < 2)
            continue;
            
        Command cmd;
        cmd.name = parts[0];
        cmd.command = parts[1];
        cmd.icon = parts.size() > 2 ? parts[2] : "utilities-terminal";
        m_commands.append(cmd);
    }
    
    endResetModel();
}

void CommandModel::saveCommands()
{
    KConfigGroup cfg = KSharedConfig::openConfig()->group("CommandLauncher");
    QStringList commandList;
    
    for (const auto &cmd : m_commands) {
        commandList << QString("%1||%2||%3").arg(cmd.name, cmd.command, cmd.icon);
    }
    
    cfg.writeEntry("Commands", commandList);
    cfg.sync();
}
