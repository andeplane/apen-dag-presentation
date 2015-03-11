#pragma once

#include <QObject>
#include <QVector2D>
#include <vector>
namespace Flocking{
class Simulator : public QObject
{
    Q_OBJECT
public:
    float        dt;

    Simulator(QObject* parent = 0);
    ~Simulator();
    QVector2D mousePosition;
    std::vector<QVector2D> obstacles;
    std::vector<QVector2D> pos;
    std::vector<QVector2D> vel;
    std::vector<QVector2D> acc;
    QVector2D averageVelocity;
    bool periodicX = true;
    bool periodicY = false;
    float scale = 1.0;
    float boundaryForceMagnitude = 2.0;
    float separationDistance = 0.15;
    float cohesionDistance = 2.0;
    float alignmentDistance = 0.5;
    float mouseDistance = 0.3;
    float obstacleDistance = 0.2;
    float obstacleForceMagnitude = 0.25;
    float mouseForceMagnitude = 0.5;
    float separationForceMagnitude = 0.15;
    float cohesionForceMagnitude = 0.1;
    float alignmentForceMagnitude = 0.25;
    float accelerationLimit = 1.0;
    float speedLimit = 1.0;


    void createBirds(unsigned int numberOfBirds);
    QVector2D getMousePosition() const;
    void setMousePosition(const QVector2D &value);
    void createBird();
    void addObstacle(QVector2D obstacle);

public slots:
    void step();

signals:
    void stepCompleted();
};
}
