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

    width: 1280
    height: 720
    textColor: "black"

    Rectangle {
        anchors.fill: parent
        color: "#f7f2d3"
    }

    Slide {
        id: firstSlide
        title: "Nerver, hjernen og teknologi:\n" +
               "Forstå hjernen med programmering"

        credit: "Foto: Milad H. Mobarhan"

        DefaultImage {
            source: "../figures/brainTissue.png"
            anchors.margins: 0
        }

        Text {
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            font.family: firstSlide.titleFontFamily
            font.pixelSize: firstSlide._titleFontSize * 0.5
            lineHeight: 1.2
            horizontalAlignment: Text.Center
            wrapMode: Text.Wrap
            text: "Anders Hafreager og Svenn-Arne Dragly, November 2015"
        }
    }

    Slide {
        id: universeLarge
        centeredText: "Universet er et stort sted..."
    }

    Slide {
        id: ensjo
        title: "Langt å gå til Blindern"

        DefaultImage {
            source: "../figures/osloensjo.png"
        }
    }

    Slide {
        id: moon1
        title: "Langt å fly til månen..."

        DefaultImage {
            source: "../figures/earthmoon2.jpg"
        }
    }

    Slide {
        id: ngc7331
        title:  "NGC7331"

        DefaultImage {
            scale: 1.3
            source: "../figures/NGC7331_hafreager_gboom.jpg"
        }
        credit: "Foto: Anders Hafreager"
    }

    Slide {
        id: andromedaSlide
        title: "Andromeda"

        AndromedaViewer {
            id: andromeda
            height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            running: currentSlide === andromedaSlide
        }
        credit: "Foto: Cory Poole, NASA (PD)"
    }

    Slide {
        title: "Hvis Andromeda hadde lyst sterkere..."
        titleFont.pixelSize: _fontSize*0.75

        DefaultImage {
            source: "../figures/andromeda.png"
        }
        credit: "Foto: Stephen Rahn (CC by-sa), NASA (PD)"
    }

    Slide {
        title: "Universets regler"
        delayedContent: [
            DefaultImage {
                source: "../figures/venstre1.png"
            },
            DefaultImage {
                source: "../figures/venstre2.png"
            },
            DefaultImage {
                source: "../figures/venstre3.png"
            }
        ]
    }

    Slide {
        id: nicolaasSlide
        credit: "Video: Nicolaas E. Groeneboom"
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

            onStatusChanged: {
                if(nicolaasVideo.status === MediaPlayer.EndOfMedia)
                {
                    nicolaasVideo.play();
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

    Slide {
        id: gameOfLifeSlide
        fullSlide: true
        focus: true
        GameOfGLSL {
            id: gameGLSL
            isCurrent: currentSlide === gameOfLifeSlide
            anchors.fill: parent
            focus: true
            onIsCurrentChanged: {
                forceActiveFocus()
            }
        }
        MouseArea {
            anchors.fill: parent
            propagateComposedEvents: true
            onPressed: {
                gameGLSL.forceActiveFocus()
                gameGLSL.focus = true
                mouse.accepted = false
            }
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
            anchors.horizontalCenter: parent.horizontalCenter

            height: presentation.height
        }
    }

    Slide {
        title: "Hvordan simulere hele hjernen?"
        DefaultImage {
            id: brainImage
            source: "../figures/brain2.png"
            Behavior on scale {
                NumberAnimation {
                    duration: 4000
                    easing.type: Easing.InOutSine
                }
            }
        }
        credit: "Foto: Svenn-Arne Dragly (CC by-sa), A. M. Winkler (CC by-sa)"
    }

    Slide {
        id: neuroVideoSlide
        title: "Simulering av nerveceller"
        Video {
            property bool shouldPlay: currentSlide === neuroVideoSlide

            onShouldPlayChanged: {
                if(shouldPlay) {
                    play()
                } else {
                    pause()
                }
            }

            autoLoad: true
            onStopped: {
                console.log("STOPPED")
                seek(0)
                play()
            }

            anchors.fill: parent
            source: "../videos/neurons.mp4"
        }
        credit: "Video: Espen Hagen"
    }

    Slide {
        title: "Synapser og molekyler"
        DefaultImage {
            source: "../figures/synapse.jpg"
        }
        credit: "Foto: Miserlou (via Wikipedia)"
    }

    Slide {
        id: atomifySlide
        title: "Atomify"
        DefaultImage {
            source: "../figures/atomify.png"
        }
    }

    Slide {
        centeredText: "Takk for oss!"
    }

}



