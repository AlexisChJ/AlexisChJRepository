#include "Assets.h"

LinkedList<Monster> Assets::ReadMonsters(string csv_name) {
  LinkedList<Monster> monstruos;
  string csv_path = "./" + csv_name;

  ifstream csv_stream(csv_path);
  string fileline;
  getline(csv_stream, fileline); 
  while (getline(csv_stream, fileline)) {
    string attributes[7]; 
    istringstream monster_stream(fileline);
    string attr;
    int i = 0;
    while (getline(monster_stream, attr, ',')) {
      attributes[i++] = attr;
    }

    string name = attributes[0];
    float challenge_rate = stringToFloat(attributes[1]);
    string type = attributes[2];
    string size = attributes[3];
    int armor_class = stringToInt(attributes[4]);
    int hit_points = stringToInt(attributes[5]);
    string alignment = attributes[6];

    Monster m(name, challenge_rate, type, size, armor_class, hit_points,
              alignment);
    monstruos.addToEnd(m);
  }
  csv_stream.close();
  return monstruos;
}
