import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:number_crush/functions/game_logic.dart';
import 'package:number_crush/functions/helpers.dart';
import 'package:number_crush/providers/animation_state.dart';
import 'package:number_crush/providers/game_play_state.dart';
import 'package:number_crush/providers/settings_state.dart';
import 'package:number_crush/screens/game_screen/components/game_over/game_over_overlay.dart';
import 'package:number_crush/screens/game_screen/components/number_found_widget.dart';
import 'package:number_crush/screens/game_screen/components/plus_minus_widget.dart';
import 'package:number_crush/screens/game_screen/components/targets/target_animation.dart';
import 'package:number_crush/screens/game_screen/components/targets/target_widget.dart';
import 'package:number_crush/screens/game_screen/components/tile_tapped_decoration.dart';
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

  late AnimationController tileTappedController;
  late Animation<double> tileTappedAnimation;
  

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

    // shadowController.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     animationState.setShouldRunOperationAnimation(false);
    //   }
    // });




    numberFoundController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );




  

    tileTappedController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    tileTappedAnimation = Tween<double>(begin: 0.0,end: 1.0).animate(tileTappedController);
  }

  void handleAnimationStateChange() {
    if (animationState.shouldRunOperationAnimation) {
      executeAnimations();
      executeNumberAnimations();
    }
    if (animationState.shouldRunTileSelectedAnimation) {
      executeTileTappedAnimation();
    }
    // if (animationState.shouldRunNumberFoundAnimation) {
    //   executeNumberAnimations();
    // }
  }

  void executeAnimations() {
    shadowController.reset();
    shadowController.forward();
  }

  void executeNumberAnimations() {
    // print("go ahead carvell!");
    numberFoundController.reset();
    numberFoundController.forward();
  }  

  void executeTileTappedAnimation() {
    // print("go ahead carvell!");
    tileTappedController.reset();
    tileTappedController.forward();
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

    if (animationState.shouldRunOperationAnimation) {

      // print(gamePlayState.turnData[gamePlayState.turnData.length-1]);
      final int? foundNumber = gamePlayState.turnData[gamePlayState.turnData.length-1]["numberFound"];
    
      // print("caca ${foundNumber}");
      if (foundNumber != null) {
        int targetIndex = targets.indexOf(foundNumber!);
        Map<String,dynamic> targetData = {"index":targetIndex,"number":foundNumber, "isFound":true};
        Widget targetWidget = TargetAnimation(data: targetData, numberFoundController: numberFoundController);
        res.add(targetWidget);
        res.removeAt(targetIndex);
      }
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
    if (gamePlayState.dragType != null || animationState.shouldRunOperationAnimation) {
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

    if (animationState.shouldRunTileSelectedAnimation) {
      late Map<dynamic, dynamic> prevTurn = {};
      if (gamePlayState.turnData.length > 1) {
        prevTurn = gamePlayState.turnData[gamePlayState.turnData.length - 2];
      } else {
        prevTurn = gamePlayState.turnData[gamePlayState.turnData.length - 1];
      }
      final Map<dynamic, dynamic> thisTurn = gamePlayState.turnData[gamePlayState.turnData.length - 1];

      int previousTurnSelectedIndex = Helpers().getSelectedTileIndex(prevTurn["tileData"]);
      int currentTurnSelectedIndex = Helpers().getSelectedTileIndex(gamePlayState.tileData);

      if (thisTurn["outcome"]=="add" || thisTurn["outcome"]=="subtract" ) {
        Widget previousTile = TileTappedDecoration(
          index: previousTurnSelectedIndex, 
          isCurrent: false, 
          tileTappedController: tileTappedController,
        );
        res.add(previousTile);
      }

      if (gamePlayState.tileData[previousTurnSelectedIndex]["active"]) {
        Widget currentTile = TileTappedDecoration(
          index: currentTurnSelectedIndex, 
          isCurrent: true, 
          tileTappedController: tileTappedController,
        );
        res.add(currentTile);
      }
    } 
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GamePlayState>(builder: (context, gamePlayState, child) {
      late SettingsState settingsState = Provider.of<SettingsState>(context,listen: false);
      // print(settingsState.playerProgress);

      return Consumer<AnimationState>(
          builder: (context, animationState, child) {
        return SafeArea(
          child: Stack(
            children: [
              Scaffold(
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
                body: SizedBox(
                  width: settingsState.screenSizeData['width'],
                  height: settingsState.screenSizeData['height'],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      settingsState.playerProgress[gamePlayState.level.toString()] == 0 ? SizedBox() :
                      SizedBox(
                        width: gamePlayState.tileSize * gamePlayState.columns,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  settingsState.playerProgress[gamePlayState.level.toString()].toString(),
                                  style: TextStyle(fontSize: 24),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.star,
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
                      IgnorePointer(
                        ignoring: gamePlayState.isDragging,
                        child: GestureDetector(
                          onPanStart: (details) => GameLogic().executePanStart(gamePlayState, details),
                          onPanUpdate: (details) => GameLogic().executePanUpdate(gamePlayState, animationState, details),
                          onPanEnd: (details) => GameLogic().executePanEnd(gamePlayState,animationState, details),
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
              ),

              const GameOverOverlay()
              // Positioned.fill(
              //   child: IgnorePointer(
              //     ignoring: !gamePlayState.isGameOver,
              //     child: AnimatedOpacity(
              //       opacity: gamePlayState.isGameOver ? 1.0 : 0.0,
              //       duration: const Duration(milliseconds: 300),
              //       child: BackdropFilter(
              //         filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              //         child: Container(
              //           width: settingsState.screenSizeData['width'],
              //           height: settingsState.screenSizeData['height'],
              //           color: Colors.black.withOpacity(0.2),
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: [
              //               Text(
              //                 "Congratulations!",
              //                 style: TextStyle(
              //                   fontSize: 28,
              //                 ),
              //                 textAlign: TextAlign.center,
              //               ),
              //               SizedBox(
              //                 height: 20,
              //               ),
              //               Text(
              //                 "You completed the puzzle in ${gamePlayState.turnData.length} turns",
              //                 style: TextStyle(
              //                   fontSize: 24,
              //                 ),
              //                 textAlign: TextAlign.center,
              //               ),
              //               SizedBox(
              //                 height: 20,
              //               ),
              //               GestureDetector(
              //                 onTap: () {
              //                   gamePlayState.setIsGameOver(false);
              //                   late Map<dynamic, dynamic> levelData =  settingsState.levelData.firstWhere(
              //                     (element) => element["level"] == gamePlayState.level
              //                   );
              //                   gamePlayState.setLevel(levelData['level']);
              //                   Map<dynamic, dynamic> tileData = Helpers().deepCopyTileData(levelData['tileData']);
              //                   gamePlayState.setTileData(tileData);
              //                   gamePlayState.setRows(levelData['rows']);
              //                   gamePlayState.setColumns(levelData['columns']);
              //                   gamePlayState.setTurnData([]);
              //                   gamePlayState.setLives(5);
              //                   late Map<int, bool> targets = {};
              //                   for (int i in levelData['targets']) {
              //                     targets[i] = false;
              //                   }
              //                   gamePlayState.setTargets(targets);
              //                 },
              //                 child: Container(
              //                   color: Colors.black,
              //                   // height: gamePlayState.tileSize * 0.8,
              //                   width: gamePlayState.tileSize * gamePlayState.columns,
              //                   child: Center(
              //                     child: Text(
              //                       "Play Again?",
              //                       style: TextStyle(
              //                         fontSize: 28, color: Colors.white
              //                       ),
              //                       textAlign: TextAlign.center,
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //               SizedBox(
              //                 height: gamePlayState.tileSize * 0.25,
              //               ),
              //               GestureDetector(
              //                 onTap: () {
              //                   print("next level");
              //                   gamePlayState.setIsGameOver(false);
              //                   Helpers().navigateToGameScreen(
              //                     context,
              //                     gamePlayState,
              //                     settingsState,
              //                     gamePlayState.level + 1
              //                   );
              //                 },
              //                 child: Container(
              //                   color: Colors.black,
              //                   // height: gamePlayState.tileSize * 0.8,
              //                   width: gamePlayState.tileSize * gamePlayState.columns,
              //                   child: const Center(
              //                     child: Text(
              //                       "Next Level",
              //                       style: TextStyle(
              //                         fontSize: 28, color: Colors.white
              //                       ),
              //                       textAlign: TextAlign.center,
              //                     ),
              //                   ),
              //                 ),
              //               )
              //             ],
              //           ),
              //         ),
              //       ),
              //     ),
              //   )
              // )
            ],
          ),
        );
      });
    });
  }
}
