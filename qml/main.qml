import QtQuick 2.2
import QtQuick.Window 2.0
import "../presentation"

Window {
    id: mainWindow
    visible: true
    width: 1600
    height: 900
    title: qsTr("Forstå hjernen med programmering - åpen dag 12. mars 2015")

    MyPresentation {
        focus: true
        anchors.fill: parent
    }
}
