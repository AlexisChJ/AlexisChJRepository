#ifndef MAPA_H
#define MAPA_H

#include "Calabozo.h"
#include "LinkedList.h"
#include "Dice.h"
#include "Calabozo.h"

#include <iostream>

using namespace std;

class Mapa {
  private:
    LinkedList<Calabozo> dungeonMap;
    const int dungeonAmount = 16;
  public:
    Mapa();
    void loadMapRandomly(LinkedList<Monster>& monsters);
    void insertToLast(Monster monster);
    void printAllDungeons();
    Calabozo popFirst();
    bool isCompleted();
};

#endif