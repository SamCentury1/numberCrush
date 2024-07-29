import 'package:flutter/material.dart';
import 'package:number_crush/functions/helpers.dart';
import 'package:number_crush/providers/animation_state.dart';
import 'package:number_crush/providers/game_play_state.dart';
import 'package:provider/provider.dart';

class TileWidget extends StatefulWidget {
  final int index;
  const TileWidget({super.key, required this.index});

  @override
  State<TileWidget> createState() => _TileWidgetState();
}

class _TileWidgetState extends State<TileWidget> with TickerProviderStateMixin {
  late AnimationState animationState;
  late GamePlayState gamePlayState;
  late AnimationController shadowController;
  late Animation<double> shadowAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationState = Provider.of<AnimationState>(context, listen: false);
    gamePlayState = Provider.of<GamePlayState>(context, listen: false);
    initializeAnimations();
    animationState.addListener(handleAnimationStateChange);
  }

  void initializeAnimations() {
    shadowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    shadowAnimation =
        Tween<double>(begin: 0.0, end: 20.0).animate(shadowController);

    shadowController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationState.setShouldRunOperationAnimation(false);
      }
    });
  }

  void handleAnimationStateChange() {
    if (animationState.shouldRunOperationAnimation) {
      executeAnimations();
    }
  }

  void executeAnimations() {
    shadowController.reset();
    shadowController.forward();
  }

  // @overridex
  // void dispose() {
  //   // TODO: implement dispose
  //   shadowController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<GamePlayState>(
      builder: (context, gamePlayState, child) {
        double op = Helpers().getOpacity(gamePlayState, widget.index);
        final Map<String, dynamic> tileObject =
            gamePlayState.tileData[widget.index];
        return Positioned(
          top: Helpers().getTilePosition(gamePlayState, widget.index).dy,
          left: Helpers().getTilePosition(gamePlayState, widget.index).dx,
          child: AnimatedBuilder(
              animation: shadowController,
              builder: (context, child) {
                return Opacity(
                  opacity: op,
                  child: Container(
                    width: gamePlayState.tileSize,
                    height: gamePlayState.tileSize,
                    child: Center(
                        child: tileObject['active']
                            ? Stack(
                                children: [
                                  Container(
                                    width: gamePlayState.tileSize * 0.9,
                                    height: gamePlayState.tileSize * 0.9,
                                    decoration: BoxDecoration(
                                        color: getTileColor(
                                            gamePlayState, widget.index),
                                        boxShadow: getBoxShadow(
                                            gamePlayState,
                                            widget.index,
                                            shadowController,
                                            shadowAnimation)),
                                    child: Center(
                                      child: Text(
                                        tileObject["body"].toString(),
                                        style: TextStyle(
                                            color: getTextColor(
                                                gamePlayState, widget.index),
                                            fontSize:
                                                gamePlayState.tileSize * 0.3),
                                      ),
                                    ),
                                  ),
                                  // Positioned(
                                  //     top: (gamePlayState.tileSize * 0.2) * 0.5,
                                  //     left: (gamePlayState.tileSize * 0.2) * 0.5,
                                  //     child: Container(
                                  //       width: gamePlayState.tileSize * 0.7,
                                  //       height: gamePlayState.tileSize * 0.7,
                                  //       decoration: BoxDecoration(
                                  //           border: Border.all(
                                  //               color: getTileColor(
                                  //                   gamePlayState, widget.index),
                                  //               width:
                                  //                   gamePlayState.tileSize * 0.06)),
                                  //     )),
                                ],
                              )
                            : SizedBox()),
                  ),
                );
              }),
        );
      },
    );
  }
}

List<BoxShadow> getBoxShadow(GamePlayState gamePlayState, int index,
    AnimationController animationController, Animation shadowAnimation) {
  List<BoxShadow> res = [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      offset: Offset(-2.0, 2.0),
      blurRadius: 1.0,
      spreadRadius: 1.0,
    ),
  ];
  if (animationController.isAnimating) {
    if (gamePlayState.selectedTileIndex == index) {
      BoxShadow additionalShadow = BoxShadow(
        color: Colors.black.withOpacity(0.3),
        offset: Offset(0, 0),
        blurRadius: 1.0,
        spreadRadius: shadowAnimation.value,
      );
      res.add(additionalShadow);
    }
  }
  return res;
}

double getShadowAnimation(
    Animation<double> shadowAnimation, GamePlayState gamePlayState, int index) {
  double res = 0.0;
  if (gamePlayState.dragEndTileIndex == index) {
    res = shadowAnimation.value;
  }
  return res;
}

Color getTileColor(GamePlayState gamePlayState, int index) {
  Color selectedColor = Color.fromARGB(255, 63, 64, 65);
  Color res = Colors.white;
  Map<dynamic, dynamic> tileObject = gamePlayState.tileData[index];
  if (tileObject['active']) {
    if (tileObject['selected']) {
      res = selectedColor;
    } else if (tileObject['adjacent']) {
      if (gamePlayState.dragType != null) {
        if (gamePlayState.dragType!["tile"]["key"] == index) {
          double dist = gamePlayState.distanceToExecute;
          double ts = gamePlayState.tileSize;
          double pct = dist <= 0 ? 0 : (dist / ts);

          // print((op).toString());
          res = Colors.white.withOpacity((1 - pct));
        } else {
          res = Colors.white;
        }
      } else {
        res = Colors.white;
      }
    } else {
      res = Colors.white;
    }
  } else {
    res = Colors.transparent;
  }
  return res;
}

Color getTextColor(GamePlayState gamePlayState, int index) {
  Color selectedColor = Colors.white;
  Color res = Color.fromARGB(255, 63, 64, 65);
  Map<dynamic, dynamic> tileObject = gamePlayState.tileData[index];
  if (tileObject['active']) {
    if (tileObject['selected']) {
      res = selectedColor;
    } else if (tileObject['adjacent']) {
      if (gamePlayState.dragType != null) {
        if (gamePlayState.dragType!["tile"]["key"] == index) {
          // double op = Helpers().getOpacity(gamePlayState, index);
          double dist = gamePlayState.distanceToExecute;
          double ts = gamePlayState.tileSize;
          double pct = dist <= 0 ? 0 : (dist / ts);

          // print((op).toString());
          res = Color.fromARGB(255, 63, 64, 65).withOpacity((1 - pct));
        } else {
          res = Color.fromARGB(255, 63, 64, 65);
        }
      } else {
        res = Color.fromARGB(255, 63, 64, 65);
      }
    } else {
      res = Color.fromARGB(255, 63, 64, 65);
    }
  } else {
    res = Colors.transparent;
  }
  return res;
}
