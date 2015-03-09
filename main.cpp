#include <QApplication>
#include <QQmlApplicationEngine>
#include <QDebug>
#include <QDir>
#include "latexrunner/latexrunner.h"
#include "modules/andromeda-viewer/controller.h"

int main(int argc, char *argv[])
{
    qmlRegisterType<LatexRunner>("LatexPresentation", 1, 0, "LatexRunner");
    qmlRegisterType<Andromeda::Controller>("Andromeda", 1, 0, "Andromeda");

    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
