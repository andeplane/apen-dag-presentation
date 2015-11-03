import QtQuick 2.0
import QtQuick.Window 2.2

Rectangle {
    id: gameRoot
    property bool isCurrent: false
    property bool running: false
    property int rowCount: 60
    property int columnCount: 60

    width: 100
    height: 62
    focus: true

    color: "black"

    onIsCurrentChanged: {
        if(isCurrent) {
            gameRoot.forceActiveFocus()
        }
    }

    function clear() {
        stepTimer.clearTime = Date.now()
        canvas.cells = [[]]
        for(var i = 0; i < rowCount; i++) {
            canvas.cells[i] = []
            for(var j = 0; j < columnCount; j++) {
                canvas.cells[i][j] = 0
            }
        }
        canvas.requestPaint()
    }

    function patternCount(pattern) {
        var row = 0
        var col = 0
        var maxCol = 0
        for(var i in pattern) {
            var character = pattern[i]
            col += 1
            if(character === "\n") {
                maxCol = Math.max(col, maxCol)
                col = 0
                row += 1
            }
        }
        return [row, maxCol]
    }

    function loadPattern(pattern) {
        effectSource.sourceItem = rect
        var patternRowColumnCount = patternCount(pattern)
        var patternRowCount = patternRowColumnCount[0]
        var patternColumnCount = patternRowColumnCount[1]
        var rowOffset = parseInt((rowCount - patternRowCount) / 2)
        var columnOffset = parseInt((columnCount - patternColumnCount) / 2)
        clear()
        var row = rowOffset
        var column = columnOffset
        for(var i in pattern) {
            var character = pattern[i]
            if(character === "*" && row >= 0 && column >= 0 && row < rowCount && column < columnCount) {
                canvas.cells[row][column] = 1
            }

            column += 1
            if(character === "\n") {
                column = columnOffset
                row += 1
            }
        }
        canvas.requestPaint()
    }

    Rectangle {
        id: rect

        color: "black"

        width: columnCount
        height: rowCount

        Canvas {
            id: canvas
            property string pattern
            property var cells: [[]]

            anchors.centerIn: parent

            transformOrigin: Item.Center

            smooth: false
            antialiasing: false

            width: columnCount
            height: rowCount
            onPaint: {
                var ctx = canvas.getContext("2d")
                ctx.save();
                ctx.clearRect(0, 0, canvas.width, canvas.height);
                var imageData = ctx.createImageData(rowCount, columnCount)

                var data = imageData.data

                for(var i = 0; i < rowCount; i++) {
                    for(var j = 0; j < columnCount; j++) {
                        var index = i*columnCount*4 + j*4
                        var value = 0
                        if(cells[i][j] > 0) {
                            value = 255
                        }

                        data[index + 0] = value
                        data[index + 1] = value
                        data[index + 2] = value
                        data[index + 3] = 255
                    }
                }
                ctx.drawImage(imageData, 0, 0)

                ctx.restore();
            }
        }
    }

    Keys.onPressed: {
        if(event.key === Qt.Key_R) {
            gameRoot.running = !gameRoot.running
        }
        if(event.key === Qt.Key_T) {
           clear()
        }
    }

    ShaderEffectSource {
        id: effectSource
        sourceItem: rect
        recursive: true
        live: false
        smooth: false
        antialiasing: false
        hideSource: true
    }

    ShaderEffect {
        id: effect
        property real time: 0
        property int timeStep: parseInt(time)
        property vector2d resolution: Qt.vector2d(width * Screen.devicePixelRatio, height * Screen.devicePixelRatio)
        property vector2d mouse: Qt.vector2d(50, 50)
        property var backbuffer: effectSource
        property bool autoDraw: false
        property bool doStep: gameRoot.running && !autoDraw && isCurrent

        smooth: false
        antialiasing: false

        width: columnCount
        height: rowCount
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
            uniform int timeStep;
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
            onPositionChanged: {
                effect.mouse.x = mouse.x / width
                effect.mouse.y = mouse.y / height
                effectSource.scheduleUpdate()
            }
            onPressed: {
                effect.mouse.x = mouse.x / width
                effect.mouse.y = mouse.y / height
                effect.autoDraw = true
            }
            onReleased: {
                effect.autoDraw = false
            }

            onWheel: {
                if(wheel.angleDelta.y > 0) {
                    rowCount += 10
                    columnCount += 10
                } else {
                    rowCount = Math.max(10, effect.width-10)
                    columnCount = Math.max(10, effect.height - 10)
                }
                clear()
            }
        }
    }

    Timer {
        id: stepTimer
        property real clearTime: Date.now()
        property real stepTime: Date.now()

        running: isCurrent
        repeat: true
        interval: 100
        onTriggered: {
            var currentTime = Date.now()
            effectSource.scheduleUpdate()
            effect.time += 1
            if(currentTime - clearTime > 1000) {
                effectSource.sourceItem = effect
            } else {
                effectSource.sourceItem = rect
            }
        }
    }
}
