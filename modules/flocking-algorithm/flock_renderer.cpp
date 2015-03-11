#include "flock_renderer.h"
#include "flock_controller.h"
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

void Renderer::synchronize(QQuickFramebufferObject* item)
{
    m_syncCount++;
    Controller *controller = (Controller*)item; // TODO: Use correct casting method
    if(!controller) {
        return;
    }

    if(controller->simulatorOutputDirty()) {
        controller->m_simulatorOutputMutex.lock();
        // Read output
        m_data.billboardsData = controller->m_visualData.billboardsData;
        m_data.mouseData = controller->m_visualData.mouseData;

        m_billboards->update(m_data.billboardsData);
        m_scaryBird->update(m_data.mouseData);

        controller->setSimulatorOutputDirty(false);
        controller->m_simulatorOutputMutex.unlock();
        m_dirtyCount++;
    }
}

void Renderer::render()
{
    m_renderCount++;
    glDepthMask(true);

    glClearColor(1.0, 1.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    glDisable(GL_DEPTH_TEST);
    // Render data
    m_billboards->render();
    m_scaryBird->render();
}


Renderer::Renderer() :
    m_skipNextFrame(false),
    m_syncCount(0),
    m_renderCount(0),
    m_dirtyCount(0)
{
    m_billboards = new Billboards("modules/flocking-algorithm/bird.png");
    m_scaryBird = new Billboards("modules/flocking-algorithm/angryBird.png");
}

Renderer::~Renderer()
{

}

QOpenGLFramebufferObject *Renderer::createFramebufferObject(const QSize &size) {
    QOpenGLFramebufferObjectFormat format;
    format.setAttachment(QOpenGLFramebufferObject::CombinedDepthStencil);
    format.setSamples(4);
    return new QOpenGLFramebufferObject(size, format);
}
}
