import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/widgets/custom_textfield.dart';
import '../provider/room_data_provider.dart';

class WaitingLobby extends StatefulWidget {
  const WaitingLobby({super.key});

  @override
  State<WaitingLobby> createState() => _WaitingLobbyState();
}

class _WaitingLobbyState extends State<WaitingLobby> {
  late TextEditingController _roomIdController;

  @override
  void initState() {
    super.initState();
    _roomIdController = TextEditingController(
      text: context.read<RoomDataProvider>().roomData['_id'],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _roomIdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('waiting for a player to join...'),
        const SizedBox(height: 20),
        CustomTextField(
          controller: _roomIdController,
          hintText: _roomIdController.text,
          isReadOnly: true,
        ),
      ],
    );
  }
}
