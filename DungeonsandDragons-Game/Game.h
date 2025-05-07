#ifndef GAME_H
#define GAME_H

#include "Assets.h"
#include "Assets2.h"
#include "Dice.h"
#include "Mapa.h"
#include "Player.h"

#include <iostream>

using namespace std;

class Game {
public:
  Game();
  void start();
private:
  Dice dadoVeinte, dadoDiez, dadoOcho;
  Dice spellDice;
  Mapa mapaDungeons;
  Player jugador;
  Hashtable* skillsSpells;
  LinkedList<Monster> monstruosDerrotados;
  // Metodo para iniciar el juego.
  void gameLoop();
  // Metodos para cargar recursos.
  void cargarRecursos();
  // Metodos de etapas del juego
  void introGame();
  void personalizarPersonaje();
  int gameCombats();
  SpellsAndSkills getRandomSpell();
  const string filename = "monsters_patched.csv";
};

#endif