#include "board_games_empire.h"

int main(int argc, char** argv) {
  g_autoptr(BoardGamesEmpire) app = board_games_empire();
  return g_application_run(G_APPLICATION(app), argc, argv);
}
