///scr_cardDiv(value)
var value = argument[0];

if (value % 4 == 0)
    value--;

while (value % 4 != 0)
    value--;

return value + 1;
