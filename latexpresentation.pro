TEMPLATE = app
CONFIG -= app_bundle
QT += qml quick widgets opengl openglextensions
CONFIG += c++11

SOURCES += main.cpp \
    latexrunner/latexrunner.cpp \
    modules/andromeda-viewer/and_billboards.cpp \
    modules/andromeda-viewer/and_controller.cpp \
    modules/andromeda-viewer/and_renderer.cpp \
    modules/andromeda-viewer/and_simulator.cpp \
    modules/flocking-algorithm/flock_billboards.cpp \
    modules/flocking-algorithm/flock_controller.cpp \
    modules/flocking-algorithm/flock_renderer.cpp \
    modules/flocking-algorithm/flock_simulator.cpp

HEADERS += \
    latexrunner/latexrunner.h \
    modules/andromeda-viewer/and_billboards.h \
    modules/andromeda-viewer/and_controller.h \
    modules/andromeda-viewer/and_renderer.h \
    modules/andromeda-viewer/and_simulator.h \
    modules/flocking-algorithm/flock_billboards.h \
    modules/flocking-algorithm/flock_controller.h \
    modules/flocking-algorithm/flock_renderer.h \
    modules/flocking-algorithm/flock_simulator.h

RESOURCES += \
#    images.qrc \
#    latex.qrc \
#    qml.qrc \
#    presentation.qrc

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

copydata.commands = $(COPY_DIR) $$PWD/latex $$PWD/qml $$PWD/modules $$PWD/figures $$PWD/videos $$PWD/fonts $$PWD/presentation $$OUT_PWD
first.depends = $(first) copydata
export(first.depends)
export(copydata.commands)
QMAKE_EXTRA_TARGETS += first copydata

DISTFILES += \
    qml/BorderedImage.qml \
    qml/DefaultImage.qml \
    qml/Heading.qml \
    qml/Latex.qml \
    qml/LowerLeftSlide.qml \
    qml/LowerRightSlide.qml \
    qml/MultiSlide.qml \
    qml/Presentation.qml \
    qml/Slide.qml \
    qml/TopText.qml \
    qml/TransitionPresentation.qml \
    qml/UpperLeftSlide.qml \
    qml/UpperRightSlide.qml \
    presentation/GameOfGLSL.qml \
    presentation/GameOfLifeExplained.qml \
    presentation/GamePatternButton.qml \
    presentation/GamePatterns.qml \
    presentation/MyPresentation.qml \
    latex/formula.tex \
    qml/main.qml
