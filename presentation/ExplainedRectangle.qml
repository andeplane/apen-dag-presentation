import QtQuick 2.0

Rectangle {
    property int value: 0
    width: 100
    height: 100
    border {
        width: 10
        color: "grey"
    }
    color: {
        switch(value) {
        case 0:
            return "white"
        case 1:
            return "black"
        case 2:
            return "blue"
        case 3:
            return "red"
        }
    }
}

