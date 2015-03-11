import QtQuick 2.0

Rectangle {
    id: buttonRoot
    signal loadPattern(var pattern)
    property string pattern: ""
    width: 100
    height: 100
    color: "blue"
    MouseArea {
        anchors.fill: parent
        onClicked: {
            buttonRoot.loadPattern(pattern)
        }
    }
}
