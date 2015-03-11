import QtQuick 2.0

Item {
    id: explainedRoot
    property var steps: [
        [[0, 0, 0, 0, 0], [0, 0, 0, 0, 0], [0, 1, 1, 1, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0]],
        [[0, 0, 0, 0, 0], [0, 0, 2, 0, 0], [0, 1, 1, 1, 0], [0, 0, 0, 0, 0], [0, 0, 0, 0, 0]],
        [[0, 0, 0, 0, 0], [0, 0, 2, 0, 0], [0, 1, 1, 1, 0], [0, 0, 2, 0, 0], [0, 0, 0, 0, 0]],
        [[0, 0, 0, 0, 0], [0, 0, 2, 0, 0], [0, 1, 2, 1, 0], [0, 0, 2, 0, 0], [0, 0, 0, 0, 0]],
        [[0, 0, 0, 0, 0], [0, 0, 2, 0, 0], [0, 3, 2, 1, 0], [0, 0, 2, 0, 0], [0, 0, 0, 0, 0]],
        [[0, 0, 0, 0, 0], [0, 0, 2, 0, 0], [0, 3, 2, 3, 0], [0, 0, 2, 0, 0], [0, 0, 0, 0, 0]],
        [[0, 0, 0, 0, 0], [0, 0, 1, 0, 0], [0, 0, 1, 0, 0], [0, 0, 1, 0, 0], [0, 0, 0, 0, 0]],
    ]
    property var cells: steps[step]
    property int step: 0

    width: 150
    height: 100

    Column {
        id: column
        anchors.centerIn: parent
        Grid {
            id: grid
            anchors.horizontalCenter: parent.horizontalCenter
            columns: 5
            rows: 5

            Repeater {
                model: 25
                Rectangle {
                    property int value: cells[parseInt(index / grid.columns)][index % grid.columns]
                    width: height
                    height: explainedRoot.height / 2 / grid.rows
                    border.width: width / 20
                    border.color: "grey"
                    color: {
                        switch(value) {
                        case 0:
                            return "black"
                        case 1:
                            return "white"
                        case 2:
                            return "blue"
                        case 3:
                            return "red"
                        default:
                            return "green"
                        }
                    }
                }
            }
        }

        Item {
            width: 100
            height: 100
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "0 eller 1 naboer = død\n" +
                  "2 eller 3 naboer = overlevende\n" +
                  "4 eller flere naboer = død\n" +
                  "Død celle med 3 naboer gjenoppstår"
            font.pixelSize: explainedRoot.width * 0.03
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: {
            if(mouse.button === Qt.RightButton) {
                if(step - 1 < 0) {
                    step = steps.length - 1
                } else {
                    step -= 1
                }
            } else {
                if(step + 1 > steps.length - 1) {
                    step = 0
                } else {
                    step += 1
                }
            }
        }
    }
}

