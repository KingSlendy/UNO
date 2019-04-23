///scr_drawButton(x, y, width, height, color, text)
var xx = argument[0];
var yy = argument[1];
var width = argument[2];
var height = argument[3];
var color = argument[4];
var text = argument[5];
scr_drawBox(xx, yy, xx + width, yy + height, color, 1, c_black);
draw_set_font(fnt_waiting);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
scr_drawTextOutline(xx + width / 2, yy + height / 2, text, c_white, c_black);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

return scr_mouseInBox(xx, yy, xx + width, yy + height);
