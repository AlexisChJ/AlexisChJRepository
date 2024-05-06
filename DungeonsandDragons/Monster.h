#ifndef MONSTER_H
#define MONSTER_H
#include <iostream>
#include <string>
using namespace std;

class Monster {
private:
  string name;
  float challenge_rate;
  string type;
  string size;
  int armor_class;
  int hit_points;
  string alignment;
  bool isAlive;

public:
  Monster();
  Monster(string name, float chal_rt, string type, string size, int ac, int hp, string alg);
  void setName(string name);
  string getName();
  void setChallengeRate(float chal_rt);
  float getChallengeRate();
  void setType(string type);
  string getType();
  void setSize(string size);
  string getSize();
  void setArmorClass(int ac);
  int getArmorClass();
  void setHitPoints(int hp);
  int getHitPoints();
  void setAlignment(string alg);
  string getAlignment();
  void setIsAlive(bool isAlive);
  bool getIsAlive();
  void print();

  friend ostream &operator<<(ostream &os, const Monster &m) {
    os << "{" << m.name << ", HP: " << m.hit_points << "}";
    return os;
  }
  bool operator>(const Monster &m) {
    int val = this->name.compare(m.name);
    if (val == 1)
      return true;
    else if (val == 0)
      return this->hit_points > m.hit_points;
    else
      return false;
  }
  bool operator==(const Monster &m) { return this->name == m.name; }
};

#endif
