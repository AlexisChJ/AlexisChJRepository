#ifndef DICE_H
#define DICE_H

#include <stdlib.h>
#include <time.h>

using namespace std;

class Dice {
private:
  int sides;

public:
  Dice();
  Dice(int sides);
  int roll();
};

#endif