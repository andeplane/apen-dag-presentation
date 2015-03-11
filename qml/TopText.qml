import QtQuick 2.0

Text {
    property real defaultFontSize: firstSlide._titleFontSize
    width: parent.width
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    font.family: firstSlide.titleFontFamily
    font.pixelSize: defaultFontSize
    horizontalAlignment: Text.Center
}

