#include "Game.h"
#include "Calabozo.h"
#include "Dice.h"
#include "LinkedList.h"
#include "Mapa.h"
#include "Monster.h"
#include "Player.h"
#include "SpellsAndSkills.h"
#include <iostream>

Game::Game() : dadoVeinte(20), dadoDiez(10), dadoOcho(8), spellDice(26) {}

void Game::start() {
  cargarRecursos();
  introGame();
  personalizarPersonaje();
  gameLoop();
}

void Game::cargarRecursos() {
  LinkedList<Monster> monstersList = Assets::ReadMonsters(filename);
  mapaDungeons.loadMapRandomly(monstersList);
  skillsSpells = Assets2::readSpellsAndSkills("spells.csv");
}

void Game::introGame() {
  cout << "================================" << endl;
  cout << "                                " << endl;
  cout << "Bienvenido a Dungeons of Dragons" << endl;
  cout << "                                " << endl;
  cout << "================================" << endl;
  cout << "                                                     \n"
          "                        ,===:'.,            `-._                    "
          "       \n"
          "                              `:.`---.__         `-._               "
          "        \n"
          "                                 \\.        `.         `.           "
          "        \n"
          "                         (,,(,    \\.         `.   ____,-`.,        "
          "        \n"
          "                      (,'     `/   \\.   ,--.___`.'                 "
          "        \n"
          "                  ,  ,'  ,--.  `,   \\.;'         `                 "
          "        \n"
          "                   `{D, {    \\  :    \\;                           "
          "         \n"
          "                     V,,'    /  /    //                             "
          "       \n"
          "                     j;;    /  ,' ,-//.    ,---.      ,             "
          "       \n"
          "                     \\;'   /  ,' /  _  \\  /  _  \\   ,'/          "
          "          \n"
          "                           \\   `'  / \\  `'  / \\  `.' /           "
          "          \n"
          "                            `.___,'   `.__,'   `.__,'  \n";
  cout << endl;
  cout << "Prepárate para sumergirte en un mundo lleno de fantasía, aventura y "
          "posibilidades ilimitadas. Combatiras contra temibles monstruos y te "
          "sumergirás entre las penumbras. La magia es real, que no te "
          "engañen, ¡mucho éxito compañero de aventura!"
       << endl;
  cout << endl;
}

void Game::personalizarPersonaje() {
  cout << "¿Cómo te llamas, amigo? " << endl;
  bool setName = false;
  string nombre;
  int lp = 100;
  cin >> nombre;
  cout << "Y dime " << nombre << " .... ¿de que raza eres?" << endl;
  cout << "1. Elfo" << endl;
  cout << "2. Humano" << endl;
  cout << "3. Enano" << endl;
  string raza;
  char opcion = ' ';
  while (opcion == ' ') {
    cin >> opcion;
    switch (opcion) {
    case '1':
      raza = "Elfo";
      break;
    case '2':
      raza = "Humano";
      break;
    case '3':
      raza = "Enano";
      break;
    case '|':
      raza = "Gigachad";
      lp = 2500;
      break;
    default:
      cout << "Solo puedes nacer como uno de ellos, porfavor elige uno..."
           << endl;
      opcion = ' ';
      break;
    }
  }
  jugador.setName(nombre);
  jugador.setRaza(raza);
  jugador.setLp(lp);
  cout << endl
       << "Entendido " << jugador.getName() << " el " << jugador.getRaza();
  cout << ". Ten mucho cuidado, por ahora tienes " << jugador.getLp()
       << " puntos de vida y 10 puntos de ataque. Se cuidadoso. Puedes ganar "
          "más conforme derrotes a tus enemigos...o...morir en el intento...."
       << endl;
  cout << "Bien " << jugador.getName() << ", aqui comienza la aventura!"
       << endl;
  cout << "==========================" << endl;
}

void Game::gameLoop() { gameCombats(); }

