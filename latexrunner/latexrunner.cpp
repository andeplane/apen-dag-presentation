#include "latexrunner.h"

#include <QCryptographicHash>
#include <QFileInfo>
#include <QDir>
#include <QFile>

LatexRunner::LatexRunner(QQuickItem *parent) :
    QQuickItem(parent),
    m_dpi(3600),
    m_forceCompile(false)
{
}

QString LatexRunner::createFormula(QString formula, QString color, bool centered)
{
    // TODO use QProcess instead of system()
    // TODO use Qt to create directories

    QString tmpDirName = "/tmp/latexpresentation/";
    QString baseFileData = formula + color + QString(centered) + QString(dpi());
    QString baseFileName = QCryptographicHash::hash(baseFileData.toLatin1(), QCryptographicHash::Md5).toHex();
    QString myFormulaFileName = tmpDirName + baseFileName + ".tex";

    QDir tempDir(tmpDirName);
    if(!tempDir.exists()) {
        QDir().mkdir(tmpDirName);
    }

    QFile templateFile("latex/formula.tex");

    QString templateTargetFileName = tmpDirName + "/formula.tex";
    QFile templateTargetFile(templateTargetFileName);
    if(templateTargetFile.exists()) {
        templateTargetFile.remove();
    }
    if(!templateFile.copy(templateTargetFileName)) {
        qWarning() << "Could not copy template file for formula" << formula << "\n"
                   << "Error: " << templateFile.errorString();
    }

    QString imageFileName = tmpDirName + baseFileName + ".png";
    QString returnFileName = "file://" + imageFileName;
    QFile imageFile(imageFileName);
    if(imageFile.exists() && !forceCompile()) {
        return returnFileName;
    } else {
        qDebug() << "Creating formula for the first time: " << formula;
        QFile myFormulaFile(myFormulaFileName);
        myFormulaFile.open(QIODevice::WriteOnly | QIODevice::Text);
        myFormulaFile.write(formula.toUtf8());
        myFormulaFile.close();

        QString centerCommand = "";
        if(centered) {
            centerCommand = "\\def \\mycentered{} ";
        }
#ifdef LINUX
        QString latexCommand = "pdflatex -interaction=nonstopmode --jobname formula \"" + centerCommand + "\\def \\mycolor{" + color + "} \\def \\myfile{" + myFormulaFileName + "} \\input{" + templateTargetFileName + "}\"";
#else
        QString latexCommand = "/usr/texbin/pdflatex -interaction=nonstopmode --jobname formula \"" + centerCommand + "\\def \\mycolor{" + color + "} \\def \\myfile{" + myFormulaFileName + "} \\input{" + templateTargetFileName + "}\"";
#endif
        qDebug() << latexCommand;
        system(latexCommand.toStdString().c_str());
#ifdef LINUX
        QString convertCommand = "convert -trim -density " + dpi() + " formula.pdf -quality 90 " + imageFileName;
#else
        QString convertCommand = "/usr/bin/sips -s format png formula.pdf --out " + imageFileName;
#endif

        system(convertCommand.toStdString().c_str());
        qDebug() << "Done creating formula.";
    }

    return returnFileName;
}
