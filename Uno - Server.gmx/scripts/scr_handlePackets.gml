///scr_handlePackets(buffer, socket)
var buffer = argument[0]; //The buffer sent to the network
var sentSocket = argument[1]; //The socket of the player that sent the packet
var packetID = buffer_read(buffer, buffer_u8); //The type of packet sent

switch (packetID) {
    case 1: //Information about the players in the server. This is sent when you press "Host/Join"
        var nowID = buffer_read(buffer, buffer_u8); //Player that sent the packet
        var nowName = buffer_read(buffer, buffer_string); //Name of the player that sent the packet
        
        if (nowID == 0) //If the ID of the player is 0 read the number of players sent
            global.numberPlayers = buffer_read(buffer, buffer_u8);
        
        var playerSize = ds_list_size(global.players);
        var listName;
        var listPlaying;
        global.playingGame[nowID] = true; //Sets that player to "playing"
        
        with (obj_networkPlayer) {
            if (playerID == nowID) {
                playerName = nowName;
            }
        }
        
        for (var i = 0; i < playerSize; i++) {
            with (obj_networkPlayer) {
                if (playerID == i) {
                    listName[playerID] = playerName;
                    listPlaying[playerID] = global.playingGame[playerID];
                }
            }
        }
        
        for (var i = 0; i < playerSize; i++) {
            if (global.playingGame[i]) {
                var socket = ds_list_find_value(global.players, i);
                buffer_seek(global.buffer, buffer_seek_start, 0);
                buffer_write(global.buffer, buffer_u8, 1);
                buffer_write(global.buffer, buffer_u8, playerSize);
                buffer_write(global.buffer, buffer_u8, nowID);
                buffer_write(global.buffer, buffer_u8, global.numberPlayers);
                
                for (var j = 0; j < playerSize; j++) {
                    buffer_write(global.buffer, buffer_string, listName[j]);
                    buffer_write(global.buffer, buffer_bool, listPlaying[j]);
                }
                    
                network_send_packet(socket, global.buffer, buffer_tell(global.buffer));
            }
        }
        break;
        
    case 3:
        var nowID = buffer_read(buffer, buffer_u8);
        var answering = buffer_read(buffer, buffer_bool);
        var newCards = buffer_read(buffer, buffer_u8);
        var nowSize = buffer_read(buffer, buffer_u16);
        var cardList = undefined;
        
        for (var i = 0; i < nowSize; i++)
            cardList[i] = buffer_read(buffer, buffer_u8);

        for (var i = 0; i < ds_list_size(global.players); i++) {
            if (i != nowID) {
                var socket = ds_list_find_value(global.players, i);
                buffer_seek(global.buffer, buffer_seek_start, 0);
                buffer_write(global.buffer, buffer_u8, 3);
                buffer_write(global.buffer, buffer_u8, nowID);
                buffer_write(global.buffer, buffer_bool, answering);
                buffer_write(global.buffer, buffer_u8, newCards);
                buffer_write(global.buffer, buffer_u16, nowSize);
                
                if (!is_undefined(cardList)) {
                    for (var j = 0; j < array_length_1d(cardList); j++) {
                        buffer_write(global.buffer, buffer_u8, cardList[j]);
                    }
                }
                
                network_send_packet(socket, global.buffer, buffer_tell(global.buffer));
            }
        }
        break;
        
    case 4:
        var nowID = buffer_read(buffer, buffer_u8);
        var gameStarted = buffer_read(buffer, buffer_bool);
        var answering = buffer_read(buffer, buffer_bool);
        var cardStack = buffer_read(buffer, buffer_u8);
        var cardColor = buffer_read(buffer, buffer_u8);
        var playerTurn = buffer_read(buffer, buffer_u8);
        var leftTurns = buffer_read(buffer, buffer_bool);
        var sendCards = buffer_read(buffer, buffer_u16);
        var sendAll = buffer_read(buffer, buffer_bool);
        var usedBoomerang = buffer_read(buffer, buffer_bool);
        var playerAttacking = buffer_read(buffer, buffer_u8);
        
        for (var i = 0; i < ds_list_size(global.players); i++) {
            if (i != nowID) {
                var socket = ds_list_find_value(global.players, i);
                buffer_seek(global.buffer, buffer_seek_start, 0);
                buffer_write(global.buffer, buffer_u8, 4);
                buffer_write(global.buffer, buffer_u8, nowID);
                buffer_write(global.buffer, buffer_bool, gameStarted);
                buffer_write(global.buffer, buffer_bool, answering);
                buffer_write(global.buffer, buffer_u8, cardStack);
                buffer_write(global.buffer, buffer_u8, cardColor);
                buffer_write(global.buffer, buffer_u8, playerTurn);
                buffer_write(global.buffer, buffer_bool, leftTurns);
                buffer_write(global.buffer, buffer_u16, sendCards);
                buffer_write(global.buffer, buffer_bool, sendAll);
                buffer_write(global.buffer, buffer_bool, usedBoomerang);
                buffer_write(global.buffer, buffer_u8, playerAttacking);
                network_send_packet(socket, global.buffer, buffer_tell(global.buffer));
            }
        }
        break;
        
    case 5:
        var nowID = buffer_read(buffer, buffer_u8);
        var playerWon = buffer_read(buffer, buffer_string);
        global.playingGame[0] = false;
                
        for (var i = 0; i < ds_list_size(global.players); i++) {
            if (i != nowID) {
                var socket = ds_list_find_value(global.players, i);
                buffer_seek(global.buffer, buffer_seek_start, 0);
                buffer_write(global.buffer, buffer_u8, 5);
                buffer_write(global.buffer, buffer_string, playerWon);
                network_send_packet(socket, global.buffer, buffer_tell(global.buffer));
            }
        }
        break;
        
    case 6:
        var nowID = buffer_read(buffer, buffer_u8);
        global.playingGame[nowID] = false;
        break;
        
    case 7:
        var nowID = buffer_read(buffer, buffer_u8);
        var response = false;
        var message = "";
        
        if (nowID == 0) {
            response = array_all(global.playingGame, false);
            message = "Can't host. There's a person playing.";
        } else {
            response = (global.playingGame[0] == true);
            message = "Can't join. Player hasn't hosted a game yet.";
            
            if (response && (array_count(global.playingGame, true) >= global.numberPlayers) || nowID > global.numberPlayers - 1) {
                response = false;
                message = "Can't join. Game is already full.";
            }
        }
        
        buffer_seek(global.buffer, buffer_seek_start, 0);
        buffer_write(global.buffer, buffer_u8, 7);
        buffer_write(global.buffer, buffer_bool, response);
        buffer_write(global.buffer, buffer_string, message);
        network_send_packet(sentSocket, global.buffer, buffer_tell(global.buffer));
        break;
        
    default: break;
}
