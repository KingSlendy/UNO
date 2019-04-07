///scr_incrementTurn(turns)
global.playerTurn += cond_exp(global.leftTurns, global.numberPlayers - argument[0], argument[0]);
global.playerTurn %= global.numberPlayers;
