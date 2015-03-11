import QtQuick 2.0

Item {
    id: explainedRoot
    property var steps: [
        [[0, 0, 0], [1, 1, 1], [0, 0, 0]],
        [[0, 2, 0], [1, 1, 1], [0, 0, 0]],
        [[0, 2, 0], [1, 1, 1], [0, 2, 0]],
        [[0, 2, 0], [1, 2, 1], [0, 2, 0]],
        [[0, 2, 0], [3, 2, 1], [0, 2, 0]],
        [[0, 2, 0], [3, 2, 3], [0, 2, 0]],
        [[0, 1, 0], [0, 1, 0], [0, 1, 0]],
    ]
    property var cells: steps[step]
    property int step: 0

    width: 150
    height: 100

    Column {
        id: column
        anchors.centerIn: parent
        Grid {
            anchors.horizontalCenter: parent.horizontalCenter
            columns: 3
            rows: 3

            ExplainedRectangle {
                value: cells[0][0]
            }

            ExplainedRectangle {
                value: cells[0][1]
            }

            ExplainedRectangle {
                value: cells[0][2]
            }

            ExplainedRectangle {
                value: cells[1][0]
            }

            ExplainedRectangle {
                value: cells[1][1]
            }

            ExplainedRectangle {
                value: cells[1][2]
            }

            ExplainedRectangle {
                value: cells[2][0]
            }

            ExplainedRectangle {
                value: cells[2][1]
            }

            ExplainedRectangle {
                value: cells[2][2]
            }
        }

        Item {
            width: 100
            height: 100
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Levende med 0 eller 1 naboer dør.\n" +
                  "Levende med 2 eller 3 naboer overlever.\n" +
                  "Levende med 4 eller flere naboer dør.\n" +
                  "Død celle med 3 naboer gjenoppstår."
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

