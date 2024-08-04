import 'package:flutter/material.dart';
import 'package:number_crush/functions/helpers.dart';
import 'package:number_crush/providers/animation_state.dart';
import 'package:number_crush/providers/game_play_state.dart';
import 'package:provider/provider.dart';

class TileWidget extends StatefulWidget {
  final int index;
  final AnimationController operationController;
  final Animation<double> operationShadowAnimation;
  final Animation<double> operationSizeAnimation;
  
  const TileWidget(
      {super.key,
      required this.index,
      required this.operationController,
      required this.operationShadowAnimation,
      required this.operationSizeAnimation,
    });

  @override
  State<TileWidget> createState() => _TileWidgetState();
}

class _TileWidgetState extends State<TileWidget> {
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
        final Map<String, dynamic> tileObject = gamePlayState.tileData[widget.index];
        return Positioned(
          top: Helpers().getTilePosition(gamePlayState, widget.index).dy,
          left: Helpers().getTilePosition(gamePlayState, widget.index).dx,
          child: AnimatedBuilder(
              animation: widget.operationController,
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
                                        color: getTileColor(gamePlayState, widget.index),
                                        boxShadow: getBoxShadow(
                                            gamePlayState,
                                            widget.index,
                                            widget.operationController,
                                            widget.operationShadowAnimation)),
                                    child: Center(
                                      child: Text(
                                        tileObject["body"].toString(),
                                        style: TextStyle(
                                            shadows: getTextShadow(
                                                gamePlayState, 
                                                widget.index, 
                                                widget.operationController, 
                                                widget.operationShadowAnimation),
                                            color: getTextColor(gamePlayState, widget.index),
                                            fontSize: getFontSize(
                                              gamePlayState,
                                              widget.index,
                                              widget.operationController,
                                              widget.operationSizeAnimation
                                            ) 
                                        ),
                                      ),
                                    ),
                                  ),
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


double getFontSize(GamePlayState gamePlayState, int index,AnimationController animationController, Animation animation) {
  double res = gamePlayState.tileSize * 0.3;
  if (animationController.isAnimating) {
    if (gamePlayState.selectedTileIndex == index) {
      res = gamePlayState.tileSize * 0.3 * (animation.value);
    }
  }
  return res;
}

List<Shadow> getTextShadow(GamePlayState gamePlayState, int index,AnimationController animationController, Animation animation) {
  List<Shadow> res  = [];
  if (animationController.isAnimating) {
    if (gamePlayState.selectedTileIndex == index) {
      Shadow shadow = Shadow(
        // blurRadius: gamePlayState.tileSize*animation.value,
        blurRadius: 5.0,
        offset: Offset.zero,
        color: Colors.white.withOpacity(animation.value),
      );
      res.add(shadow);
    }
  }
  return res;
}

List<BoxShadow> getBoxShadow(
    GamePlayState gamePlayState, 
    int index, 
    AnimationController animationController, 
    Animation shadowAnimation
  ) {
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
        blurRadius: 7.0,
        spreadRadius: (shadowAnimation.value * gamePlayState.tileSize * 0.15),
      );
      res.add(additionalShadow);
    }
  }
  return res;
}



Color getTileColor(GamePlayState gamePlayState, int index,) {
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
