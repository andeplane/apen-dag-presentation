#pragma once
#include <QtGui/QOpenGLShaderProgram>
#include <QOpenGLFunctions>
#include <QOpenGLTexture>
#include <vector>
using std::vector;
namespace Flocking {
struct BillboardsData
{
    vector<QVector2D> positions;
    vector<float> rotation;
};

struct VertexData
{
    QVector2D position;
    QVector3D color;
    QVector2D textureCoord;
};

class Billboards
{
public:
    Billboards();
    ~Billboards();
    void update(BillboardsData &data);
    void render();
private:
    GLuint m_vboIds[2];
    std::vector<VertexData> m_vertices;
    std::vector<GLuint> m_indices;
    QOpenGLFunctions *m_funcs = 0;
    QOpenGLShaderProgram *m_program = 0;
    QOpenGLTexture *m_texture = 0;

    void createShaderProgram();
    void generateVBOs();
    void uploadTexture();
    void ensureInitialized();
    QVector3D vectorFromColor(const QColor &color);
};
}
