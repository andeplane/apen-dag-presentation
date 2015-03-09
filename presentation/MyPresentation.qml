//import Qt.labs.presentation 1.0
import QtQuick 2.2
import LatexPresentation 1.0
import QtQuick.Controls 1.1
import QtMultimedia 5.0
import QtGraphicalEffects 1.0
import "../modules/andromeda-viewer"
import "../qml"

TransitionPresentation
{
    id: presentation
    focus: true
    transitionTime: 500

    width: 1080
    height: 1080
    textColor: "black"

    RadialGradient {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#FFFFFF" }
            GradientStop { position: 1.0; color: "#f7f2d3" }
        }
    }


    // -----------------------------------------------
    // -----------  First Slide-----------------------
    // -----------------------------------------------
    Slide {
        id: firstSlide

        delayPoints: true
        DefaultImage {
            source: "../../figures/benzene.png"
        }
    }

    Slide {
        id: secondSlide

        AndromedaViewer {
            width: 1080
            height: 1080
        }
    }

}



