///scr_drawTextExtOutline(x, y, text, text_color, outline_color, sep, w)
var xx = argument[0];
var yy = argument[1];
var text = argument[2];
var sep = argument[5];
var w = argument[6];

draw_set_colour(argument[4]);
draw_text_ext(xx + 1, yy + 1, text, sep, w);
draw_text_ext(xx - 1, yy - 1, text, sep, w);
draw_text_ext(xx, yy + 1, text, sep, w);
draw_text_ext(xx + 1, yy, text, sep, w);
draw_text_ext(xx, yy - 1, text, sep, w);
draw_text_ext(xx - 1, yy, text, sep, w);
draw_text_ext(xx - 1, yy + 1, text, sep, w);
draw_text_ext(xx + 1, yy - 1, text, sep, w);
draw_set_colour(argument[3]);
draw_text_ext(xx, yy, text, sep, w);
