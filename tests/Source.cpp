#include <QGuiApplication>
#include <QFileSystemWatcher>
#include <QDir>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "Backend.h"

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);
    app.setQuitOnLastWindowClosed(true);
    QQmlApplicationEngine engine;

    Backend backend;
    engine.rootContext()->setContextProperty("backend", &backend);
    engine.loadFromModule("ui", "Source");

    // QFileSystemWatcher watcher;
    // QDir dir("/home/slawek/dev/higlight_viewer/ui/");
    // QStringList files = dir.entryList(QDir::Files | QDir::NoDotAndDotDot, QDir::Name);
    // for (const QString &file : files) { watcher.addPath(dir.absoluteFilePath(file)); }

    // QObject::connect(&watcher, &QFileSystemWatcher::fileChanged, [&] {
    //     const auto roots = engine.rootObjects();
    //     for (QObject *obj : roots) { obj->deleteLater(); }

    //     engine.clearComponentCache();
    //     // engine.loadFromModule("ui", "Source");
    //     engine.load(QUrl::fromLocalFile("/home/slawek/dev/higlight_viewer/ui/Source.qml"));

    //     QStringList files = dir.entryList(QDir::Files | QDir::NoDotAndDotDot, QDir::Name);
    //     for (const QString &file : files) { watcher.addPath(dir.absoluteFilePath(file)); }
    // });

    if (engine.rootObjects().isEmpty()) return -1;
    return app.exec();
}
