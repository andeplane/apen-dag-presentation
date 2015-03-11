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
        id: ngc7331
        title:  "NGC7331"

        DefaultImage {
            source: "../figures/NGC7331_hafreager_gboom.jpg"
        }
    }

    Slide {
        id: andromedaSlide

        AndromedaViewer {
            y: 100
            id: andromeda
            anchors.horizontalCenter: parent.horizontalCenter
            running: currentSlide === andromedaSlide
            width: 1080
        }

        TopText {
            text: "Andromeda"
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
        delayedContent: [
            Latex {
                scale: 0.5
                id: latex1
                text: "Venstreside = høyreside"
            },
            Latex {
                id: latex2
                anchors.top: latex1.bottom
                text: "Krumning = Energi og bevegelsesmengde"
            },
            Latex {
                scale: 0.8
                id: latex3
                anchors.top: latex2.bottom
                text: "$$ G_{\\mu \\nu} - \\Lambda g_{\\mu \\nu} = 8\\pi T_{\\mu \\nu} $$"
            }
        ]
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
        title: "Hva vi vet på ulike skalaer"
    }

    Slide {
        title: "Fysikere og biologer i samarbeid"
        DefaultImage {
            source: "../figures/cinpla.png"
        }
    }

    Slide {
        id: nobelprisSlide
        title: "Nobelprisen 2014\nKeefe, Moser & Moser"
        Row {
            anchors.fill: parent
            anchors.margins: parent.width * 0.1
            Image {
                height: parent.height
                width: parent.width / 2
                source: "../figures/keefe.jpg"
                anchors.margins: parent.width * 0.1
                fillMode: Image.PreserveAspectFit
                antialiasing: true
                smooth: true
            }
            Image {
                height: parent.height
                width: parent.width / 2
                source: "../figures/moser.jpg"
                anchors.margins: parent.width * 0.1
                fillMode: Image.PreserveAspectFit
                antialiasing: true
                smooth: true
            }
        }
    }

    Slide {
        id: fyhnSlide
        title: "Tre artikler om stedssansen"
        Row {
            anchors.fill: parent
            anchors.margins: parent.width * 0.1
            Image {
                height: parent.height
                width: parent.width / 3
                source: "../figures/marianne.jpg"
                anchors.margins: parent.width * 0.1
                fillMode: Image.PreserveAspectFit
                antialiasing: true
                smooth: true
            }
            Image {
                height: parent.height
                width: parent.width / 3
                source: "../figures/torkel.jpg"
                anchors.margins: parent.width * 0.1
                fillMode: Image.PreserveAspectFit
                antialiasing: true
                smooth: true
            }
            Item {
                height: parent.height
                width: parent.width / 3
                Image {
//                    height: parent.height
                    width: parent.width * 0.8
                    source: "../figures/article1.png"
                    fillMode: Image.PreserveAspectFit
                    antialiasing: true
                    smooth: true
                }
                Image {
                    x: parent.width * 0.1
                    y: parent.height * 0.3
//                    height: parent.height
                    width: parent.width * 0.8
                    source: "../figures/article2.png"
                    fillMode: Image.PreserveAspectFit
                    antialiasing: true
                    smooth: true
                }
                Image {
                    x: parent.width * 0.2
                    y: parent.height * 0.6
//                    height: parent.height
                    width: parent.width * 0.8
                    source: "../figures/article3.png"
                    fillMode: Image.PreserveAspectFit
                    antialiasing: true
                    smooth: true
                }
            }
        }
    }

    Slide {
    }

}



