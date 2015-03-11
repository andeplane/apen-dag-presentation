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
        id: presentation
        focus: true
        anchors.fill: parent

        function refreshFullScreen() {
            if(fullScreen) {
                mainWindow.visibility = Window.FullScreen
            } else {
                mainWindow.visibility = Window.Windowed
            }
        }

        Component.onCompleted: {
            refreshFullScreen()
        }

        onFullScreenChanged: {
            refreshFullScreen()
        }
    }
}
