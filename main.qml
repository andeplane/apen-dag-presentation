import QtQuick 2.2
import QtQuick.Window 2.0
import "presentation"

Window {
    visible: true
    width: 1600
    height: 900
    title: qsTr("Master Presentation")

    MyPresentation {
        focus: true
        anchors.fill: parent
    }
}
