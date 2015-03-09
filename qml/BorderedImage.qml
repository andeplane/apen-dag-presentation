import QtQuick 2.0
import QtGraphicalEffects 1.0
Item {
    id: root
    property alias source: image.source
    property real borderWidth: width * 0.005
    property real shadowRadius: width * 0.03
    ShaderEffectSource {
        anchors.fill: parent
        hideSource: true
        sourceItem: sourceItem
    }
    Item {
        id: sourceItem
        anchors.fill: parent

        Item {
            id: container
            anchors.fill: parent
            Rectangle {
                id: borderRectangle
                x: image.x + (image.width - image.paintedWidth) / 2 - borderWidth
                y: image.y + (image.height - image.paintedHeight) / 2 - borderWidth
                width: image.paintedWidth + borderWidth*2
                height: image.paintedHeight + borderWidth*2
                radius: borderWidth / 2

                color: "#000000"
                z: -1
            }
            Image {
                id: image
                anchors {
                    fill: parent
                    margins: (borderWidth+shadowRadius)
                }
                fillMode: Image.PreserveAspectFit
                antialiasing: true
                smooth: true
            }

        }
        DropShadow {
            id: borderShadow
            anchors.fill: container
            cached: true;
            horizontalOffset: root.width * 0.01;
            verticalOffset: root.width * 0.01;
            radius: shadowRadius;
            samples: 32;
            color: "#40000000";
            smooth: true;
            source: container;
        }
    }
}


