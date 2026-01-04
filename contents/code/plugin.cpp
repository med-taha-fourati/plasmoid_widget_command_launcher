#include <QQmlExtensionPlugin>
#include <QQmlEngine>
#include "commandmodel.h"

class CommandLauncherPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    void registerTypes(const char *uri) override
    {
        Q_ASSERT(uri == QLatin1String("org.kde.commandlauncher"));
        qmlRegisterType<CommandModel>(uri, 1, 0, "CommandModel");
    }
};