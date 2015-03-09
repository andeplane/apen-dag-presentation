#include <QApplication>
#include <QQmlApplicationEngine>
#include <QDebug>
#include <QDir>
#include "latexrunner/latexrunner.h"
#include "modules/andromeda-viewer/and_controller.h"
#include "modules/flocking-algorithm/flock_controller.h"

int main(int argc, char *argv[])
{
    qmlRegisterType<LatexRunner>("LatexPresentation", 1, 0, "LatexRunner");
    qmlRegisterType<Andromeda::Controller>("Andromeda", 1, 0, "Andromeda");
    qmlRegisterType<Flocking::Controller>("Flocking", 1, 0, "Flocking");

    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
