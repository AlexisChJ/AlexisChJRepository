#ifndef HASHTABLE_H
#define HASHTABLE_H
#include "SpellsAndSkills.h"

class Hashtable {
private:
  SpellsAndSkills *table[26];
  int hash(int id);

public:
  Hashtable();
  ~Hashtable();
  void insert(SpellsAndSkills *spellsAndSkills);
  void remove(int id);
  SpellsAndSkills get(int id);
  void print();
  int findSpellsAndSkills(SpellsAndSkills spellsAndSkills);
};

#endif