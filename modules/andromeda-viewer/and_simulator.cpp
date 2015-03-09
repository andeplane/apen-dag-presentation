#include "and_simulator.h"
#include <cmath>
#include <iostream>
#include <functional>
#include <QDebug>
using std::cout; using std::endl; using std::function;
namespace Andromeda {
Simulator::Simulator(QObject *parent) :
    QObject(parent)
{

}


Simulator::~Simulator()
{

}

void Simulator::step()
{

    emit stepCompleted();
}
}
