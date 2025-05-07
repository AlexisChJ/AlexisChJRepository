#ifndef CALABOZO_H
#define CALABOZO_H

#include "Monster.h"
#include <iostream>

class Calabozo {
private:
  Monster jefe;
  bool jefeDerrotado;

public:
  Calabozo();
  Calabozo(Monster jefe);
  Monster getJefe();
  bool isJefeDerrotado();
  bool operator>(Calabozo &other) const { return true; }
  bool operator>(Calabozo other) const { return true; }
  bool operator==(Calabozo &other) const { return true; }
  friend ostream &operator<<(ostream &in, Calabozo cal) { 
    in << "(" << cal.jefe << ")";
    return in; 
  }
};

#endif