#ifndef PLAYER_H
#define PLAYER_H
#include "Monster.h"
#include "LinkedList.h"
#include <iostream>
using namespace std;

class Player {
private:
  string name;
  int hp;
  string raza;
  int lp;
public:
  Player();
  Player(string name, string raza);
  string getName();
  void setName(string name);
  int getHp();
  void setHp(int hp);
  string getRaza();
  void setRaza(string raza);
  int getLp();
  void setLp(int lp);
  void attack(Player player, Monster& monster);
};

#endif