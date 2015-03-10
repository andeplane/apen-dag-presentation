import QtQuick 2.0

Rectangle {
    id: gameRoot
    property bool running: false

    width: 100
    height: 62
    focus: true

    Rectangle {
        id: rect
        anchors.fill: parent
        color: "black"
    }

    Column {
        Rectangle {
            width: 100
            height: 100
            color: "lightgreen"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    gameRoot.running = !gameRoot.running
                }
            }
        }

        Rectangle {
            width: 100
            height: 100
            color: "lightblue"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    stepTimer.clearTime = Date.now()
                }
            }
        }
    }

    ShaderEffectSource {
        id: effectSource
        sourceItem: rect
        recursive: true
        live: false
        smooth: false
        antialiasing: false
    }

    ShaderEffect {
        id: effect
        property real time: 0
        property vector2d resolution: Qt.vector2d(width, height)
        property vector2d mouse: Qt.vector2d(50, 50)
        property var backbuffer: effectSource
        property bool autoDraw: false
        property bool doStep: false

        smooth: false
        antialiasing: false

        width: 100
        height: 100
        vertexShader: "
            uniform highp mat4 qt_Matrix;
            attribute highp vec4 qt_Vertex;
            attribute highp vec2 qt_MultiTexCoord0;
            varying highp vec2 coord;
            void main() {
                coord = qt_MultiTexCoord0;
                gl_Position = qt_Matrix * qt_Vertex;
            }"

        fragmentShader: "
            // adapted from http://glsl.herokuapp.com/e#207.3
            uniform float time;
            uniform vec2 mouse;
            uniform vec2 resolution;
            uniform sampler2D backbuffer;
            uniform bool autoDraw;
            uniform bool doStep;
            varying vec2 coord;

            vec4 live = vec4(0.5,1.0,0.7,1.);
            vec4 dead = vec4(0.,0.,0.,1.);
            vec4 blue = vec4(0.,0.,1.,1.);

            void main( void ) {
                vec2 position = ( coord.xy );
                vec2 mousePosition = (mouse.xy);
                vec2 pixel = 1./resolution;

                if(autoDraw) {
//                    if(length(position - mousePosition) < pixel.x*10.0) {
//                        float rnd1 = mod(fract(sin(dot(position + time * 0.001, vec2(14.9898,78.233))) * 43758.5453), 1.0);
//                        if (rnd1 > 0.5) {
//                            gl_FragColor = live;
//                            return;
//                        }
//}
                    if(length(position - mousePosition) < pixel.x*0.51) {
                        gl_FragColor = live;
                        return;
                    }
                }
                if(doStep) {
                    float sum = 0.;
                    sum += texture2D(backbuffer, position + pixel * vec2(-1., -1.)).g;
                    sum += texture2D(backbuffer, position + pixel * vec2(-1., 0.)).g;
                    sum += texture2D(backbuffer, position + pixel * vec2(-1., 1.)).g;
                    sum += texture2D(backbuffer, position + pixel * vec2(1., -1.)).g;
                    sum += texture2D(backbuffer, position + pixel * vec2(1., 0.)).g;
                    sum += texture2D(backbuffer, position + pixel * vec2(1., 1.)).g;
                    sum += texture2D(backbuffer, position + pixel * vec2(0., -1.)).g;
                    sum += texture2D(backbuffer, position + pixel * vec2(0., 1.)).g;
                    vec4 me = texture2D(backbuffer, position);

                    if (me.g <= 0.1) {
                        if ((sum >= 2.9) && (sum <= 3.1)) {
                            gl_FragColor = live;
                            return;
                        } else if (me.b > 0.004) {
                            gl_FragColor = vec4(0., 0., max(me.b - 0.004, 0.25), 1.);
                            return;
                        } else {
                            gl_FragColor = dead;
                            return;
                        }
                    } else {
                        if ((sum >= 1.9) && (sum <= 3.1)) {
                            gl_FragColor = live;
                            return;
                        } else {
                            gl_FragColor = blue;
                            return;
                        }
                    }
                }
                gl_FragColor = texture2D(backbuffer, position);
            }
        "
    }

    ShaderEffectSource {
        sourceItem: effect
        //        anchors.fill: parent

        width: effect.width
        height: effect.height

        scale: Math.min(parent.width / width, parent.height / height)
        transformOrigin: Item.Center

        anchors.centerIn: parent
        smooth: false
        antialiasing: false
        hideSource: true

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onPositionChanged: {
                effect.mouse.x = mouse.x / width
                effect.mouse.y = mouse.y / height
            }
            onPressed: {
                effect.autoDraw = true
            }
            onReleased: {
                effect.autoDraw = false
            }
            onWheel: {
                if(wheel.angleDelta.y > 0) {
                    effect.width += 10
                    effect.height += 10
                } else {
                    effect.width = Math.max(10, effect.width-10)
                    effect.height = Math.max(10, effect.height - 10)
                }
            }
        }
    }

    Keys.onPressed: {
        if(event.key === Qt.Key_E) {
            effect.autoDraw = !effect.autoDraw
        }
        if(event.key === Qt.Key_Space) {
            effect.running = !effect.running
        }
    }

    Timer {
        id: stepTimer
        property real clearTime: Date.now()
        property real stepTime: Date.now()

        running: true
        repeat: true
        interval: 1
        onTriggered: {
            var currentTime = Date.now()
            effectSource.scheduleUpdate()
            effect.time += 1
            if(currentTime - clearTime > 1000) {
                effectSource.sourceItem = effect
            } else {
                effectSource.sourceItem = rect
            }
            if(gameRoot.running && currentTime - stepTime > 100) {
                effect.doStep = true
                stepTime = currentTime
            } else {
                effect.doStep = false
            }
        }
    }
}

