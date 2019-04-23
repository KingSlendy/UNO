///scr_drawCell(x, y, condition, text)
var xx = argument[0];
var yy = argument[1];
var condition = argument[2];
var text = argument[3];
var size = 24;
scr_drawBox(xx, yy, xx + size, yy + size, cond_exp(condition, c_lime, c_white), 1, c_black);
draw_set_font(fnt_login);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
scr_drawTextOutline(xx + size + 6, yy + size / 2, text, c_white, c_black);
draw_set_valign(fa_top);

return scr_mouseInBox(xx, yy, xx + size, yy + size);
