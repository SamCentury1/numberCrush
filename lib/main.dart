import 'package:flutter/material.dart';
import 'package:number_crush/providers/game_play_state.dart';
import 'package:number_crush/providers/settings_state.dart';
import 'package:number_crush/screens/home_screen/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GamePlayState()),
        ChangeNotifierProvider(create: (_) => SettingsState())
      ],
      child: const MaterialApp(
        title: 'Number Crush',
        home: HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
