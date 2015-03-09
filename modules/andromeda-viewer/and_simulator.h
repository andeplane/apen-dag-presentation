#pragma once
#include <QObject>
#include <QVector2D>
#include <vector>
namespace Andromeda {
class Simulator : public QObject
{
    Q_OBJECT
public:
    Simulator(QObject* parent = 0);
    ~Simulator();

public slots:
    void step();

signals:
    void stepCompleted();
};
}
