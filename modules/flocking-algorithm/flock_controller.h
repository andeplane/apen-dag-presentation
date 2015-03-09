/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the demonstration applications of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.  For licensing terms and
** conditions see http://qt.digia.com/licensing.  For further information
** use the contact form at http://qt.digia.com/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Digia gives you certain additional
** rights.  These rights are described in the Digia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met: http://www.gnu.org/copyleft/gpl.html.
**
**
** $QT_END_LICENSE$
**
****************************************************************************/

#pragma once

#include <QtQuick/QQuickItem>
#include <QtGui/QOpenGLShaderProgram>
#include <QElapsedTimer>
#include <QMatrix4x4>
#include <QQuickFramebufferObject>
#include <QThread>
#include <QMutex>
#include "flock_simulator.h"
#include "flock_renderer.h"
namespace Flocking {
class Controller : public QQuickFramebufferObject
{
    Q_OBJECT
    Q_PROPERTY(bool running READ running WRITE setRunning NOTIFY runningChanged)
    Q_PROPERTY(bool previousStepCompleted READ previousStepCompleted NOTIFY previousStepCompletedChanged)
    Q_PROPERTY(bool renderParticles READ renderParticles WRITE setRenderParticles NOTIFY renderParticlesChanged)
    Q_PROPERTY(QVector2D mousePosition READ mousePosition WRITE setMousePosition NOTIFY mousePositionChanged)
public:
    Controller();
    ~Controller();

    Flocking::Renderer* createRenderer() const;

    Q_INVOKABLE void step();

    bool running() const;
    bool previousStepCompleted() const;
    bool simulatorOutputDirty() const;

    std::vector<QVector2D> m_positions;
    bool renderParticles() const
    {
        return m_renderParticles;
    }

    QVector2D mousePosition() const
    {
        return m_mousePosition;
    }

public slots:
    void setRunning(bool arg);
    void setPreviousStepCompleted(bool arg);
    void setSimulatorOutputDirty(bool arg);
    void createBird() {
        m_simulator.createBird();
    }

    void addObstacle(QVector2D pos) {
        m_simulator.addObstacle(pos);
    }

    void setRenderParticles(bool arg)
    {
        if (m_renderParticles == arg)
            return;

        m_renderParticles = arg;
        emit renderParticlesChanged(arg);
    }

    void setMousePosition(QVector2D arg)
    {
        if (m_mousePosition == arg)
            return;

        m_mousePosition = arg;
        emit mousePositionChanged(arg);
    }

private slots:
    void finalizeStep();

signals:
    void runningChanged(bool arg);
    void previousStepCompletedChanged(bool arg);
    void requestStep();

    void renderParticlesChanged(bool arg);

    void mousePositionChanged(QVector2D arg);

private slots:
    void handleWindowChanged(QQuickWindow *win);

private:

    Flocking::Renderer *m_renderer;
    Flocking::VisualData m_visualData;
    Simulator m_simulator;
    QElapsedTimer m_timer;
    bool m_running;

    bool m_stepRequested;
    bool m_previousStepCompleted;

    bool m_simulatorOutputDirty;
    bool m_lastStepWasBlocked;

    QMutex m_simulatorInputMutex;
    QMutex m_simulatorOutputMutex;
    QMutex m_simulatorRunningMutex;
    QThread m_simulatorWorker;
    friend class Flocking::Renderer;
    void scalePosition(QVector2D &position);
    void updateData();
    bool m_renderParticles;
    QVector2D m_mousePosition;
};
}
