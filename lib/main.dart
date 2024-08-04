import 'package:flutter/material.dart';
import 'package:number_crush/providers/animation_state.dart';
import 'package:number_crush/providers/game_play_state.dart';
import 'package:number_crush/providers/settings_state.dart';
import 'package:number_crush/screens/home_screen/home_screen.dart';
import 'package:number_crush/settings/persistence/local_storage_persistence.dart';
import 'package:number_crush/settings/persistence/settings_persistence.dart';
import 'package:number_crush/settings/settings.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp(
    settingsPersistence: LocalStorageSettingsPersistence(),
  ));
}

class MyApp extends StatelessWidget {
  final SettingsPersistence settingsPersistence;
  const MyApp({
    super.key,
    required this.settingsPersistence,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GamePlayState()),
        ChangeNotifierProvider(create: (_) => SettingsState()),
        ChangeNotifierProvider(create: (_) => AnimationState()),
        Provider<SettingsController>(
          lazy: false,
          create: (context) => SettingsController(
            persistence: settingsPersistence,
          )..loadStateFromPerisitence(),
        ),        
      ],
      child: const MaterialApp(
        title: 'Number Crush',
        home: HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
