#include "Assets2.h"
#include "HashTable.h"
#include "SpellsAndSkills.h"

#include <fstream>
#include <iostream>
#include <sstream>

float stringToFloat(string in) {
  stringstream ss(in);
  float ans;
  ss >> ans;
  return ans;
}

int stringToInt(string in) {
  stringstream ss(in);
  int ans;
  ss >> ans;
  return ans;
}

Hashtable *Assets2::readSpellsAndSkills(string csv_name) {
  Hashtable *hashSpellsAndSkills = new Hashtable();
  string csv_path = "./" + csv_name;

  ifstream csv_stream(csv_path);
  string fileline;
  getline(csv_stream, fileline);

  string name, level, ataque, ataqueMultiplicador;
  while (getline(csv_stream, fileline)) {
    stringstream ss(fileline);
    getline(ss, name, ',');
    getline(ss, level, ',');
    getline(ss, ataque, ',');
    getline(ss, ataqueMultiplicador, ',');
    SpellsAndSkills *skill = new SpellsAndSkills(name);
    skill->setLevel(stoi(level));
    skill->setAttack(stoi(ataque));
    skill->setAttackMultiply(stoi(ataqueMultiplicador));
    hashSpellsAndSkills->insert(skill);
  }
  csv_stream.close();
  return hashSpellsAndSkills;
}
