#include "flock_simulator.h"
#include <cmath>
#include <iostream>
#include <functional>
#include <QDebug>
using std::cout; using std::endl; using std::function;
namespace Flocking {
Simulator::Simulator(QObject *parent) :
    QObject(parent)
{
    scale = 1.0;
    separationDistance *= scale;
    cohesionDistance *= scale;
    alignmentDistance *= scale;
    mouseDistance *= scale;

    mouseForceMagnitude      *= 5;
    separationForceMagnitude *= 5;
    cohesionForceMagnitude   *= 10;
    alignmentForceMagnitude  *= 10;

    accelerationLimit = 0.0;
    speedLimit = 0.25;

    qDebug() << "Separation distance: " << separationDistance;
    qDebug() << "Cohesion distance: " << cohesionDistance;
    qDebug() << "Alignment distance: " << alignmentDistance;
    qDebug() << "Mouse distance: " << mouseDistance;

    dt = 0.01;
    createBirds(500);
}


Simulator::~Simulator()
{

}
QVector2D Simulator::getMousePosition() const
{
    return mousePosition;
}

void Simulator::setMousePosition(const QVector2D &value)
{
    mousePosition = value;
}

void Simulator::createBird()
{
    float x = 2*(rand() / float(RAND_MAX)) - 1.0;
    float y = 2*(rand() / float(RAND_MAX)) - 1.0;

    float vx = (2*(rand() / float(RAND_MAX)) - 1.0) * 0.1 + 0.02;
    float vy = (2*(rand() / float(RAND_MAX)) - 1.0) * 0.1;

    pos.push_back(QVector2D(x,y));
    vel.push_back(QVector2D(vx,vy));
    acc.push_back(QVector2D(0,0));
}

void Simulator::addObstacle(QVector2D obstacle)
{
    obstacles.push_back(obstacle);
}


void Simulator::createBirds(unsigned int numberOfBirds) {
    for(unsigned int i=0; i<numberOfBirds; i++) {
        createBird();
    }
}

void Simulator::step()
{
    averageVelocity[0] = 0;
    averageVelocity[1] = 0;
    for(unsigned int i=0; i<pos.size(); i++) {
        averageVelocity += vel[i];
    }

    averageVelocity /= pos.size();
    float averageSpeed = averageVelocity.length();

    for(unsigned int i=0; i<pos.size(); i++) {
        acc[i][0] = 0;
        acc[i][1] = 0;
        QVector2D separationForce;
        QVector2D cohesionForce;
        QVector2D alignmentForce;
        QVector2D mouseForce;
        QVector2D obstacleForce;

        float dx = pos[i][0] - mousePosition[0];
        float dy = pos[i][1] - mousePosition[1];

        if(periodicX) {
            if(dx < -1) dx += 2.0;
            else if(dx > 1) dx -= 2.0;
        }
        if(periodicY) {
            if(dy < -1) dy += 2.0;
            else if(dy > 1) dy -= 2.0;
        }
        float dr2 = dx*dx + dy*dy;
        mouseForce[0] = dx;
        mouseForce[1] = dy;

        if(dr2 < mouseDistance*mouseDistance) {
            mouseForce.normalize();
            vel[i] += mouseForce*mouseForceMagnitude*dt;
        }

        for(QVector2D &obstaclePos : obstacles) {
            float dx = pos[i][0] - obstaclePos[0];
            float dy = pos[i][1] - obstaclePos[1];

            if(periodicX) {
                if(dx < -1) dx += 2.0;
                else if(dx > 1) dx -= 2.0;
            }
            if(periodicY) {
                if(dy < -1) dy += 2.0;
                else if(dy > 1) dy -= 2.0;
            }
            float dr2 = dx*dx + dy*dy;
            obstacleForce[0] = dx;
            obstacleForce[1] = dy;

            if(dr2 < obstacleDistance*obstacleDistance) {
                obstacleForce.normalize();
                vel[i] += obstacleForce*obstacleForceMagnitude*dt;
            }
        }

        for(unsigned int j=0; j<pos.size(); j++) {
            if(i==j) continue;

            float dx = pos[i][0] - pos[j][0];
            float dy = pos[i][1] - pos[j][1];
            if(dx < -1) dx += 2.0;
            else if(dx > 1) dx -= 2.0;
            if(dy < -1) dy += 2.0;
            else if(dy > 1) dy -= 2.0;
            float dr2 = dx*dx + dy*dy;

            if(dr2 < separationDistance*separationDistance) {
                separationForce[0] += dx;
                separationForce[1] += dy;
            } else {
                if(dr2 < cohesionDistance*cohesionDistance) {
                    cohesionForce[0] += dx;
                    cohesionForce[1] += dy;
                }

                if(dr2 < alignmentDistance*alignmentDistance) {
                    alignmentForce[0] += vel[j][0];
                    alignmentForce[1] += vel[j][1];
                }
            }
        }
        separationForce.normalize();
        cohesionForce.normalize();
        alignmentForce.normalize();
        acc[i] += separationForce*separationForceMagnitude;
        acc[i] -= cohesionForce*cohesionForceMagnitude;
        acc[i] -= alignmentForce*alignmentForceMagnitude;

        if(accelerationLimit > 0) {
            float accelerationMagnitudeSquared = acc[i].lengthSquared();
            if(accelerationMagnitudeSquared > accelerationLimit*accelerationLimit) {
                acc[i] *= accelerationLimit/acc[i].length();
            }
        }

        if(!periodicX) {
            if(pos[i][0] < -0.9) {
                acc[i][0] += fabs(pos[i][0] + 0.9)*boundaryForceMagnitude;
            } else if(pos[i][0] > 0.9) {
                acc[i][0] -= fabs(pos[i][0] - 0.9)*boundaryForceMagnitude;
            }
        }

        if(!periodicY) {
            if(pos[i][1] < -0.7) {
                acc[i][1] += fabs(pos[i][1] + 0.7)*boundaryForceMagnitude;
            } else if(pos[i][1] > 0.7) {
                acc[i][1] -= fabs(pos[i][1] - 0.7)*boundaryForceMagnitude;
            }
        }

        vel[i] += acc[i]*dt;
        vel[i] += averageVelocity*0.1/averageSpeed*dt;

        if(speedLimit > 0) {
            float speedMagnitudeSquared = vel[i].lengthSquared();
            if(speedMagnitudeSquared > speedLimit*speedLimit) {
                vel[i] *= speedLimit/vel[i].length();
            }
        }

        pos[i] += vel[i]*dt;

        if(periodicX) {
            if(pos[i][0] < -1) pos[i][0] += 2;
            else if(pos[i][0] > 1) pos[i][0] -= 2;
        }
        if(periodicY) {
            if(pos[i][1] < -1) pos[i][1] += 2;
            else if(pos[i][1] > 1) pos[i][1] -= 2;
        }
    }

    emit stepCompleted();
}
}
