///scr_handlePackets(buffer, socket)
var buffer = argument[0];
var socket = argument[1];
var packetID = buffer_read(buffer, buffer_u8);

switch (packetID) {
    case 1:
        var nowID = buffer_read(buffer, buffer_u8);
        var nowName = buffer_read(buffer, buffer_string);
        var playerSize = ds_list_size(global.players);
        var listID;
        var listName;
        var count = 0;
        
        with (obj_networkPlayer) {
            if (nowID == playerID)
                playerName = nowName;
        
            listID[count] = playerID;
            listName[count] = playerName;
            count++;
        }
        
        for (var i = 0; i < playerSize; i++) {
            var socket = ds_list_find_value(global.players, i);
            buffer_seek(global.buffer, buffer_seek_start, 0);
            buffer_write(global.buffer, buffer_u8, 1);
            buffer_write(global.buffer, buffer_u8, playerSize);
            
            for (var j = 0; j < playerSize; j++) {
                buffer_write(global.buffer, buffer_u8, listID[j]);
                buffer_write(global.buffer, buffer_string, listName[j]);
            }
                
            network_send_packet(socket, global.buffer, buffer_tell(global.buffer));
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
                network_send_packet(socket, global.buffer, buffer_tell(global.buffer));
            }
        }
        break;
        
    case 5:
        var nowID = buffer_read(buffer, buffer_u8);
        var playerTurn = buffer_read(buffer, buffer_u8);
        
        for (var i = 0; i < ds_list_size(global.players); i++) {
            if (i != nowID) {
                var socket = ds_list_find_value(global.players, i);
                buffer_seek(global.buffer, buffer_seek_start, 0);
                buffer_write(global.buffer, buffer_u8, 5);
                buffer_write(global.buffer, buffer_u8, playerTurn);
                network_send_packet(socket, global.buffer, buffer_tell(global.buffer));
            }
        }
        break;
        
    default: break;
}
