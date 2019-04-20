///scr_handlePackets(buffer)
var buffer = argument[0];
var packetID = buffer_read(buffer, buffer_u8);

switch (packetID) {
    case 0: global.playerID = buffer_read(buffer, buffer_u8); break;
        
    case 1:
        playerSize = buffer_read(buffer, buffer_u8);
        var nowID = buffer_read(buffer, buffer_u8);
        global.numberPlayers = buffer_read(buffer, buffer_u8);
        
        for (var i = 0; i < playerSize; i++) {
            var nowName = buffer_read(buffer, buffer_string);
            var nowPlaying = buffer_read(buffer, buffer_bool);
            var exists = false;
        
            with (obj_networkPlayer)
                exists = (i == networkPlayerID);

            if (exists || i == global.playerID || (nowID != global.playerID && i != nowID) || !nowPlaying) continue;
            
            var remote = instance_create(0, 0, obj_networkPlayer);
            remote.networkPlayerID = i;
            remote.networkPlayerName = nowName;
        }
        
        if (room == rm_title) room_goto_next();
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
        global.usedBoomerang = buffer_read(buffer, buffer_bool);
        var playerAttacking = buffer_read(buffer, buffer_u8);
        global.playerAttacking = playerAttacking;
        
        if (!global.usedBoomerang) {
            if (sentNewCards > 0)
                global.playerAttacking = playerID;
        
            global.sentNewCards = 0;
        }
 
        if (global.playerTurn == global.playerID || global.sendAll)
            global.sentNewCards += sentNewCards;
        
        global.gameStarted = true;
        break;
        
    case 5:
        global.playerWon = buffer_read(buffer, buffer_string);
        global.gameFinished = true;
        break;
        
    case 7:
        var response = buffer_read(buffer, buffer_bool);
        var message = buffer_read(buffer, buffer_string);
        
        if (response) {
            alarm[0] = 1;
        } else {
            show_message(message);
        }
        break;
          
    default: break;
}
