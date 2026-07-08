#pragma once

#include <QAbstractListModel>
#include <QString>
#include <QVector>
#include <QtQml/qqmlregistration.h>

struct Command {
    QString name;
    QString command;
    QString description;
    QString icon;
    bool sudo = false;
};

class CommandModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT

    // JSON-encoded array of command objects, bound to Plasmoid.configuration.commands.
    Q_PROPERTY(QString commandsJson READ commandsJson WRITE setCommandsJson NOTIFY commandsJsonChanged)

public:
    explicit CommandModel(QObject *parent = nullptr);
    ~CommandModel() override = default;

    enum Roles {
        NameRole = Qt::UserRole + 1,
        CommandRole,
        DescriptionRole,
        IconRole,
        SudoRole
    };

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void executeCommand(int index);

    QString commandsJson() const;
    void setCommandsJson(const QString &json);

Q_SIGNALS:
    void commandsJsonChanged();

private:
    QVector<Command> m_commands;
    QString m_commandsJson;
};
