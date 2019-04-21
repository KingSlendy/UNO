///scr_canAnswer(card_check)
var cardCheck = argument[0];
var cardStack = 0;

with (obj_cards) {
    if (status == stack_answer) {
        cardStack = image_index;
    }
}

return (array_contains(global.cardTypes[card_black], cardCheck) || array_contains(global.cardTypes[global.cardColor], cardCheck) || in_range(cardCheck, scr_cardDiv(cardStack), scr_cardDiv(cardStack) + 3));
