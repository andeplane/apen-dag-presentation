TEMPLATE = app
CONFIG -= app_bundle
QT += qml quick widgets opengl openglextensions
CONFIG += c++11

SOURCES += main.cpp \
    latexrunner/latexrunner.cpp \
    modules/andromeda-viewer/renderer.cpp \
    modules/andromeda-viewer/controller.cpp \
    modules/andromeda-viewer/billboards.cpp \
    modules/andromeda-viewer/simulator.cpp \
    modules/andromeda-viewer/points.cpp \
    modules/andromeda-viewer/random.cpp

HEADERS += \
    latexrunner/latexrunner.h \
    modules/andromeda-viewer/controller.h \
    modules/andromeda-viewer/renderer.h \
    modules/andromeda-viewer/billboards.h \
    modules/andromeda-viewer/simulator.h \
    modules/andromeda-viewer/points.h \
    modules/andromeda-viewer/random.h

RESOURCES += \
    images.qrc \
    latex.qrc \
    qml.qrc \
    presentation.qrc

macx {
    DEFINES += MAC_OSX
}

unix:!macx {
    DEFINES += LINUX
}

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)
