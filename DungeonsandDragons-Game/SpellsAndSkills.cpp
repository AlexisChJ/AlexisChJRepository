#include "SpellsAndSkills.h"

int SpellsAndSkills::id = 0;

int SpellsAndSkills::generateId() {
  return id++;
}

SpellsAndSkills::SpellsAndSkills(){
  this->spellId=SpellsAndSkills::generateId();
  this->name = "NULL";
}

SpellsAndSkills::SpellsAndSkills(string nombre){
  this->spellId=SpellsAndSkills::generateId();
  this->name = nombre;
}

string SpellsAndSkills::toString() {
  return "ID: " + to_string(spellId) + ", " + name + " - NIVEL:" + to_string(level) + " - Ataqueid: " + to_string(attack);
}

void SpellsAndSkills::setAttack(int attack) {
  this->attack = attack;
}
int SpellsAndSkills::getAttack() {
  return attack;
}
void SpellsAndSkills::setAttackMultiply(int attackMultiply) {
  this->attackMultiplier = attackMultiply;
}
int SpellsAndSkills::getAttackMultiply() {
  return this->attackMultiplier;
}

int SpellsAndSkills::getLevel() {
  return level;
}

void SpellsAndSkills::setLevel(int level) {
  this->level = level;
}

int SpellsAndSkills::getId() {
  return this->spellId;
}

void SpellsAndSkills::setName(string name) {
  this->name = name;
}
string SpellsAndSkills::getName() {
  return name;
}