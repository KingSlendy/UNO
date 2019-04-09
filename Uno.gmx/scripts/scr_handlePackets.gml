///scr_handlePackets(buffer)
var buffer = argument[0];
var packetID = buffer_read(buffer, buffer_u8);

switch (packetID) {
    case 0:
        global.playerID = buffer_read(buffer, buffer_u8);
        alarm[0] = 1;
        break;
        
    case 1:
        var playerSize = buffer_read(buffer, buffer_u8);
        var listID;
        var listName;
        
        for (var i = 0; i < playerSize; i++) {
            listID[i] = buffer_read(buffer, buffer_u8);
            listName[i] = buffer_read(buffer, buffer_string);
        }
        
        for (var i = 0; i < playerSize; i++) {
            var exists = false;
        
            with (obj_networkPlayer) {
                if (listID[i] == networkPlayerID) {
                    exists = true;
                }
            }
            
            if (exists || listID[i] == global.playerID) continue;
            
            var remote = instance_create(0, 0, obj_networkPlayer);
            remote.networkPlayerID = listID[i];
            remote.networkPlayerName = listName[i];
        }
        break;
        
    case 2:
        var playerID = buffer_read(buffer, buffer_u8);
        
        with (obj_networkPlayer) {
            if (networkPlayerID == playerID) {
                ds_list_destroy(networkPlayerCards);
                instance_destroy();
            }
        }
        break;
        
    case 3:
        var playerID = buffer_read(buffer, buffer_u8);
        var answering = buffer_read(buffer, buffer_bool);
        var sentCards = buffer_read(buffer, buffer_u8);
        var cardSize = buffer_read(buffer, buffer_u16);
        var cardList = undefined;
        
        for (var i = 0; i < cardSize; i++)
            cardList[i] = buffer_read(buffer, buffer_u8);
        
        if (!answering) {
            with (obj_cards) {
                if (status == stack_grab) {
                    targets[playerID] = true;
                    newCards[playerID] = sentCards;
                    
                    if (!is_undefined(cardList))
                        playerList[playerID] = cardList;
                }
            }
        } else {
            with (obj_networkPlayer) {
                if (networkPlayerID == playerID) {
                    ds_list_clear(networkPlayerCards);
                    
                    if (!is_undefined(cardList)) {
                        for (var i = 0; i < array_length_1d(cardList); i++) {
                            ds_list_add(networkPlayerCards, cardList[i]);
                        }
                    }
                }
            }
        }
        break;
        
    case 4:
        var playerID = buffer_read(buffer, buffer_u8);
        var gameStarted = buffer_read(buffer, buffer_bool);
        var answering = buffer_read(buffer, buffer_bool);
        var cardStack = buffer_read(buffer, buffer_u8);
        
        if (gameStarted) {
            if (answering) {
                with (obj_networkPlayer) {
                    if (networkPlayerID == playerID) {
                        scr_playAnimation(animation_grab, obj_gameController.playerPositionX[networkPlayerID] + 100, obj_gameController.playerPositionY[networkPlayerID] + 70, 496, 352, 12, 0, cardStack, playerID);
                    }
                }
            }
        } else {
            with (obj_cards) {
                if (status == stack_answer) {
                    image_index = cardStack;
                    scr_playAnimation(animation_answer, x, y, image_index);
                }
            }
        }
        
        global.cardColor = buffer_read(buffer, buffer_u8);
        global.playerTurn = buffer_read(buffer, buffer_u8);
        global.leftTurns = buffer_read(buffer, buffer_bool);
        var sentNewCards = buffer_read(buffer, buffer_u16);
        global.sendAll = buffer_read(buffer, buffer_bool);
        
        if (global.playerTurn == global.playerID || global.sendAll)
            global.sentNewCards += sentNewCards;
        
        global.gameStarted = true;
        break;
        
    case 5: global.playerTurn = buffer_read(buffer, buffer_u8); break;  
    default: break;
}
