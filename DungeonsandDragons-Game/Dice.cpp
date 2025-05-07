#include "Dice.h"

Dice::Dice() { this->sides = 6; }

Dice::Dice(int sides) {
  srand(time(0));
  this->sides = sides; 
}

int Dice::roll() {
  return rand() % sides + 1;
}