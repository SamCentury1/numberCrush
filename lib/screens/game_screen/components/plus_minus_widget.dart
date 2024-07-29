import 'package:flutter/material.dart';
import 'package:number_crush/functions/helpers.dart';
import 'package:number_crush/providers/animation_state.dart';
import 'package:number_crush/providers/game_play_state.dart';
import 'package:provider/provider.dart';

class PlusMinusWidget extends StatefulWidget {
  const PlusMinusWidget({super.key});

  @override
  State<PlusMinusWidget> createState() => _PlusMinusWidgetState();
}

class _PlusMinusWidgetState extends State<PlusMinusWidget> {
  // late Map<String, dynamic>? fuck = {};
  late String? direction = "";

  Map<String, dynamic> getDisplayData(
      GamePlayState gamePlayState, AnimationState animationState) {
    Map<String, dynamic> res = {};
    double top = 0;
    double left = 0;
    double body = 0;
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
          operation = "-";
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
      // int targetId = gamePlayState.dragEndTileIndex!;
      // Map<String, dynamic> targetTile = gamePlayState.tileData[targetId];
      // double targetTileBody = targetTile["body"];
      // int row = int.parse(fuck!["tile"]["id"].split("_")[0]);
      // int col = int.parse(fuck!["tile"]["id"].split("_")[1]);
      // double yPos = (row - 1) * gamePlayState.tileSize;
      // double xPos = (col - 1) * gamePlayState.tileSize;

      // body = fuck!["tile"]["body"];
      // top = yPos;
      // left = xPos;

      size = 35;
      Map<dynamic, dynamic> prevTurn =
          gamePlayState.turnData[gamePlayState.turnData.length - 2];
      print(prevTurn);
      // print(prevTurn['tileData']);
    }

    opacity = 1.0;
    res = {
      "top": top,
      "left": left,
      // "body": "$operation${body.toString()}",
      "body": body.toString(),
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
        Map<String, dynamic> displayData =
            getDisplayData(gamePlayState, animationState);
        return Positioned(
          top: displayData["top"],
          left: displayData["left"],
          child: Container(
            color: Colors.blue,
            child: Opacity(
              opacity: displayData["opacity"],
              child: SizedBox(
                width: gamePlayState.tileSize,
                height: gamePlayState.tileSize,
                child: Center(
                  child: Text(
                    displayData["body"],
                    style: TextStyle(
                      fontSize: displayData["size"],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        );
      });
    });
  }
}
