///scr_updateCards()
ds_list_clear(global.cardList);
        
with (obj_cards) {
    if (status == stack_normal) {
        cardID = ds_list_size(global.cardList);
        ds_list_add(global.cardList, image_index);
        
        if (!holding) depth = -cardID;
    }
}

if (ds_list_size(global.cardList) <= 16)
    global.cardView = 0;