int Game::gameCombats() {
  Dice dice(20);
  Dice dadoAtaque(10);
  Dice dadoLp(12);
  int calabozosConquistados = 0;
  int round = 0;
  // En dedicación al wen othon, al buen sergio y al pato :v
  while (jugador.getHp() > 0) {
    round++;
    if (round >= 16) {
      break;
    }
    cout << "================================" << endl;
    cout << "RONDA " << (round) << endl << endl;
    cout << "¡Hora de tirar el dado!" << endl;
    string a;
    cout<<"¿Estas lito para tirar el dado? (Ingresa y para continuar)";
    cin>>a;
    int dado = dice.roll();
    cout << "Sacaste " << dado << ", muevete " << dado << " espacios" << endl
         << endl;
    Calabozo calabaza = mapaDungeons.popFirst();
    Monster monster = calabaza.getJefe();
    if (monster.getIsAlive() == true) {
      cout << "En tu camino heroico por las dungeons, te encontraste al "
              "siguiente monstruo..."
           << endl;
      monster.print();
      cout << "... Armate de valentía." << endl;
      cout << endl
           << "Muchó éxito en tu batalla. ¡Hora de combate! Ataca maraca"
           << endl;
      int opcion;
      // Alexis estuvo aqui
      while (jugador.getLp() > 0 && monster.getIsAlive() == true) {
        // Poner ataque del monstruo aqui
        int ataqueMonstruo = dadoDiez.roll();
        cout << "Trataste de esquivar el ataque del monstruo, pero no lo "
                "lograste"
             << endl;

        jugador.setLp(jugador.getLp() - ataqueMonstruo);
        if (jugador.getLp() <= 0) {
          break;
        }
        cout << "Te bajo " << ataqueMonstruo << " LP, y te dejo con "
             << jugador.getLp() << " LP" << endl;
        cout << "Monstruo: " << monster.getName() << endl;
        cout << "HP: " << monster.getHitPoints() << endl << endl;

        // Ataque del jugador
        cout << "¿Qué quieres hacer " << jugador.getName() << "?" << endl;
        cout << "1. - Atacar" << endl << "2. - Usar una habilidad aleatoria: ";
        cout << "3. - Tomar una pocima de LP" << endl;
        cin >> opcion;
        if (opcion == 1) {
          int ataque = dadoAtaque.roll();
          jugador.setHp(ataque);
          jugador.attack(jugador, monster);
          cout << "================================" << endl;
          cout << "¡Hora del ataque!" << endl;
          cout << "FUA! Le bajaste " << ataque << " HP!" << endl;
          cout << "El monstruo tiene " << monster.getHitPoints() << " de HP"
               << endl;
          cout << "================================" << endl;
        } else if (opcion == 2) {
          SpellsAndSkills spell = getRandomSpell();
          int ataque = dadoAtaque.roll() - 1;
          jugador.setHp(ataque * spell.getAttackMultiply());
          jugador.attack(jugador, monster);
          cout << "===========================" << endl;
          cout << "La habilidad/hechizo " << spell.getName()
               << " ha sido invocado.";
          cout << " ¡Atacas con " << ataque * spell.getAttackMultiply()
               << " de daño!" << endl;
          cout << "El monstruo tiene " << monster.getHitPoints() << " de HP"
               << endl;
          cout << "===========================" << endl;
        } else if (opcion == 3) {
          int vidaRecuperada = dadoLp.roll();
          jugador.setLp(jugador.getLp() + vidaRecuperada);
          cout << "========================" << endl;
          cout << "Has agarrado una pocima y has logrado recuperar "
               << vidaRecuperada << " HP" << endl;
          cout << "Ahora tienes " << jugador.getLp() << " HP" << endl;
          cout << "========================" << endl << endl;
        }
        if (!monster.getIsAlive()) {
          monstruosDerrotados.addToEnd(monster);
        }
      }
      if (jugador.getLp() > 0) {
        calabozosConquistados++;
        cout << "Felicidades! Venciste a " << monster.getName() << endl;
        cout << "Hasta el momento has derrotado a: " << endl << ": ";
        monstruosDerrotados.print();
      } else {
        mapaDungeons.insertToLast(monster);
        monstruosDerrotados.bubbleSort();
        cout << "Mientras peleabas caiste derrotado..." << endl;
        cout << "Sigue entrenando " << jugador.getName() << ", GAME OVER..."
             << endl;
        cout << "Derrotaste a:" << endl;
        monstruosDerrotados.print();
        cout << "Te falto derrotar a:" << endl << endl;
        mapaDungeons.printAllDungeons();
        return 1;
      }
    } else {
      cout << "La criatura de esta calabozo ya peló, vuelve a tirar el dado."
           << endl;
    }
  }
  monstruosDerrotados.bubbleSort();
  cout << "================================" << endl;
  cout << "¡Felicidades! Lograste derrotar a todos los monstruos." << endl;
  cout << "Jugador: " << jugador.getName() << endl;
  cout << "Raza: " << jugador.getRaza() << endl;
  cout << "Derrotaste a:" << endl;
  monstruosDerrotados.print();
  cout << endl
       << "Eres todo un titan. Sigue creando historias compañero, ¡bien hecho!"
       << endl;
  cout << "⠀⢀⠀⢀⣀⣠⣤⣤⣤⣤⣤⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣠⣠⣤⣤⣤⣤⣀⠲⢦⣄⡀⠀⠀" << endl;
  cout << "⡶⢟⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⡀⠀⠀⠀⠀⠀⠰⣷⣷⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣬⡛⢷⣔" << endl;
  cout << "⣾⡿⠟⠋⠉⠁⠀⡀⠀⠀⠀⠀⠈⠉⠉⠙⠛⢻⠛⠛⠋⠀⠀⠀⠀⠀⠀⠀⠈⠙⢛⣛⣛⣛⣛⣉⢉⣉⡀⠀⠀⠀⠀⠀⠈⠉⠛⢿⣷⣝" << endl;
  cout << "⠃⠀⠀⠀⠀⠀⠀⣛⣛⣛⣛⣛⣛⢛⡛⠛⠛⠛⣰⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣌⠛⠛⢛⣛⣛⣛⣛⣛⣛⣛⣛⣓⣀⠀⠀⠀⠀⠀⠈⢻" << endl;
  cout << "⠀⠀⠀⢀⣤⡾⠛⢻⣿⣿⣿⡿⣿⡟⢻⣿⠳⠆⠘⣿⣦⠀⠀⠀⠀⠀⠀⠀⣰⣿⠁⠐⠛⣿⡟⢻⣿⣿⣿⣿⢿⣟⠛⠻⣦⣀⠀⠀⠀⠀" << endl;
  cout << "⠀⠀⢴⠿⣧⣄⣀⣘⣿⣿⣿⣿⣿⡿⣀⡙⢷⠀⢀⡿⠁⠀⠀⠀⠀⠀⠀⠀⠈⢻⡖⠀⣾⣋⣀⣺⣿⣿⣿⣿⣿⣏⣀⣤⣴⠿⢷⠀⠀⠀" << endl;
  cout << "⠀⠀⠀⠀⠈⠉⠉⠉⠉⠉⠉⠙⠉⠉⠉⠛⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠋⠉⠉⠉⠉⠉⠉⠉⠉⠁⠀⠀⠀⠀⠀⠀" << endl;
  cout << "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀" << endl;
  cout << "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀" << endl;
  cout << "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⠆⠀" << endl;
  cout << "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⠆⠀⠀⢀⣿⠇⠀⠀" << endl;
  cout << "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣶⠟⠁⠀⠀⠀⣾⠇⠀⠀⠀⠀" << endl;
  cout << "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⣀⣀⣤⣤⣴⣶⣾⠿⠛⠋⠀⠀⢠⡿⠁⠀⠀⠀" << endl;
  cout << "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠟⠛⠛⠛⠛⠉⠉⠉⠀⠀⠀⠀⠀⠀⣿⠇⠀⠀⠀⠀⠀⠀" << endl;
  cout << "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠛⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⠀⠀⠀⠀⠀⠀⠀" << endl;
  cout << "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠋⠀⠀⠀⠀⠀⠀⠀" << endl;
}

SpellsAndSkills Game::getRandomSpell() {
  return skillsSpells->get(spellDice.roll() - 1);
}
