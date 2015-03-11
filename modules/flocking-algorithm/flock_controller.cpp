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

#include "flock_controller.h"
#include "flock_renderer.h"

#include <functional>
#include <QtQuick/qquickwindow.h>
#include <QtGui/QOpenGLShaderProgram>
#include <QtGui/QOpenGLContext>
#include <QGLFormat>
#include <QOpenGLContext>
#include <iostream>
#include <cmath>
#include <QOpenGLFramebufferObjectFormat>
using namespace std;
namespace Flocking {
Controller::Controller()
    :
      m_running(true),
      m_stepRequested(false),
      m_previousStepCompleted(true),
      m_simulatorOutputDirty(false),
      m_lastStepWasBlocked(false),
      m_renderParticles(true)
{
    m_simulator.moveToThread(&m_simulatorWorker);
    connect(this, &Controller::requestStep, &m_simulator, &Simulator::step);
    connect(&m_simulator, &Simulator::stepCompleted, this, &Controller::finalizeStep);
    connect(this, &Controller::mousePositionChanged, &m_simulator, &Simulator::setMousePosition);
    m_simulatorWorker.start();
    m_timer.start();
}

Controller::~Controller()
{
    m_simulatorWorker.quit();
    m_simulatorWorker.wait();
}

Flocking::Renderer* Controller::createRenderer() const
{
    return new Flocking::Renderer();
}

void Controller::setRunning(bool arg)
{
    if (m_running == arg)
        return;

    m_running = arg;
    emit runningChanged(arg);
    update();
}

void Controller::step()
{
    if(!m_running) {
        return;
    }

    if(m_simulatorRunningMutex.tryLock()) {
        m_lastStepWasBlocked = false;
        emit requestStep();
    } else {
        m_lastStepWasBlocked = true;
    }
}

void Controller::updateData() {
    // Copy all positions from simulator and scale them
    m_visualData.mouseData.positions = { m_simulator.mousePosition };
    m_visualData.mouseData.scale = 0.2;
    m_visualData.billboardsData.scale = 0.03;
    m_visualData.billboardsData.positions = m_simulator.pos;
    m_visualData.billboardsData.rotation.resize(m_simulator.pos.size());
    for(unsigned int i=0; i<m_simulator.vel.size(); i++) {
        float rot = atan2(-m_simulator.vel[i][1], -m_simulator.vel[i][0]);
        m_visualData.billboardsData.rotation[i] = rot;
    }
}

void Controller::finalizeStep()
{

    m_simulatorOutputMutex.lock();

    // Write output from simulator
    updateData();

    m_previousStepCompleted = true;
    m_simulatorOutputDirty = true;
    m_simulatorOutputMutex.unlock();
    m_simulatorRunningMutex.unlock();
    update();

    if(m_lastStepWasBlocked) {
        m_lastStepWasBlocked = false;
        step();
    }
}

void Controller::handleWindowChanged(QQuickWindow *win)
{
    if (win) {
        //        connect(win, SIGNAL(beforeSynchronizing()), this, SLOT(sync()), Qt::DirectConnection);
        //        connect(win, SIGNAL(sceneGraphInvalidated()), this, SLOT(cleanup()), Qt::DirectConnection);
        // If we allow QML to do the clearing, they would clear what we paint
        // and nothing would show.
        win->setClearBeforeRendering(false);
    }
}

// ********************************************
// ******* Basic setters and getters **********
// ********************************************

void Controller::setPreviousStepCompleted(bool arg)
{
    if (m_previousStepCompleted != arg) {
        m_previousStepCompleted = arg;
        emit previousStepCompletedChanged(arg);
    }
}

void Controller::setSimulatorOutputDirty(bool arg)
{
    m_simulatorOutputDirty = arg;
}

bool Controller::running() const
{
    return m_running;
}

bool Controller::previousStepCompleted() const
{
    return m_previousStepCompleted;
}

bool Controller::simulatorOutputDirty() const
{
    return m_simulatorOutputDirty;
}
}
