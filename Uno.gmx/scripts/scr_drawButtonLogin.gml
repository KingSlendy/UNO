///scr_drawButtonLogin(x, y, width, height, color, text)
var xx = argument[0];
var yy = argument[1];
var width = argument[2];
var height = argument[3];
var color = argument[4];
var text = argument[5];
draw_set_colour(color);
draw_rectangle(xx, yy, xx + width, yy + height, false);
draw_set_colour(c_black);
draw_rectangle(xx, yy, xx + width, yy + height, true);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
scr_drawTextOutline(xx + 5, yy + height / 2, text, c_white, c_black);
draw_set_valign(fa_top);

return scr_mouseInBox(xx, yy, xx + width, yy + height);
