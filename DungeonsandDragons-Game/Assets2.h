#ifndef ASSETS2_H
#define ASSETS2_H

#include "HashTable.h"
#include "SpellsAndSkills.h"

using namespace std;

class Assets2 {
public:
  static Hashtable* readSpellsAndSkills(string csv_name);
private:
  Assets2();
};

#endif