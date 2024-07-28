import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:number_crush/functions/game_logic.dart';
import 'package:number_crush/functions/helpers.dart';
import 'package:number_crush/providers/game_play_state.dart';
import 'package:number_crush/providers/settings_state.dart';
import 'package:number_crush/screens/game_screen/components/tile_widget.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late SettingsState settingsState;
  // late GamePlayState gamePlayState;
  @override
  void initState() {
    super.initState();
    settingsState = Provider.of<SettingsState>(context, listen: false);
  }

  List<Widget> getTargetElements(GamePlayState gamePlayState) {
    final Map<dynamic, dynamic> items = gamePlayState.targets;
    late List<Widget> res = [];
    items.forEach((key, value) {
      Widget targetWidget = Container(
        width: gamePlayState.tileSize * 0.5,
        height: gamePlayState.tileSize * 0.5,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(60.0)),
            border: Border.all(
              color: value ? Colors.green : Colors.grey.withOpacity(0.5),
              width: gamePlayState.tileSize * 0.05,
            )),
        child: Center(
          child: Text(key.toString(),
              style: TextStyle(
                fontSize: gamePlayState.tileSize * 0.2,
              )),
        ),
      );
      res.add(targetWidget);
    });

    return res;
  }

  List<Widget> getTileElements(GamePlayState gamePlayState) {
    late List<Widget> res = [];
    final Map<dynamic, dynamic> items = gamePlayState.tileData;
    items.forEach((key, value) {
      Widget tile = TileWidget(index: key);
      res.add(tile);
    });

    if (gamePlayState.isDragging) {
      int? draggedTileIndex = gamePlayState.dragStartTileIndex;
      res.removeAt(draggedTileIndex!);
      Widget tile = TileWidget(index: draggedTileIndex!);
      res.add(tile);
    }

    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GamePlayState>(builder: (context, gamePlayState, child) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Center(child: Text("Level ${gamePlayState.level}")),
            actions: [
              PopupMenuButton<int>(
                  itemBuilder: (context) => [
                        PopupMenuItem(
                          child: Text("Main Menu"),
                          onTap: () {
                            Helpers().navigateToMainMenu(context);
                          },
                        ),
                        PopupMenuItem(
                          child: Text("Restart"),
                          onTap: () {
                            Helpers().navigateToGameScreen(
                                context,
                                gamePlayState,
                                settingsState,
                                gamePlayState.level);
                          },
                        ),
                      ])
            ],
          ),
          body: Stack(
            children: [
              SizedBox(
                width: settingsState.screenSizeData['width'],
                height: settingsState.screenSizeData['height'],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: gamePlayState.tileSize * gamePlayState.columns,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                gamePlayState.turnData.length.toString(),
                                style: TextStyle(fontSize: 24),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.touch_app,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: gamePlayState.tileSize * gamePlayState.columns,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for (int i = 0; i < gamePlayState.lives; i++)
                                Icon(Icons.replay_circle_filled_sharp)
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: gamePlayState.tileSize * gamePlayState.columns,
                      height: gamePlayState.tileSize,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: getTargetElements(gamePlayState),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: gamePlayState.tileSize * 0.2,
                    ),
                    GestureDetector(
                      onPanStart: (details) =>
                          GameLogic().executePanStart(gamePlayState, details),
                      onPanUpdate: (details) =>
                          GameLogic().executePanUpdate(gamePlayState, details),
                      onPanEnd: (details) =>
                          GameLogic().executePanEnd(gamePlayState, details),
                      child: Container(
                          width: gamePlayState.tileSize * gamePlayState.columns,
                          height: gamePlayState.tileSize * gamePlayState.rows,
                          color: Color.fromRGBO(233, 233, 233, 1),
                          child: Stack(
                            children: getTileElements(gamePlayState),
                          )),
                    ),
                    SizedBox(
                        width: gamePlayState.tileSize,
                        height: gamePlayState.tileSize,
                        child: Center(
                          child: IconButton(
                              onPressed: () =>
                                  GameLogic().executeUndo(gamePlayState),
                              icon: Icon(Icons.replay_circle_filled_sharp)),
                        )),
                  ],
                ),
              ),
              Positioned.fill(
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
                      color: Colors.black.withOpacity(0.2),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Congratulations!",
                            style: TextStyle(
                              fontSize: 28,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "You completed the puzzle in ${gamePlayState.turnData.length} turns",
                            style: TextStyle(
                              fontSize: 24,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              gamePlayState.setIsGameOver(false);
                              late Map<dynamic, dynamic> levelData =
                                  settingsState.levelData.firstWhere(
                                      (element) =>
                                          element["level"] ==
                                          gamePlayState.level);
                              gamePlayState.setLevel(levelData['level']);
                              Map<dynamic, dynamic> tileData = Helpers()
                                  .deepCopyTileData(levelData['tileData']);
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
                              color: Colors.black,
                              // height: gamePlayState.tileSize * 0.8,
                              width: gamePlayState.tileSize *
                                  gamePlayState.columns,
                              child: Center(
                                child: Text(
                                  "Play Again?",
                                  style: TextStyle(
                                      fontSize: 28, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: gamePlayState.tileSize * 0.25,
                          ),
                          GestureDetector(
                            onTap: () {
                              print("next level");
                              gamePlayState.setIsGameOver(false);
                              Helpers().navigateToGameScreen(
                                  context,
                                  gamePlayState,
                                  settingsState,
                                  gamePlayState.level + 1);
                            },
                            child: Container(
                              color: Colors.black,
                              // height: gamePlayState.tileSize * 0.8,
                              width: gamePlayState.tileSize *
                                  gamePlayState.columns,
                              child: Center(
                                child: Text(
                                  "Next Level",
                                  style: TextStyle(
                                      fontSize: 28, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ))
            ],
          ),
        ),
      );
    });
  }
}
