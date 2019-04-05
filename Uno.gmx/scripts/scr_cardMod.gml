///scr_cardMod(value, range)
var value = argument[0];
var range = argument[1];

while (value > range)
    value -= range;
    
return value;
