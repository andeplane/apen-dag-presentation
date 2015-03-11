import QtQuick 2.0

Image {
    anchors.fill: parent
    anchors.margins: Math.min(parent.height * 0.1, parent.width * 0.1)
    fillMode: Image.PreserveAspectFit
    antialiasing: true
    smooth: true
}
