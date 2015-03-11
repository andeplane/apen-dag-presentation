import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Window 2.0
import QtQuick.Dialogs 1.1
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.1
import Andromeda 1.0

Item {
    id: andromedaRoot
    property real aspectRatio: width/height
    property alias running: andromedaController.running
    width: 1080
    height: width/1.3333
    focus: true

    Andromeda {
        id: andromedaController
        property real state: 0
        property real stateDerivative: 1
        anchors.fill: parent
        running: true

        function moveCamera(newPos) {
            var edgeX1 = newPos.x + andromedaController.cameraPos.z
            var edgeY1 = newPos.y + andromedaController.cameraPos.z

            var edgeX2 = andromedaController.cameraPos.z - newPos.x
            var edgeY2 = andromedaController.cameraPos.z - newPos.y

            if(edgeX1 > 1.0) {
                newPos.x = 1.0 - andromedaController.cameraPos.z
            } else if(edgeX2 > 1.0) {
                newPos.x = andromedaController.cameraPos.z - 1.0
            }

            if(edgeY1 > 1.0) {
                newPos.y = 1.0 - andromedaController.cameraPos.z
            } else if(edgeY2 > 1.0) {
                newPos.y = andromedaController.cameraPos.z - 1.0
            }

            andromedaController.cameraPos.x = newPos.x
            andromedaController.cameraPos.y = newPos.y
        }

        Timer {
            id: timer
            property real lastTime: Date.now()
            property real lastSampleTime: Date.now()
            running: andromedaController.running
            repeat: true
            interval: 1
            onTriggered: {
                if(!andromedaController.previousStepCompleted) {
                    return
                }

                var currentTime = Date.now()
                var dt = currentTime - lastTime
                dt /= 1000
                andromedaController.step(dt)

                var sampleTimeDifference = (currentTime - lastSampleTime)/1000
                lastTime = currentTime
            }
        }
    }

    Keys.onPressed: {
        if(event.key === Qt.Key_1) {
            andromedaController.setRenderSky(!andromedaController.renderSky)
        } else if(event.key === Qt.Key_2) {
            andromedaController.setRenderAndromeda1x(!andromedaController.renderAndromeda1x)
        } else if(event.key === Qt.Key_3) {
            andromedaController.setRenderAndromeda2x(!andromedaController.renderAndromeda2x)
        } else if(event.key === Qt.Key_4) {
            andromedaController.setRenderAndromeda3x(!andromedaController.renderAndromeda3x)
        }
    }

    MouseArea {
        property real minZoom: 0.0002
        property real maxZoom: 1.0
        property real mouseStartX: 0.0
        property real mouseStartY: 0.0
        property real cameraStartX: 0.0
        property real cameraStartY: 0.0
        property bool rightButton: false
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        width: parent.width
        height: parent.height
        onWheel: {
            var mousePos = scaledMousePos(wheel)

            var oldZoom = andromedaController.cameraPos.z
            var newZoom = oldZoom*(1+wheel.angleDelta.y*0.001);
            if(newZoom < minZoom) newZoom = minZoom;
            if(newZoom > maxZoom) newZoom = maxZoom;

            var ratio = oldZoom
            // Mouse cursor image coordinates (scale invariant)
            var x = mousePos.x*ratio - andromedaController.cameraPos.x
            var y = mousePos.y*ratio - andromedaController.cameraPos.y
            // Distance to focus center
            var xFromFocus = x + andromedaController.cameraPos.x
            var yFromFocus = y + andromedaController.cameraPos.y

            var tanThetaX = xFromFocus / oldZoom
            var tanThetaY = yFromFocus / oldZoom
            var deltaZ = newZoom - oldZoom
            var deltaX = deltaZ*tanThetaX
            var deltaY = deltaZ*tanThetaY
            var newCameraPosX = andromedaController.cameraPos.x + deltaX
            var newCameraPosY = andromedaController.cameraPos.y + deltaY

            andromedaController.cameraPos.z = newZoom
            andromedaController.moveCamera(Qt.vector2d(newCameraPosX, newCameraPosY))
        }

        function scaledMousePos(mouse) {
            var mouseX = 2*( (mouse.x - 0.5*andromedaRoot.width) / andromedaRoot.width)
            var mouseY = 2*( (mouse.y - 0.5*andromedaRoot.height) / andromedaRoot.height)
            return Qt.vector2d(mouseX, mouseY)
        }

        onPressed: {
            rightButton = (mouse.button == Qt.RightButton)

            var mousePos = scaledMousePos(mouse);

            mouseStartX = mousePos.x
            mouseStartY = mousePos.y
            cameraStartX = andromedaController.cameraPos.x
            cameraStartY = andromedaController.cameraPos.y
        }

        function setState(state) {
            andromedaController.state = state
            if(state === 0) {
                andromedaController.setRenderAndromeda1x(false)
                andromedaController.setRenderAndromeda2x(false)
                andromedaController.setRenderAndromeda3x(false)
            } else if(state === 1) {
                andromedaController.setRenderAndromeda1x(true)
                andromedaController.setRenderAndromeda2x(false)
                andromedaController.setRenderAndromeda3x(false)
            } else if(state === 2) {
                andromedaController.setRenderAndromeda1x(true)
                andromedaController.setRenderAndromeda2x(true)
                andromedaController.setRenderAndromeda3x(false)
            } else if(state === 3) {
                andromedaController.setRenderAndromeda1x(true)
                andromedaController.setRenderAndromeda2x(true)
                andromedaController.setRenderAndromeda3x(true)
            }
        }

        onReleased: {
            var mousePos = scaledMousePos(mouse)
            var dx = mousePos.x - mouseStartX
            var dy = mousePos.y - mouseStartY
            var dr2 = dx*dx + dy*dy
            if(dr2 < 1e-5) {
                // Right click to reduce state
                var dir = rightButton ? -1 : 1

                var newState = andromedaController.state + andromedaController.stateDerivative*dir

                if(newState < 0) {
                    setState(1);
                    andromedaController.stateDerivative = 1;
                } else if (newState > 3) {
                    setState(2);
                    andromedaController.stateDerivative = -1;
                } else {
                    setState(newState)
                }
            }
        }

        onMouseXChanged: {
            var mousePos = scaledMousePos(mouse);

            var deltaX = (mousePos.x - mouseStartX)*andromedaController.cameraPos.z
            var deltaY = (mousePos.y - mouseStartY)*andromedaController.cameraPos.z

            var newCameraPosX = cameraStartX + deltaX
            var newCameraPosY = cameraStartY + deltaY
            andromedaController.moveCamera(Qt.vector2d(newCameraPosX, newCameraPosY))
        }
    }
}

