///scr_drawTextOutline(x, y, text, text_color, outline_color)
var xx = argument[0];
var yy = argument[1];
var text = argument[2];

draw_set_colour(argument[4]);
draw_text(xx + 1, yy + 1, text);
draw_text(xx - 1, yy - 1, text);
draw_text(xx, yy + 1, text);
draw_text(xx + 1, yy, text);
draw_text(xx, yy - 1, text);
draw_text(xx - 1, yy, text);
draw_text(xx - 1, yy + 1, text);
draw_text(xx + 1, yy - 1, text);
draw_set_colour(argument[3]);
draw_text(xx, yy, text);
