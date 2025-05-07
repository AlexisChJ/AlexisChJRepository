#ifndef ASSETS_H
#define ASSETS_H

#include "LinkedList.h"
#include "Monster.h"
#include <fstream>
#include <iostream>
#include <sstream>

using namespace std;

class Assets {
public:
  static LinkedList<Monster> ReadMonsters(string csv_name);

private:
  Assets();
  static float stringToFloat(string in) {
    stringstream ss(in);
    float ans;
    ss >> ans;
    return ans;
  }
  
  static int stringToInt(string in) {
    stringstream ss(in);
    int ans;
    ss >> ans;
    return ans;
  }
};

#endif
