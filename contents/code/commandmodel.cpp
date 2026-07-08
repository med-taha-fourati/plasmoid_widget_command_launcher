#include "commandmodel.h"

#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QProcess>
#include <QStandardPaths>

CommandModel::CommandModel(QObject *parent)
    : QAbstractListModel(parent)
{
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
    case DescriptionRole:
        return cmd.description;
    case IconRole:
        return cmd.icon;
    case SudoRole:
        return cmd.sudo;
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> CommandModel::roleNames() const
{
    return {
        {NameRole, "name"},
        {CommandRole, "command"},
        {DescriptionRole, "description"},
        {IconRole, "icon"},
        {SudoRole, "sudo"},
    };
}

void CommandModel::executeCommand(int index)
{
    if (index < 0 || index >= m_commands.count())
        return;

    const Command &cmd = m_commands.at(index);
    if (cmd.command.isEmpty())
        return;

    auto *process = new QProcess();
    connect(process, &QProcess::errorOccurred, process, &QProcess::deleteLater);
    connect(process, &QProcess::finished, process, &QProcess::deleteLater);

    if (cmd.sudo) {
        const QString pkexec = QStandardPaths::findExecutable("pkexec");
        if (pkexec.isEmpty()) {
            delete process;
            return;
        }
        // pkexec pops up the native polkit authentication dialog before running the command.
        process->start(pkexec, {"sh", "-c", cmd.command});
    } else {
        process->start("sh", {"-c", cmd.command});
    }
}

QString CommandModel::commandsJson() const
{
    return m_commandsJson;
}

void CommandModel::setCommandsJson(const QString &json)
{
    if (json == m_commandsJson)
        return;

    m_commandsJson = json;

    beginResetModel();
    m_commands.clear();

    const QJsonArray array = QJsonDocument::fromJson(json.toUtf8()).array();
    for (const QJsonValue &value : array) {
        const QJsonObject obj = value.toObject();
        Command cmd;
        cmd.name = obj.value("name").toString();
        cmd.command = obj.value("command").toString();
        cmd.description = obj.value("description").toString();
        cmd.icon = obj.value("icon").toString(QStringLiteral("utilities-terminal"));
        cmd.sudo = obj.value("sudo").toBool();
        m_commands.append(cmd);
    }

    endResetModel();
    emit commandsJsonChanged();
}
