///scr_playerInfo(x, y, playerID, playerName, playerTeam, playerCards, playerUNO, playerTime)
var xx = argument[0];
var yy = argument[1];
var playerID = argument[2];
var playerName = argument[3];
var playerTeam = argument[4];
var playerCards = argument[5];
var playerUNO = argument[6];
var playerTime = argument[7];
var boxSize = cond_exp(playerID == global.playerID || (global.teamsMode && playerTeam == global.currentTeam), 80, 140);

scr_drawBox(xx, yy, xx + 200, yy + boxSize, cond_exp(global.gameStarted && !global.gameFinished && global.playerTurn == playerID, c_yellow, c_white), 1, c_black);
draw_sprite(spr_playerIcon, 0, xx + 16, yy + 16);
scr_drawTextOutline(xx + 38, yy + 3, playerName, c_white, c_black);

if (!global.teamsMode) {
    draw_sprite(spr_cardIcon, 0, xx + 14, yy + 52);
} else {
    draw_sprite(spr_cardIcon, playerTeam + 1, xx + 14, yy + 52);
}

scr_drawTextOutline(xx + 30, yy + 38, string(playerCards), c_white, c_black);

if (playerUNO) draw_sprite(spr_UNO, 0, xx + 65, yy + 38);

if (global.limitedAnswer || global.limitedPlay) {
    draw_sprite(spr_clock, 0, xx + 120, yy + 38);
    scr_drawTextOutline(xx + 145, yy + 38, scr_formattedTime(playerTime), c_white, c_black);
}
