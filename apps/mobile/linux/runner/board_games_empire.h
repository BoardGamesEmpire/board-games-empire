#ifndef BOARD_GAMES_EMPIRE_H
#define BOARD_GAMES_EMPIRE_H

#include <gtk/gtk.h>

G_DECLARE_FINAL_TYPE(BoardGamesEmpire, my_application, MY, APPLICATION,
                     GtkApplication)

/**
 * board_games_empire_new:
 *
 * Creates a new Flutter-based application.
 *
 * Returns: a new #BoardGamesEmpire.
 */
BoardGamesEmpire* board_games_empire_new();

#endif  // BOARD_GAMES_EMPIRE_H
