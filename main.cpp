#include <QApplication>
#include <QQmlApplicationEngine>
#include <QDebug>
#include <QDir>
#include <QtQuick/QQuickView>
#include <QFontDatabase>
#include "latexrunner/latexrunner.h"
#include "modules/andromeda-viewer/and_controller.h"
#include "modules/flocking-algorithm/flock_controller.h"

int main(int argc, char *argv[])
{
    qmlRegisterType<LatexRunner>("LatexPresentation", 1, 0, "LatexRunner");
    qmlRegisterType<Andromeda::Controller>("Andromeda", 1, 0, "Andromeda");
    qmlRegisterType<Flocking::Controller>("Flocking", 1, 0, "Flocking");

    QApplication app(argc, argv);

    QQuickView view;

    QFontDatabase::addApplicationFont("fonts/SourceSansPro-Regular.ttf");
    app.setFont(QFont("Source Sans Pro"));

    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.setSource(QUrl("presentation/MyPresentation.qml"));

//    view.showFullScreen();
    view.show();

    return app.exec();
}
