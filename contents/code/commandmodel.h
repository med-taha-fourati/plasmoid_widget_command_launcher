#pragma once

#include <QAbstractListModel>
#include <QProcess>
#include <QStringList>
#include <QVector>
#include <QtQml/qqmlregistration.h>
#include <QtQml>

struct Command {
    QString name;
    QString command;
    QString icon;
};

class CommandModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT
    
    Q_PROPERTY(QStringList commands READ commands WRITE setCommands NOTIFY commandsChanged)
    
public:
    explicit CommandModel(QObject *parent = nullptr);
    ~CommandModel() override = default;
    
    enum Roles {
        NameRole = Qt::UserRole + 1,
        CommandRole,
        IconRole
    };
    
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;
    
    Q_INVOKABLE void executeCommand(int index);
    Q_INVOKABLE void configure();
    
    QStringList commands() const;
    void setCommands(const QStringList &commands);
    
Q_SIGNALS:
    void commandsChanged();
    
private:
    void loadCommands();
    void saveCommands();
    
    QVector<Command> m_commands;
    QProcess *m_process;
};

// static void registerCommandLauncherTypes()
// {
//     qmlRegisterType<CommandModel>("org.kde.commandlauncher", 1, 0, "CommandModel");
// }

// Q_COREAPP_STARTUP_FUNCTION(registerCommandLauncherTypes);

//Q_DECLARE_METATYPE(CommandModel*)
