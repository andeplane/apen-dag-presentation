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
        id: ensjo
        TopText {
            text: "Langt å gå til Blindern"
            font.pixelSize: defaultFontSize*0.75
        }

        DefaultImage {
            source: "../figures/osloensjo.png"
        }
    }

    Slide {
        id: moon1
        TopText {
            text: "Langt å fly til månen..."
            font.pixelSize: defaultFontSize*0.75
        }

        DefaultImage {
            source: "../figures/earthmoon2.jpg"
        }
    }

    Slide {
        id: andromedaSlide

//        AndromedaViewer {
//            id: andromeda
//            anchors.horizontalCenter: parent.horizontalCenter
//            running: currentSlide === andromedaSlide
//            width: 1080
//        }

        title: "Andromeda"
    }

    Slide {
        Text {
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            font.family: firstSlide.titleFontFamily
            font.pixelSize: firstSlide._titleFontSize * 0.5
            horizontalAlignment: Text.Center

            text: "Hvis Andromeda hadde lyst sterkere..."
        }

        DefaultImage {
            source: "../figures/andromedaMoon.png"
        }
    }

    Slide {
        Text {
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            font.family: firstSlide.titleFontFamily
            font.pixelSize: firstSlide._titleFontSize * 0.5
            horizontalAlignment: Text.Center

            text: "Universet er skikkelig stort..."
        }

        DefaultImage {
            source: "../figures/universeSize.jpg"
        }
    }

    Slide {
        title: "Universets regler"
        Latex {
            width: parent.width*0.5
            text: "$$ G_{\\mu \\nu} - \\Lambda g_{\\mu \\nu} = 8\\pi T_{\\mu \\nu} $$"
        }
    }

    Slide {
        id: nicolaasSlide
        Video {
            id: nicolaasVideo
            anchors.fill: parent
            source: "../videos/mmBody.mp4"
            autoLoad:  true
            property bool running: nicolaasSlide === presentation.currentSlide
            onRunningChanged: {
                if(running) {
                    nicolaasVideo.play()
                } else {
                    nicolaasVideo.pause()
                }
            }

        }
    }

    Slide {
        centeredText: "Conway's Game of Life"
    }

    Slide {
        GameOfLifeExplained {
            anchors.fill: parent
        }
    }

//    Slide {
//        DefaultImage {
//            source: "../figures/glider.gif"
//        }
//    }

//    Slide {
//        AnimatedImage {
//            anchors.fill: parent
//            anchors.margins: parent.width * 0.1
//            fillMode: Image.PreserveAspectFit
//            antialiasing: true
//            smooth: true
//            source: "../figures/glider.gif"
//        }
//    }

    Slide {
        id: gameOfLifeSlide
        fullSlide: true
        GameOfGLSL {
            isCurrent: currentSlide === gameOfLifeSlide
            anchors.fill: parent
        }
    }

    Slide {
        TopText {
            text: "Fugleflokker"
        }
    }

    Slide {
        id: flockingSlide
        Flocking {
            id: flocking
            running: currentSlide === flockingSlide
            width: 1080
        }
    }

    Slide {
        DefaultImage {
            id: brainImage
            source: "../figures/brain.png"
            Behavior on scale {
                NumberAnimation {
                    duration: 4000
                    easing.type: Easing.InOutSine
                }
            }
        }
        DefaultImage {
            id: neuronImage
            source: "../figures/neuron.jpg"
            scale: 0.001
            Behavior on scale {
                NumberAnimation {
                    duration: 4000
                    easing.type: Easing.InOutSine
                }
            }
        }
        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: {
                if(mouse.button === Qt.LeftButton) {
                    brainImage.scale = 1000
                    neuronImage.scale = 1
                } else {
                    brainImage.scale = 1
                    neuronImage.scale = 0.001
                }
            }
        }
    }

    Slide {
    }

    Slide {
        centeredText: "10¹¹ nerveceller\n10¹⁴ koblinger"
    }

    Slide {
        centeredText: "100 000 000 000 000 koblinger"
    }

    Slide {
        title: "Neuronify"
        DefaultImage {
            source: "../figures/neuronify.png"
        }
    }

    Slide {
        DefaultImage {
            source: "../figures/neuron-diagram.png"
        }
    }

//    Slide {
//        centeredText: "Regnekraft dagens PC:\n10¹⁰ per sekund"
//    }

    Slide {
        id: atomifySlide
        title: "Atomify"
        DefaultImage {
            source: "../figures/atomify.png"
        }
    }

    Slide {
    }

}



