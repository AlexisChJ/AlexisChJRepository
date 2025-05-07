#include "Mapa.h"

Mapa::Mapa() {
  
}

void Mapa::loadMapRandomly(LinkedList<Monster>& monsters) {
  Dice monsterDice(monsters.size());
  int dungeons = 0;
  LinkedList<Monster> monstersInDungeons;
  
  while (dungeons < dungeonAmount) {
    int dungeonIndex = monsterDice.roll() - 1;
    Monster test = monsters.findAtPos(dungeonIndex)->getData();
    if (monstersInDungeons.find(test) == -1) {
      monstersInDungeons.addToEnd(test);
      dungeons++;
    }
  }

  for (int i = 0; i < dungeonAmount; i++) {
    Monster mons = monstersInDungeons.popFirstNode();
    Calabozo cal(mons);
    
    dungeonMap.addToEnd(cal);
  }
}

void Mapa::insertToLast(Monster monster) {
  dungeonMap.addToEnd(monster);
}

Calabozo Mapa::popFirst() {
  return dungeonMap.popFirstNode();
}

void Mapa::printAllDungeons() {
  for (int i = 0; i < dungeonMap.size(); i++) {
     cout << dungeonMap.findAtPos(i)->getData().getJefe() << endl;
  }
}

bool Mapa::isCompleted() {
  return dungeonMap.size() == 0;
}