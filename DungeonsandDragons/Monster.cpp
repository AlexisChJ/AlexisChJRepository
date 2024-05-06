#include "Monster.h"

Monster::Monster()
    : name("null"), challenge_rate(-1.0), type("none"), size("none"),
      armor_class(-1), hit_points(-1.0), alignment("none"), isAlive(true){}

Monster::Monster(string name, float chal_rt, string type, string size, int ac, int hp, string alg) {
  this->name = name;
  this->challenge_rate = chal_rt;
  this->type = type;
  this->size = size;
  this->armor_class = ac;
  this->hit_points = hp;
  this->alignment = alg;
  bool isAlive = this->hit_points > 0;
}

void Monster::setName(string name) { this->name = name; }
string Monster::getName() { return name; }
void Monster::setChallengeRate(float chal_rt) {
  this->challenge_rate = chal_rt;
}
float Monster::getChallengeRate() { return challenge_rate; }
void Monster::setType(string type) { this->type = type; }
string Monster::getType() { return type; }
void Monster::setSize(string size) { this->size = size; }
string Monster::getSize() { return size; }
void Monster::setArmorClass(int ac) { this->armor_class = ac; }
int Monster::getArmorClass() { return armor_class; }
void Monster::setHitPoints(int hp) { this->hit_points = hp; }
int Monster::getHitPoints() { return hit_points; }
void Monster::setAlignment(string alg) { this->alignment = alg; }
string Monster::getAlignment() { return alignment; }
void Monster::setIsAlive(bool isAlive) { this->isAlive = isAlive; }
bool Monster::getIsAlive() { return this->hit_points > 0; }

void Monster::print() {
  cout << "   Se llama " << this->name;
  cout << " y tiene un challenge rate de " << this->challenge_rate;
  cout << ", además es de tipo " << this->type;
  cout << ". Cuidado que es de tamaño " << this->size;
  cout << " y tiene un tipo de armadura " << this->armor_class;
  cout << ". Igual tiene " << this->hit_points;
  cout << " hp. Casi se me olvida... tiene una alineacion " << this->alignment << endl;
}