///scr_handlePackets(buffer)
var buffer = argument[0];
var packetID = buffer_read(buffer, buffer_u8);

switch (packetID) {
    case packets.playerJoined: global.playerID = buffer_read(buffer, buffer_u8); break;
        
    case packets.playersInfo:
        var nowID = buffer_read(buffer, buffer_u8);
        global.numberPlayers = buffer_read(buffer, buffer_u8);
        global.specialsFrecuency = buffer_read(buffer, buffer_u8);
        global.onlyQuestion = buffer_read(buffer, buffer_bool);
        global.gameMode = buffer_read(buffer, buffer_u8);
        global.teamsMode = buffer_read(buffer, buffer_bool);
        global.limitedAnswer = buffer_read(buffer, buffer_bool);
        global.limitedPlay = buffer_read(buffer, buffer_bool);
        global.maxAnswer = buffer_read(buffer, buffer_u8);
        global.maxPlay = buffer_read(buffer, buffer_u16);
        global.timeLeft = 20;
        
        if (global.limitedAnswer) global.timeLeft = global.maxAnswer;
        if (global.limitedPlay) global.timeLeft = global.maxPlay;
        
        for (var i = 0; i < global.maxPlayers; i++) {
            var checkPlayer = buffer_read(buffer, buffer_bool);
            
            if (checkPlayer) {
                var nowName = buffer_read(buffer, buffer_string);
                var nowTeam = buffer_read(buffer, buffer_u8);
                var nowPlaying = buffer_read(buffer, buffer_bool);
                var exists = false;
            
                with (obj_networkPlayer) {
                    if (i == networkPlayerID) {
                        networkPlayerTeam = nowTeam;
                        exists = true;
                    }
                }
                
                if (i == global.playerID) global.currentTeam = nowTeam;
                if (exists || i == global.playerID || (nowID != global.playerID && i != nowID) || !nowPlaying) continue;
                
                var remote = instance_create(0, 0, obj_networkPlayer);
                remote.networkPlayerID = i;
                remote.networkPlayerName = nowName;
                remote.networkPlayerTeam = nowTeam;
                remote.networkPlayerTime = global.timeLeft;
            }
        }
        
        if (room == rm_title) room_goto_next();
        break;
        
    case packets.playerLeaving:
        var playerID = buffer_read(buffer, buffer_u8);
        
        with (obj_networkPlayer) {
            if (networkPlayerID == playerID) {
                ds_list_destroy(networkPlayerCards);
                instance_destroy();
            }
        }
        break;
        
    case packets.playerCardsUpdate:
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
                    execute[playerID] = true;
                    
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
        
    case packets.playerGrabCardsUpdate:
        var playerID = buffer_read(buffer, buffer_u8);
        var sentCards = buffer_read(buffer, buffer_u8);
        
        with (obj_cards) {
            if (status == stack_grab) {
                targets[playerID] = true;
                newCards[playerID] = sentCards;
                playerList[playerID] = noone;
            }
        }
        break;
        
    case packets.playerTurnInfo:
        var playerID = buffer_read(buffer, buffer_u8);
        var gameStarted = buffer_read(buffer, buffer_bool);
        var answering = buffer_read(buffer, buffer_bool);
        var cardStack = buffer_read(buffer, buffer_u8);
        
        if (gameStarted) {
            if (answering) {
                with (obj_networkPlayer) {
                    if (networkPlayerID == playerID) {
                        scr_playAnimation(animation_grab, global.cardX[networkPlayerID], global.cardY[networkPlayerID], 496, 352, 12, 0, cardStack, playerID, false);
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
        var playerTeam = buffer_read(buffer, buffer_u8);
        global.playerAttacking = playerAttacking;
        
        if (!global.usedBoomerang) {
            if (sentNewCards > 0)
                global.playerAttacking = playerID;
        
            global.sentNewCards = 0;
        }
        
        if (global.sendAll && global.teamsMode && playerTeam == global.currentTeam)
            global.sendAll = false;
 
        if (global.playerTurn == global.playerID || global.sendAll)
            global.sentNewCards += sentNewCards;
        
        if ((global.limitedAnswer || global.limitedPlay) && global.playerTurn == global.playerID) {
            with (obj_gameController) {
                event_user(1);
            }
        }
        
        global.gameStarted = true;
        break;
        
    case packets.playerWon:
        global.playerWon = buffer_read(buffer, buffer_string);
        global.gameFinished = true;
        break;
        
    case packets.canHostJoin:
        var response = buffer_read(buffer, buffer_bool);
        var message = buffer_read(buffer, buffer_string);
        
        if (response) {
            alarm[0] = 1;
        } else {
            show_message(message);
            obj_title.fetchingHostJoin = false;
        }
        break;
        
    case packets.sentUNO:
        var playerID = buffer_read(buffer, buffer_u8);
        
        with (obj_networkPlayer) {
            if (networkPlayerID == playerID) {
                networkPlayerUNO = true;
                alarm[0] = room_speed * 2;
            }
        }
        break;
        
    case packets.sentTime:
        var playerID = buffer_read(buffer, buffer_u8);
        var timeLeft = buffer_read(buffer, buffer_u16);
        
        with (obj_networkPlayer) {
            if (networkPlayerID == playerID) {
                networkPlayerTime = timeLeft;
            }
        }
        break;
        
    case packets.chatMessage:
        if (room == rm_uno) {
            var playerID = buffer_read(buffer, buffer_u8);
            var playerName = buffer_read(buffer, buffer_string);    
            var sentMessage = buffer_read(buffer, buffer_string);
            
            with (obj_chat) {
                ds_list_add(messages, string_interp("{0}: {1}", playerName, sentMessage));
                notified = true;
                event_user(0);
            }
        }
        break;
          
    default: break;
}
