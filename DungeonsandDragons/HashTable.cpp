#include "HashTable.h"
#include <iostream>
#include <string>
using namespace std;

Hashtable::Hashtable() {
  for (int i = 0; i < 26; i++) {
    table[i] = nullptr;
  }
}

Hashtable::~Hashtable() {
  for (int i = 0; i < 26; i++) {
    if (table[i] != nullptr) {
      delete table[i];
      table[i] = nullptr;
    }
  }
}

void Hashtable::insert(SpellsAndSkills *spellsAndSkills) {
  int index = hash(spellsAndSkills->getId());
  if (table[index] == nullptr) {
    table[index] = spellsAndSkills;
  } else {
    int i = index;
    while (table[i] != nullptr) {
      i++;
      if (i == 26) {
        i = 0;
      }
      if (i == index) {
        cout << "Tabla llena" << endl;
        return;
      }
    }
    table[i] = spellsAndSkills;
  }
}
void Hashtable::remove(int id) {
  int index = hash(id);
  if (table[index] == nullptr) {
    cout << "No existe" << endl;
  } else {
    int i = index;
    while (table[i] != nullptr) {
      if (table[i]->getId() == id) {
        table[i] = nullptr;
        return;
      } else {
        i++;
        if (i == 26) {
          i = 0;
        }
        if (i == index) {
          cout << "No existe" << endl;
          return;
        }
      }
    }
  }
}
SpellsAndSkills Hashtable::get(int id) {
  int index = hash(id);
  if (table[index] == nullptr) {
    cout << "No existe" << endl;
    return SpellsAndSkills();
  } else {
    int i = index;
    while (table[i] != nullptr) {
      cout << i << endl;
      if (table[i]->getId() == id) {
        return *table[i];
      } else {
        i++;
        if (i == 26) {
          i = 0;
        }
        if (i == index) {
          cout << "No existe" << endl;
          return SpellsAndSkills();
        }
      }
    }
  }
  return SpellsAndSkills();
}
void Hashtable::print() {
  for (int i = 0; i < 26; i++) {
    if (table[i] != nullptr) {
      cout << (i) << ".-" << table[i]->toString() << endl;
    } else {
      cout << (i) << ".-"
           << " Vacío" << endl;
    }
  }
}
int Hashtable::findSpellsAndSkills(SpellsAndSkills spellsAndSkills) {
  int index = hash(spellsAndSkills.getId());
  if (table[index] == nullptr) {
    cout << "No existe" << endl;
  } else {
    int i = index;
    while (table[i] != nullptr) {
      if (table[i]->getId() == spellsAndSkills.getId()) {
        return i;
      } else {
        i++;
        if (i == 26) {
          i = 0;
        }
        if (i == index) {
          cout << "No existe" << endl;
          return -1;
        }
      }
    }
  }
  return -1;
}

int Hashtable::hash(int id) { return id % 26; }