import 'package:flutter/material.dart';
import 'package:number_crush/functions/helpers.dart';
import 'package:number_crush/providers/game_play_state.dart';
import 'package:number_crush/providers/settings_state.dart';
import 'package:number_crush/screens/game_screen/game_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late double _screenWidth = 0.0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final GamePlayState gamePlayState =
          Provider.of<GamePlayState>(context, listen: false);
      final SettingsState settingsState =
          Provider.of<SettingsState>(context, listen: false);

      final screenwidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top;
      settingsState
          .setScreenSizeData({"width": screenwidth, "height": screenHeight});
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

  // void navigateToGameScreen(GamePlayState gamePlayState,
  //     SettingsState settingsState, int levelIndex) {
  //   late Map<dynamic, dynamic> levelData = settingsState.levelData
  //       .firstWhere((element) => element["level"] == levelIndex);
  //   gamePlayState.setLevel(levelData['level']);
  //   gamePlayState.setTileData(levelData['tileData']);
  //   gamePlayState.setPreviousTileData(levelData['tileData']);
  //   gamePlayState.setRows(levelData['rows']);
  //   gamePlayState.setColumns(levelData['columns']);
  //   late Map<int, bool> targets = {};
  //   for (int i in levelData['targets']) {
  //     targets[i] = false;
  //   }
  //   gamePlayState.setTargets(targets);
  //   Navigator.of(context).pushReplacement(
  //       MaterialPageRoute(builder: (context) => const GameScreen()));
  //   Helpers().setTurnData(gamePlayState, 0);
  // }

  List<Widget> getLevelList(
      GamePlayState gamePlayState, SettingsState settingsState) {
    List<Widget> res = [];

    for (int i = 0; i < settingsState.levelData.length; i++) {
      Widget levelContainer = Container(
          width: gamePlayState.tileSize,
          height: gamePlayState.tileSize,
          child: Center(
            child: GestureDetector(
              onTap: () {
                Helpers().navigateToGameScreen(context, gamePlayState, settingsState, (i + 1));
              },
              child: Container(
                width: gamePlayState.tileSize * 0.9,
                height: gamePlayState.tileSize * 0.9,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 63, 64, 65),
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
                    (i + 1).toString(),
                    style: TextStyle(
                        fontSize: gamePlayState.tileSize * 0.3,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ));
      res.add(levelContainer);
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    late SettingsState settingsState =
        Provider.of<SettingsState>(context, listen: false);
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
                  Wrap(children: getLevelList(gamePlayState, settingsState))
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
