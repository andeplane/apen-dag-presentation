latex-presentation
==================

Based on the QML Presentation System, now with LaTeX formulas

# Prerequisites #

* Qt > v4.7.4 (typically download and install Qt SDK from http://qt.nokia.com/ or install Qt with your package manager)
* PDFLaTeX must be available from PATH (The easiest is to install TeXLive on your machine)
* Standalone.sty LaTeX package. This can be downloaded directly from here: http://mirrors.ctan.org/install/macros/latex/contrib/standalone.tds.zip
Unzip this in your /home/username/texmf folder so that you get the /home/username/texmf/tex/latex/standalone folder in there.
Or you may see this post for more information on how to install using tlmgr in Ubuntu:
http://askubuntu.com/questions/100929/how-to-install-latex-package-called-standalone-properly-so-i-can-get-update-wi

# Usage #

Open the project in Qt Creator and enable Shadow Building (or edit the files manually).
Open the qml/latexpresentation/MyPresentation.qml file.
Edit it to suit your needs.
Build and run the project from Qt Creator or create a new folder next to the root directory (where latexpresentation.pro is) and run 
`qmake ../latex-presentation/latexpresentation.pro && make && ./latexpresentation`
in this directory


# Andromeda images #
Download the high resolution images from here: https://dl.dropboxusercontent.com/u/9786132/andromeda.zip Unzip images into source folder (relative path from executable needs to be ../apen-dag-presentation/*.jpg)

# Atomify video #

Download the Atomify video from here: https://www.dropbox.com/s/torv2xz6t0icplh/atomify.mp4?dl=1
Store it in the videos folder.

# Neurons video #

Download from https://dl.dropboxusercontent.com/u/4726365/neurons.mp4
