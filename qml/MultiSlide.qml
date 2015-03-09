import QtQuick 2.0

Slide {
    id: root
    anchors {
        topMargin: 0
        bottomMargin: 0
        leftMargin: 0
        rightMargin: 0
    }

    default property alias contentChildren: root.children
}
