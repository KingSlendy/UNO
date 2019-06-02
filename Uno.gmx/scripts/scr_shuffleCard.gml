///scr_shuffleCard()
switch (global.gameMode) {
    case mode_traditional:
        cards = array_shuffle(global.cardTypes[cards_traditional]);
        image_index = cards[0];
        break;
        
    default: image_index = irandom(image_number - 2) + 1; break;
}
