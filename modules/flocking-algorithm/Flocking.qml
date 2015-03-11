import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.1
import Flocking 1.0

Item {
    id: flockingRoot

    property real aspectRatio: width/height
    property alias running: flockingController.running
    width: 1080
    height: width

    focus: true

    function addObstacle(x, y) {
        var size = 100;
        x -= size*0.5;
        y -= size*0.5;
        var newObject = Qt.createQmlObject('import QtQuick 2.4; Rectangle {color: "red"; x:'+x+'; y:'+y+'; width: '+size+'; height: '+size+'; radius: width*0.5;}',
             flockingRoot, "dynamicSnippet1");
        x = 2*(x / flockingRoot.width) - 1.0
        y = 2*(y / flockingRoot.height) - 1.0
        flockingController.addObstacle(Qt.vector2d(x,y));
    }

    MouseArea {
        width: parent.width
        height: parent.height
        hoverEnabled: true

        onMouseXChanged: {
            flockingController.mouseMoved(mouse);
        }

        onMouseYChanged: {
            flockingController.mouseMoved(mouse);
        }

        onClicked: {
            addObstacle(mouse.x, mouse.y)
        }
    }

    Flocking {
        id: flockingController
        anchors.fill: parent
        running: true

        function mouseMoved(mouse) {
            var mouseX = mouse.x
            var mouseY = mouse.y
            mouseX = mouseX / flockingRoot.width
            mouseY = mouseY / flockingRoot.height
            mouseX = mouseX*2.0 - 1.0
            mouseY = mouseY*2.0 - 1.0
            setMousePosition(Qt.vector2d(mouseX, mouseY));
        }

        Timer {
            id: timer
            property real lastTime: Date.now()
            property real lastSampleTime: Date.now()
            running: flockingController.running
            repeat: true
            interval: 1
            onTriggered: {
                if(!flockingController.previousStepCompleted) {
                    return
                }

                var currentTime = Date.now()
                var dt = currentTime - lastTime
                dt /= 1000
                flockingController.step(dt)

                var sampleTimeDifference = (currentTime - lastSampleTime)/1000
                lastTime = currentTime
            }
        }
    }
}

