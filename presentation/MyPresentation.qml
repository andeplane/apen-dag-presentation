//import Qt.labs.presentation 1.0
import QtQuick 2.2
import LatexPresentation 1.0
import QtQuick.Controls 1.1
import QtMultimedia 5.0
import QtGraphicalEffects 1.0
import "../modules/andromeda-viewer"
import "../modules/flocking-algorithm"
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

    Slide {
        id: firstSlide
        centeredText: "Nerver, hjernen og teknologi:\n" +
                      "Forstå hjernen med programmering"
        Text {
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            font.family: firstSlide.titleFontFamily
            font.pixelSize: firstSlide._titleFontSize * 0.5
            lineHeight: 1.2
            horizontalAlignment: Text.Center
            wrapMode: Text.Wrap
            text: "Anders Hafreager og Svenn-Arne Dragly\nMars 2015"
        }
    }

    Slide {
        id: universeLarge
        centeredText: "Universet er et stort sted..."
    }

    Slide {
        id: andromedaSlide

        AndromedaViewer {
            id: andromeda
            running: currentSlide === andromedaSlide
            width: 1080
            height: 1080
        }
    }

    Slide {
        centeredText: "Game of Life"
    }

    Slide {
        GameOfLifeExplained {
            anchors.fill: parent
        }
    }

    Slide {
        DefaultImage {
            source: "../figures/glider.gif"
        }
    }

    Slide {
        AnimatedImage {
            anchors.fill: parent
            anchors.margins: parent.width * 0.1
            fillMode: Image.PreserveAspectFit
            antialiasing: true
            smooth: true
            source: "../figures/glider.gif"
        }
    }

    Slide {
        id: gameOfLifeSlide
        fullSlide: true
        GameOfGLSL {
            isCurrent: currentSlide === gameOfLifeSlide
            anchors.fill: parent
        }
    }

    Slide {
        centeredText: "Flokker"
    }

    Slide {
        id: flockingSlide
        Flocking {
            id: flocking
            running: currentSlide === flockingSlide
            width: 1080
            height: 1080
        }
    }

    Slide {
        DefaultImage {
            source: "../figures/brain.png"
        }
    }

    Slide {
        DefaultImage {
            source: "../figures/neuron.jpg"
        }
    }

    Slide {
        centeredText: "10¹¹ nerveceller\n10¹⁴ koblinger"
    }

    Slide {
        centeredText: "100 000 000 000 000 koblinger"
    }

    Slide {
        centeredText: "Neuronify"
    }

    Slide {
        DefaultImage {
            source: "../figures/neuron-diagram.png"
        }
    }

    Slide {
        bullets: [
            "Ingen hjerneceller er like",
            "Det er veldig mange av dem"
        ]
    }

    Slide {
        centeredText: "Regnekraft dagens PC:\n10¹⁰ per sekund"
    }

    Slide {
    }

}



