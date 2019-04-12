///scr_drawBox(x1, y1, x2, y2, in_color, in_alpha, out_color)
for (var i = 0; i < 2; i++) {
    draw_set_alpha(cond_exp(i == 1, 1, argument[5]));
    draw_set_colour(cond_exp(i == 1, argument[6], argument[4]));
    draw_roundrect(argument[0], argument[1], argument[2], argument[3], i == 1);
}
