#include "Calabozo.h"

Calabozo::Calabozo() {
}
Calabozo::Calabozo(Monster jefe) {
  this->jefe = jefe;
  this->jefeDerrotado = false;
}
bool Calabozo::isJefeDerrotado() { return 0; }

Monster Calabozo::getJefe() {
  return jefe;
}