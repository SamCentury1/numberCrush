import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:number_crush/functions/game_logic.dart';
import 'package:number_crush/functions/helpers.dart';
import 'package:number_crush/providers/animation_state.dart';
import 'package:number_crush/providers/game_play_state.dart';
import 'package:number_crush/providers/settings_state.dart';
import 'package:number_crush/screens/game_screen/components/number_found_widget.dart';
import 'package:number_crush/screens/game_screen/components/plus_minus_widget.dart';
import 'package:number_crush/screens/game_screen/components/targets/target_animation.dart';
import 'package:number_crush/screens/game_screen/components/targets/target_widget.dart';
// import 'package:number_crush/screens/game_screen/components/targets/target_widget.dart';
import 'package:number_crush/screens/game_screen/components/tile_widget.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late SettingsState settingsState;
  late AnimationState animationState;
  late GamePlayState gamePlayState;
  late AnimationController shadowController;

  late Animation<double> shadowAnimation;
  late Animation<double> plusMinusPositionAnimation;
  late Animation<double> plusMinusOpacityAnimation;
  late Animation<double> tileBodySizeAnimation;
  late Animation<double> tileTextShadowAnimation;

  late AnimationController numberFoundController;
  

  @override
  void initState() {
    super.initState();
    animationState = Provider.of<AnimationState>(context, listen: false);
    settingsState = Provider.of<SettingsState>(context, listen: false);
    gamePlayState = Provider.of<GamePlayState>(context, listen: false);
    initializeAnimations();
    animationState.addListener(handleAnimationStateChange);
  }

  void initializeAnimations() {
    shadowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    final List<TweenSequenceItem<double>> shadowSequence = [
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0,end: 1.0,),weight: 20.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.0,end: 0.0,),weight: 20.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0,end: 0.0,),weight: 60.0),
    ];
    shadowAnimation = TweenSequence<double>(shadowSequence).animate(shadowController);

    final List<TweenSequenceItem<double>> plusMinusOpacitySequence = [
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.0,end: 1.0,),weight: 60.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.0,end: 0.0,),weight: 40.0),
    ];
    plusMinusOpacityAnimation = TweenSequence<double>(plusMinusOpacitySequence).animate(shadowController);

    final List<TweenSequenceItem<double>> plusMinusPositionSequence = [
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0,end: 0.8,),weight: 60.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.8,end: 1.0,),weight: 40.0),
    ];
    plusMinusPositionAnimation =TweenSequence<double>(plusMinusPositionSequence).animate(shadowController);

    final List<TweenSequenceItem<double>> tileBodySizeSequence = [
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0,end: 1.1,),weight: 30.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.1,end: 1.0,),weight: 10.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.0,end: 1.0,),weight: 60.0),
    ];    
    tileBodySizeAnimation =TweenSequence<double>(tileBodySizeSequence).animate(shadowController);

    final List<TweenSequenceItem<double>> tileTextShadowSequence = [
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0,end: 1.0,),weight: 30.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.0,end: 0.0,),weight: 10.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0,end: 0.0,),weight: 60.0),
    ];    
    tileTextShadowAnimation =TweenSequence<double>(tileTextShadowSequence).animate(shadowController);    

    shadowController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationState.setShouldRunOperationAnimation(false);
      }
    });




    numberFoundController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );


    numberFoundController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationState.setShouldRunNumberFoundAnimation(false);
      }
    });     
  }

  void handleAnimationStateChange() {
    if (animationState.shouldRunOperationAnimation) {
      executeAnimations();
    }

    if (animationState.shouldRunNumberFoundAnimation) {
      executeNumberAnimations();
    }
  }

  void executeAnimations() {
    shadowController.reset();
    shadowController.forward();
  }

  void executeNumberAnimations() {
    numberFoundController.reset();
    numberFoundController.forward();
  }  



  List<Widget> getTargetElements(GamePlayState gamePlayState) {
    final Map<dynamic, dynamic> items = gamePlayState.targets;
    late List<int> targets = [];
    late List<Widget> res = [];
    late int index = 0;
    items.forEach((key, value) {
      Map<String,dynamic> targetData = {"index":index, "number": key,"isFound":value};
      Widget targetWidget = TargetWidget(data: targetData);
      targets.add(key);
      index = index + 1;
      res.add(targetWidget);
    });

    if (animationState.shouldRunNumberFoundAnimation) {
      final int? foundNumber = Helpers().getFoundNumber(gamePlayState);
      int targetIndex = targets.indexOf(foundNumber!);
      Map<String,dynamic> targetData = {"index":targetIndex,"number":foundNumber, "isFound":true};
      Widget targetWidget = TargetAnimation(data: targetData, numberFoundController: numberFoundController);
      res.add(targetWidget);
    }

    return res;
  }

  List<Widget> getTileElements( GamePlayState gamePlayState, AnimationState animationState) {
    late List<Widget> res = [];
    final Map<dynamic, dynamic> items = gamePlayState.tileData;
    items.forEach((key, value) {
      Widget tile = TileWidget(
        index: key,
        operationController: shadowController,
        operationShadowAnimation: tileTextShadowAnimation,
        operationSizeAnimation: tileBodySizeAnimation,
      );
      res.add(tile);
    });

    if (gamePlayState.isDragging) {
      int? draggedTileIndex = gamePlayState.dragStartTileIndex;
      res.removeAt(draggedTileIndex!);
      Widget tile = TileWidget(
        index: draggedTileIndex!,
        operationController: shadowController,
        operationShadowAnimation: tileTextShadowAnimation,
        operationSizeAnimation: tileBodySizeAnimation,
      );
      res.add(tile);
    }
    if (gamePlayState.dragType != null ||
        animationState.shouldRunOperationAnimation) {
      Widget plusMinus = PlusMinusWidget(
        operationController: shadowController,
        operationPositionAnimation: plusMinusPositionAnimation,
        operationOpacityAnimation: plusMinusOpacityAnimation,
      );
      res.add(plusMinus);
    }

    if (animationState.shouldRunOperationAnimation) {
      final Map<dynamic, dynamic> prevTurn = gamePlayState.turnData[gamePlayState.turnData.length - 1]; 
      final int targetTile = prevTurn["targetTile"];
      Widget numberFoundWidget = NumberFoundWidget(
        index: targetTile,
        animationController: shadowController, 
        wordFoundController: numberFoundController,
      );
      res.add(numberFoundWidget);
    }

    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GamePlayState>(builder: (context, gamePlayState, child) {
      return Consumer<AnimationState>(
          builder: (context, animationState, child) {
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
                                  color: Color.fromARGB(255, 63, 64, 65),
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
                                  Icon(Icons.replay_circle_filled_sharp, color: Color.fromARGB(255, 63, 64, 65),)
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: gamePlayState.tileSize * gamePlayState.columns,
                        height: gamePlayState.tileSize,
                        child: Center(
                          child: Stack(
                            children: getTargetElements(gamePlayState),
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   height: gamePlayState.tileSize * 0.2,
                      //   child: Text(gamePlayState.dragType.toString()),
                      // ),
                      IgnorePointer(
                        ignoring: gamePlayState.isDragging,
                        child: GestureDetector(
                          onPanStart: (details) => GameLogic().executePanStart(gamePlayState, details),
                          onPanUpdate: (details) => GameLogic().executePanUpdate(gamePlayState, animationState, details),
                          onPanEnd: (details) => GameLogic().executePanEnd(gamePlayState, details),
                          child: Container(
                            width: gamePlayState.tileSize * gamePlayState.columns,
                            height: gamePlayState.tileSize * gamePlayState.rows,
                            color: Color.fromRGBO(233, 233, 233, 1),
                            child: Stack(
                              children: getTileElements(
                                  gamePlayState, animationState),
                            )
                          ),
                        ),
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
                                    settingsState
                                        .levelData
                                        .firstWhere((element) =>
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
    });
  }
}
