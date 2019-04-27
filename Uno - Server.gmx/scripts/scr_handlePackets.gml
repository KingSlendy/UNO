///scr_handlePackets(buffer, socket)
var buffer = argument[0];
var sentSocket = argument[1];
var packetID = buffer_read(buffer, buffer_u8);

switch (packetID) {
    case packets.playersInfo:
        var sentID = buffer_read(buffer, buffer_u8);
        var sentName = buffer_read(buffer, buffer_string);
        
        if (sentID == 0) {
            global.numberPlayers = buffer_read(buffer, buffer_u8);
            global.specialsFrecuency = buffer_read(buffer, buffer_u8);
            global.onlyQuestion = buffer_read(buffer, buffer_bool);
            global.gameMode = buffer_read(buffer, buffer_u8);
            global.teamsMode = buffer_read(buffer, buffer_bool);
            global.limitedAnswer = buffer_read(buffer, buffer_bool);
            global.limitedPlay = buffer_read(buffer, buffer_bool);
            global.maxAnswer = buffer_read(buffer, buffer_u8);
            global.maxPlay = buffer_read(buffer, buffer_u16);
            
            if (irandom(1) == 0) {
                global.teams = new_array(team_red, team_blue, team_red, team_blue);;
            } else {
                global.teams = new_array(team_blue, team_red, team_blue, team_red);
            }
        }
        
        var player = global.players[sentID, player_object];
        player.playerName = sentName;
        player.playerTeam = global.teams[sentID];
        global.playingGame[sentID] = true;
        
        for (var i = 0; i < global.maxPlayers; i++) {
            var socket = global.players[i, player_socket];
        
            if (socket != -1 && global.playingGame[i]) {
                buffer_seek(global.buffer, buffer_seek_start, 0);
                buffer_write(global.buffer, buffer_u8, packets.playersInfo);
                buffer_write(global.buffer, buffer_u8, sentID);
                buffer_write(global.buffer, buffer_u8, global.numberPlayers);
                buffer_write(global.buffer, buffer_u8, global.specialsFrecuency);
                buffer_write(global.buffer, buffer_bool, global.onlyQuestion);
                buffer_write(global.buffer, buffer_u8, global.gameMode);
                buffer_write(global.buffer, buffer_bool, global.teamsMode);
                buffer_write(global.buffer, buffer_bool, global.limitedAnswer);
                buffer_write(global.buffer, buffer_bool, global.limitedPlay);
                buffer_write(global.buffer, buffer_u8, global.maxAnswer);
                buffer_write(global.buffer, buffer_u16, global.maxPlay);
                
                for (var j = 0; j < global.maxPlayers; j++) {
                    player = global.players[j, player_object];
                    buffer_write(global.buffer, buffer_bool, player != -1);
                    
                    if (player != -1) {
                        buffer_write(global.buffer, buffer_string, player.playerName);
                        buffer_write(global.buffer, buffer_u8, player.playerTeam);
                        buffer_write(global.buffer, buffer_bool, global.playingGame[j]);
                    }
                }
                    
                network_send_packet(socket, global.buffer, buffer_tell(global.buffer));
            }
        }
        break;
        
    case packets.playerCardsUpdate:
        var sentID = buffer_read(buffer, buffer_u8);
        var answering = buffer_read(buffer, buffer_bool);
        var newCards = buffer_read(buffer, buffer_u8);
        var nowSize = buffer_read(buffer, buffer_u16);
        var cardList = undefined;
        
        for (var i = 0; i < nowSize; i++)
            cardList[i] = buffer_read(buffer, buffer_u8);

        for (var i = 0; i < global.maxPlayers; i++) {
            var socket = global.players[i, player_socket];
        
            if (i != sentID && socket != -1) {
                buffer_seek(global.buffer, buffer_seek_start, 0);
                buffer_write(global.buffer, buffer_u8, packets.playerCardsUpdate);
                buffer_write(global.buffer, buffer_u8, sentID);
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
        
    case packets.playerTurnInfo:
        var sentID = buffer_read(buffer, buffer_u8);
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
        var playerTeam = buffer_read(buffer, buffer_u8);
        
        for (var i = 0; i < global.maxPlayers; i++) {
            var socket = global.players[i, player_socket];
        
            if (i != sentID && socket != -1) {
                buffer_seek(global.buffer, buffer_seek_start, 0);
                buffer_write(global.buffer, buffer_u8, packets.playerTurnInfo);
                buffer_write(global.buffer, buffer_u8, sentID);
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
                buffer_write(global.buffer, buffer_u8, playerTeam);
                network_send_packet(socket, global.buffer, buffer_tell(global.buffer));
            }
        }
        break;
        
    case packets.playerWon:
        var sentID = buffer_read(buffer, buffer_u8);
        var playerWon = buffer_read(buffer, buffer_string);
        global.playingGame[0] = false;
                
        for (var i = 0; i < global.maxPlayers; i++) {
            var socket = global.players[i, player_socket];
        
            if (i != sentID && socket != -1) {
                buffer_seek(global.buffer, buffer_seek_start, 0);
                buffer_write(global.buffer, buffer_u8, packets.playerWon);
                buffer_write(global.buffer, buffer_string, playerWon);
                network_send_packet(socket, global.buffer, buffer_tell(global.buffer));
            }
        }
        break;
        
    case packets.playerStopPlaying:
        var sentID = buffer_read(buffer, buffer_u8);
        global.playingGame[sentID] = false;
        
        for (var i = 0; i < global.maxPlayers; i++) {
            var socket = global.players[i, player_socket];
        
            if (i != sentID && socket != -1) {
                buffer_seek(global.buffer, buffer_seek_start, 0);
                buffer_write(global.buffer, buffer_u8, packets.playerLeaving);
                buffer_write(global.buffer, buffer_u8, sentID);
                network_send_packet(socket, global.buffer, buffer_tell(global.buffer));
            }
        }
        break;
        
    case packets.canHostJoin:
        var sentID = buffer_read(buffer, buffer_u8);
        var response = false;
        var message = "";
        
        if (sentID == 0) {
            response = array_all(global.playingGame, false);
            message = "Can't host. There's a person playing.";
        } else {
            response = (global.playingGame[0] == true);
            message = "Can't join. Player hasn't hosted a game yet.";
            
            if (response && (array_count(global.playingGame, true) >= global.numberPlayers) || sentID > global.numberPlayers - 1) {
                response = false;
                message = "Can't join. Game is already full.";
            }
        }
        
        buffer_seek(global.buffer, buffer_seek_start, 0);
        buffer_write(global.buffer, buffer_u8, packets.canHostJoin);
        buffer_write(global.buffer, buffer_bool, response);
        buffer_write(global.buffer, buffer_string, message);
        network_send_packet(sentSocket, global.buffer, buffer_tell(global.buffer));
        break;
        
    case packets.sentUNO:
        var sentID = buffer_read(buffer, buffer_u8);
        
        for (var i = 0; i < global.maxPlayers; i++) {
            var socket = global.players[i, player_socket];
            
            if (socket != -1 && sentID != i) {
                buffer_seek(global.buffer, buffer_seek_start, 0);
                buffer_write(global.buffer, buffer_u8, packets.sentUNO);
                buffer_write(global.buffer, buffer_u8, sentID);
                network_send_packet(socket, global.buffer, buffer_tell(global.buffer));
            }
        }
        break;
        
    case packets.sentTime:
        var sentID = buffer_read(buffer, buffer_u8);
        var timeLeft = buffer_read(buffer, buffer_u16);
        
        for (var i = 0; i < global.maxPlayers; i++) {
            var socket = global.players[i, player_socket];
            
            if (socket != -1 && sentID != i) {
                buffer_seek(global.buffer, buffer_seek_start, 0);
                buffer_write(global.buffer, buffer_u8, packets.sentTime);
                buffer_write(global.buffer, buffer_u8, sentID);
                buffer_write(global.buffer, buffer_u16, timeLeft);
                network_send_packet(socket, global.buffer, buffer_tell(global.buffer));
            }
        }
        break;
        
    default: break;
}
