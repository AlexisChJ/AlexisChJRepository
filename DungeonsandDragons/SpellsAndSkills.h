#ifndef SPELLSANDSKILLS_H
#define SPELLSANDSKILLS_H
#include <string>
using namespace std;

class SpellsAndSkills {
private:
  int spellId;
  int level;
  string name;
  int attack;
  int attackMultiplier;
  static int id;
  static int generateId();
public:
  SpellsAndSkills();
  SpellsAndSkills(string nombre);
  string toString();
  void setName(string name);
  string getName();
  void setAttack(int attack);
  int getAttack();
  void setAttackMultiply(int attackMulti);
  int getAttackMultiply();
  void setLevel(int level);
  int getLevel();
  int getId();
};

#endif