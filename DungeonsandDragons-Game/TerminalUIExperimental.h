#ifndef UI_H
#define UI_H

#include <ncurses.h>

class TerminalUI {
  public:
    TerminalUI() {}
    void LoadPage() {
      char buffer[255] = {0};
      

      initscr();
      refresh();
      
      box(stdscr, 0, 0);
      int width, height;
      getmaxyx(stdscr, height, width);
      
      snprintf(buffer, sizeof(buffer), "width: %i, height: %i", width, height);
      
      mvprintw(1, 1, buffer);
      refresh();
      endwin();
    }
};

#endif
