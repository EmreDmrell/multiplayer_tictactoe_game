import 'package:flutter/material.dart';
import 'package:tictactoe/screens/create_room_screen.dart';
import 'package:tictactoe/screens/join_room_screen.dart';
import 'package:tictactoe/screens/main_menu_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case MainMenuScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const MainMenuScreen(),
      );
    case CreateRoomScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const CreateRoomScreen(),
      );
    case JoinRoomScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const JoinRoomScreen(),
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder:
            (_) => const Scaffold(
              body: Center(child: Text("Page does not exist")),
            ),
      );
  }
}
