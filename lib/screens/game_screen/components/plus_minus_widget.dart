import 'package:flutter/material.dart';
import 'package:number_crush/functions/helpers.dart';
import 'package:number_crush/providers/animation_state.dart';
import 'package:number_crush/providers/game_play_state.dart';
import 'package:provider/provider.dart';

class PlusMinusWidget extends StatefulWidget {
  final AnimationController operationController;
  final Animation<double> operationPositionAnimation;
  final Animation<double> operationOpacityAnimation;
  const PlusMinusWidget(
      {super.key,
      required this.operationController,
      required this.operationPositionAnimation,
      required this.operationOpacityAnimation});

  @override
  State<PlusMinusWidget> createState() => _PlusMinusWidgetState();
}

class _PlusMinusWidgetState extends State<PlusMinusWidget> {
  // late Map<String, dynamic>? fuck = {};
  // late String? direction = "";

  Map<String, dynamic> getDisplayData(
      GamePlayState gamePlayState,
      AnimationState animationState,
      Animation<double> operationPositionAnimation,
      Animation<double> operationOpacityAnimation) {
    Map<String, dynamic> res = {};
    double top = 0;
    double left = 0;
    int body = 0;
    String operation = "";
    double opacity = 0.0;
    double size = 0.0;

    if (gamePlayState.dragType != null) {
      int? sourceTileId = gamePlayState.dragStartTileIndex;
      Map<String, dynamic> sourceTile = gamePlayState.tileData[sourceTileId];
      body = sourceTile["body"];

      Map<String, dynamic> targetTile = gamePlayState.dragType!["tile"];
      int row = int.parse(targetTile["id"].split("_")[0]);
      int col = int.parse(targetTile["id"].split("_")[1]);
      double yPos = (row - 1) * gamePlayState.tileSize;
      double xPos = (col - 1) * gamePlayState.tileSize;
      top = yPos;
      left = xPos;
      double offset = (gamePlayState.tileSize * 0.5);
      String? direction = gamePlayState.dragDirection;
      if (direction == "left" || direction == "right") {
        left = direction == "left" ? (xPos + offset) : (xPos - offset);
      }
      if (direction == "up" || direction == "down") {
        top = direction == "up" ? (yPos + offset) : (yPos - offset);
      }

      String action = gamePlayState.dragType!["action"];
      if (action == "add" || action == "subtract") {
        // operation = action == "add" ? "+" : "-";
        if (action == "add") {
          if (body > 0) {
            operation = "+";
          } else {
            operation = "";
          }
        } else {
          if (body < 0) {
            body = body * -1;
            operation = "+";
          } else {
            operation = "-";
          }
        }

        opacity = (1.0 - Helpers().getOpacity(gamePlayState, sourceTileId!));
        top = (top + offset) - (opacity * (gamePlayState.tileSize * 0.75));
        size = (gamePlayState.tileSize * 0.2) +
            ((gamePlayState.tileSize * 0.15) * opacity);
      } else {
        operation = "";
      }
    }

    if (animationState.shouldRunOperationAnimation) {
      final Map<dynamic, dynamic> prevTurn = gamePlayState.turnData[gamePlayState.turnData.length - 1];
      final Map<dynamic, dynamic> prevTurn2 = gamePlayState.turnData[gamePlayState.turnData.length - 2];

      int sourceBody = prevTurn2['tileData'][prevTurn['sourceTile']]['body'];
      // String sourceTile = prevTurn["tileData"][prevTurn['sourceTile']]["id"];
      String targetTile = prevTurn["tileData"][prevTurn['targetTile']]["id"];

      int row = int.parse(targetTile.split("_")[0]);
      int col = int.parse(targetTile.split("_")[1]);

      double offset = (gamePlayState.tileSize * 0.5);
      double yPos = (row - 1) * gamePlayState.tileSize;
      double xPos = (col - 1) * gamePlayState.tileSize;
      top = yPos;
      left = xPos;
      late String? direction = prevTurn["direction"];

      if (direction == "left" || direction == "right") {
        left = direction == "left" ? (xPos + offset) : (xPos - offset);
      }
      if (direction == "up" || direction == "down") {
        top = direction == "up" ? (yPos + offset) : (yPos - offset);
      }

      double elevation = row == 1
          ? gamePlayState.tileSize * 0.1
          : gamePlayState.tileSize * 0.5;
      top = ((top + offset) - (1.0 * (gamePlayState.tileSize * 0.75))) -
          (operationPositionAnimation.value * elevation);

      body = sourceBody;

      String action = prevTurn["outcome"];
      if (action == "add" || action == "subtract") {
        if (action == "add") {
          if (body > 0) {
            operation = "+";
          } else {
            operation = "";
          }
        } else {
          if (body < 0) {
            body = body * -1;
            operation = "+";
          } else {
            operation = "-";
          }
        }
      }

      size = (gamePlayState.tileSize * 0.2) +
          ((gamePlayState.tileSize * 0.15) * 1.0);

      opacity = (operationOpacityAnimation.value);
    }

    // opacity = 1.0;
    res = {
      "top": top,
      "left": left,
      "body": "$operation${body.toString()}",
      // "body": body.toString(),
      "opacity": opacity,
      "size": size,
    };

    return res;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    late GamePlayState gamePlayState =
        Provider.of<GamePlayState>(context, listen: false);
    // setState(() {
    //   fuck = gamePlayState.dragType;
    //   direction = gamePlayState.dragDirection;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GamePlayState>(builder: (context, gamePlayState, child) {
      return Consumer<AnimationState>(
        builder: (context, animationState, child) {
          return AnimatedBuilder(
            animation: widget.operationController,
            builder: (context, child) {
              Map<String, dynamic> displayData = getDisplayData(
                  gamePlayState,
                  animationState,
                  widget.operationPositionAnimation,
                  widget.operationOpacityAnimation
                );
                return Positioned(
                  top: displayData["top"],
                  left: displayData["left"],
                  child: Container(
                    child: Opacity(
                      opacity: displayData["opacity"],
                      child: SizedBox(
                        width: gamePlayState.tileSize,
                        height: gamePlayState.tileSize,
                        child: Center(
                          child: Text(
                            displayData["body"],
                            style: TextStyle(
                              shadows:const [
                                Shadow(
                                  color: Colors.white,
                                  blurRadius: 2.0,
                                  offset: Offset.zero,
                                ),
                                Shadow(
                                  color: Colors.white,
                                  blurRadius: 10.0,
                                  offset: Offset.zero,
                                ),                                
                              ],                            
                              fontSize: displayData["size"],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
            );
          } 
        );
      }
    );
  }
}
