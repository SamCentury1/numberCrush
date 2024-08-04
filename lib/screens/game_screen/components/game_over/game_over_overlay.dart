import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:number_crush/functions/helpers.dart';
import 'package:number_crush/providers/game_play_state.dart';
import 'package:number_crush/providers/settings_state.dart';
import 'package:number_crush/settings/settings.dart';
import 'package:provider/provider.dart';

class GameOverOverlay extends StatefulWidget {
  const GameOverOverlay({super.key});

  @override
  State<GameOverOverlay> createState() => _GameOverOverlayState();
}

class _GameOverOverlayState extends State<GameOverOverlay> {
  @override
  Widget build(BuildContext context) {
    late SettingsState settingsState = Provider.of<SettingsState>(context,listen: false);
    late SettingsController settingsController = Provider.of<SettingsController>(context,listen: false);
    return Consumer<GamePlayState>(
      builder: (context,gamePlayState,child) {
        return Positioned.fill(
          child: IgnorePointer(
            ignoring: !gamePlayState.isGameOver,
            child: AnimatedOpacity(
              opacity: gamePlayState.isGameOver ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  width: settingsState.screenSizeData['width'],
                  height: settingsState.screenSizeData['height'],
                  color: Colors.black.withOpacity(0.6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 28,
                          color:  Colors.white,
                        ),
                        textAlign: TextAlign.center,                        
                        child: Text(
                          "Congratulations!",
                        ),
                      ),
                      const SizedBox(height: 20,),
                      DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 24,
                          color:  Colors.white
                        ),
                        textAlign: TextAlign.center,                        
                        child: Text("You completed the puzzle in ${gamePlayState.turnData.length} turns"),
                      ),
                      const SizedBox(height: 20,),
                      GestureDetector(
                        onTap: () {
                          gamePlayState.setIsGameOver(false);
                          late Map<dynamic, dynamic> levelData =  settingsState.levelData.firstWhere(
                            (element) => element["level"] == gamePlayState.level
                          );
                          gamePlayState.setLevel(levelData['level']);
                          Map<dynamic, dynamic> tileData = Helpers().deepCopyTileData(levelData['tileData']);
                          gamePlayState.setTileData(tileData);
                          gamePlayState.setRows(levelData['rows']);
                          gamePlayState.setColumns(levelData['columns']);
                          gamePlayState.setTurnData([]);
                          gamePlayState.setLives(5);
                          late Map<int, bool> targets = {};
                          for (int i in levelData['targets']) {
                            targets[i] = false;
                          }
                          gamePlayState.setTargets(targets);
                        },
                        child: Container(
                          color:  Color.fromARGB(255, 63, 64, 65),
                          // height: gamePlayState.tileSize * 0.8,
                          width: gamePlayState.tileSize * gamePlayState.columns,
                          child: Padding(
                            padding: EdgeInsets.all(gamePlayState.tileSize*0.05),
                            child: const Center(
                              child: DefaultTextStyle(
                                style: TextStyle(
                                  fontSize: 28, color: Colors.white
                                ),
                                textAlign: TextAlign.center,                              
                                child: Text("Play Again?",),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox( height: gamePlayState.tileSize * 0.25,),
                      GestureDetector(
                        onTap: () {
                          Map<dynamic,dynamic> dataCopy = {};
                          settingsState.playerProgress.forEach((key,value) {
                            if (int.parse(key) == int.parse(gamePlayState.level.toString())) {
                              if (gamePlayState.turnData.length > value) {
                                dataCopy[key] = gamePlayState.turnData.length;
                              } else {
                                dataCopy[key] = value;
                              }
                            } else {
                              dataCopy[key] = value;
                            }
                          });
                          Map<String, dynamic> serializableMap = dataCopy.map(
                            (key, value) => MapEntry(key.toString(), value),
                          );
                          final jsonEncoded = jsonEncode(serializableMap);                          
                          settingsController.setUserData(jsonEncoded);
                          gamePlayState.setIsGameOver(false);
                          Helpers().navigateToGameScreen(
                            context,
                            gamePlayState,
                            settingsState,
                            gamePlayState.level + 1
                          );
                        },
                        child: Container(
                          color:  Color.fromARGB(255, 63, 64, 65),
                          // height: gamePlayState.tileSize * 0.8,
                          width: gamePlayState.tileSize * gamePlayState.columns,
                          child: Padding(
                            padding: EdgeInsets.all(gamePlayState.tileSize*0.05),
                            child: const Center(
                              child: DefaultTextStyle(
                                style: TextStyle(
                                  fontSize: 28, color: Colors.white
                                ),
                                textAlign: TextAlign.center,
                                child: Text("Next Level",),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        );
      }
    );    
  }
}