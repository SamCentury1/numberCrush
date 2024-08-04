import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:number_crush/functions/helpers.dart';
import 'package:number_crush/providers/game_play_state.dart';
import 'package:number_crush/providers/settings_state.dart';
import 'package:number_crush/screens/game_screen/game_screen.dart';
import 'package:number_crush/settings/settings.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  Future<Object> getJsonData(SettingsController settingsController, SettingsState settingsState) async {
    Map<String, dynamic> serializableMap = settingsState.playerProgress.map(
      (key, value) => MapEntry(key.toString(), value),
    );
    final jsonEncoded = jsonEncode(serializableMap);
    return jsonEncoded;
  }

  late double _screenWidth = 0.0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final GamePlayState gamePlayState = Provider.of<GamePlayState>(context, listen: false);
      final SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);
      final SettingsController settingsController = Provider.of<SettingsController>(context, listen: false);

      if (settingsController.userData.value.toString() == "{}") {
        print("no data");
        print(settingsController.userData.value.toString());
        final Object jsonEncoded = await getJsonData(settingsController,settingsState);
        settingsController.setUserData(jsonEncoded);
      } else {
        print("there is data");
        print(settingsController.userData.value.toString());
        final Map<dynamic, dynamic> decodedMap = jsonDecode(settingsController.userData.value.toString());
        settingsState.setPlayerProgress(decodedMap);
      }

      final screenwidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
      settingsState.setScreenSizeData({"width": screenwidth, "height": screenHeight});
      _screenWidth = screenwidth;

      final double playAreaHeight = screenHeight;
      final double playAreaWidth = screenwidth > 600.0 ? 600.0 : screenwidth;
      final double minTileSize = playAreaHeight / 9;
      final double maxTileSize = (playAreaWidth * 0.95) / 6;
      late double tileSize = 0.0;

      if (minTileSize > maxTileSize) {
        tileSize = maxTileSize;
      } else {
        tileSize = minTileSize;
      }
      gamePlayState.setTileSize(tileSize);
    });
  }

  // List<Widget> getLevelList(GamePlayState gamePlayState, SettingsState settingsState) {
  List<Widget> getLevelList(GamePlayState gamePlayState,SettingsState settingsState, Map<dynamic,dynamic> progressData) {
    List<Widget> res = [];

    // for (int i = 0; i < settingsState.levelData.length; i++) {
      progressData.forEach((key,value) {
        Widget levelContainer = Container(
            width: gamePlayState.tileSize,
            height: gamePlayState.tileSize,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Helpers().navigateToGameScreen(context, gamePlayState, settingsState, int.parse(key));
                },
                child: Container(
                  width: gamePlayState.tileSize * 0.9,
                  height: gamePlayState.tileSize * 0.9,
                  decoration: BoxDecoration(
                      color: value > 0 ? Color.fromARGB(255, 63, 64, 65): Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(209, 150, 151, 151),
                          offset: Offset(-2.0, 2.0),
                          blurRadius: 0.0,
                          spreadRadius: 0.0,
                        )
                      ]),
                  child: Center(
                    child: Text(
                      (key).toString(),
                      style: TextStyle(
                          fontSize: gamePlayState.tileSize * 0.3,
                          color: value > 0 ? Colors.white : Color.fromARGB(255, 63, 64, 65),
                        ),
                    ),
                  ),
                ),
              ),
            ));
        res.add(levelContainer);
      });
    // }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    late SettingsState settingsState = Provider.of<SettingsState>(context, listen: false);
    // late SettingsController settingsController = Provider.of<SettingsController>(context, listen: false);

    // if (settingsController.userData.value == "") {
    //   settingsController.setUserData(settingsState.playerProgress);
    // } else {
    //   settingsState.setPlayerProgress(settingsController.userData.value as Map<dynamic,dynamic>);
    // }


    return Scaffold(
      body: SafeArea(
        child: Consumer<GamePlayState>(builder: (context, gamePlayState, child) {
          return Container(
            width: _screenWidth,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: gamePlayState.tileSize,
                  ),
                  Container(
                    width: gamePlayState.tileSize * 6,
                    height: gamePlayState.tileSize,
                    child: Center(
                      child: Text(
                        "Levels",
                        style:
                            TextStyle(fontSize: gamePlayState.tileSize * 0.5),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: gamePlayState.tileSize * 0.5,
                  ),
                  Wrap(children: getLevelList(gamePlayState, settingsState, settingsState.playerProgress))
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
