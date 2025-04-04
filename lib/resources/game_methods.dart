import 'package:flutter/material.dart';
import 'package:tictactoe/provider/room_data_provider.dart';
import 'package:tictactoe/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class GameMethods {
  void checkWinner(BuildContext context, Socket SocketClient) {
    RoomDataProvider rdp = Provider.of<RoomDataProvider>(
      context,
      listen: false,
    );

    String winner = '';

    //Checking Rows
    if (rdp.displayElements[0] == rdp.displayElements[1] &&
        rdp.displayElements[0] == rdp.displayElements[2] &&
        rdp.displayElements[0] != '') {
      winner = rdp.displayElements[0];
    }
    if (rdp.displayElements[3] == rdp.displayElements[4] &&
        rdp.displayElements[3] == rdp.displayElements[5] &&
        rdp.displayElements[3] != '') {
      winner = rdp.displayElements[3];
    }
    if (rdp.displayElements[6] == rdp.displayElements[7] &&
        rdp.displayElements[6] == rdp.displayElements[8] &&
        rdp.displayElements[6] != '') {
      winner = rdp.displayElements[6];
    }

    // Checking Column
    if (rdp.displayElements[0] == rdp.displayElements[3] &&
        rdp.displayElements[0] == rdp.displayElements[6] &&
        rdp.displayElements[0] != '') {
      winner = rdp.displayElements[0];
    }
    if (rdp.displayElements[1] == rdp.displayElements[4] &&
        rdp.displayElements[1] == rdp.displayElements[7] &&
        rdp.displayElements[1] != '') {
      winner = rdp.displayElements[1];
    }
    if (rdp.displayElements[2] == rdp.displayElements[5] &&
        rdp.displayElements[2] == rdp.displayElements[8] &&
        rdp.displayElements[2] != '') {
      winner = rdp.displayElements[2];
    }

    // Checking Diagonal
    if (rdp.displayElements[0] == rdp.displayElements[4] &&
        rdp.displayElements[0] == rdp.displayElements[8] &&
        rdp.displayElements[0] != '') {
      winner = rdp.displayElements[0];
    }
    if (rdp.displayElements[2] == rdp.displayElements[4] &&
        rdp.displayElements[2] == rdp.displayElements[6] &&
        rdp.displayElements[2] != '') {
      winner = rdp.displayElements[2];
    } else if (rdp.filledBoxes == 9) {
      winner = '';
      showGameDialog(context, 'Draw');
    }

    if (winner != '') {
      if (rdp.player1.playerType == winner) {
        showGameDialog(context, '${rdp.player1.nickname} won!');
        SocketClient.emit("winner", {
          'winnerSocketID': rdp.player1.socketID,
          'roomID': rdp.roomData['_id'],
        });
      } else {
        showGameDialog(context, '${rdp.player2.nickname} won!');
        SocketClient.emit("winner", {
          'winnerSocketID': rdp.player2.socketID,
          'roomID': rdp.roomData['_id'],
        });
      }
    }
  }

  void clearBoard(BuildContext context) {
    RoomDataProvider rdp = Provider.of<RoomDataProvider>(
      context,
      listen: false,
    );

    for (int i = 0; i < rdp.displayElements.length; i++) {
      rdp.updateDisplayElements(i, '');
    }

    rdp.setFilledBoxTo0();
  }
}
