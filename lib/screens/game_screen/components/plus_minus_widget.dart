import 'package:flutter/material.dart';
import 'package:number_crush/providers/game_play_state.dart';
import 'package:provider/provider.dart';

class PlusMinusWidget extends StatefulWidget {
  const PlusMinusWidget({super.key});

  @override
  State<PlusMinusWidget> createState() => _PlusMinusWidgetState();
}

class _PlusMinusWidgetState extends State<PlusMinusWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GamePlayState>(builder: (context, gamePlayState, child) {
      double top = 0;
      double left = 0;
      String body = "";
      String operation = "";

      if (gamePlayState.dragType != null) {
        Map<String, dynamic> tile = gamePlayState.dragType!["tile"];
        int row = int.parse(tile["id"].split("_")[0]);
        int col = int.parse(tile["id"].split("_")[1]);
        top = (row - 1) * gamePlayState.tileSize;
        left = (col - 1) * gamePlayState.tileSize;
        body = tile["body"].toString();
        operation = gamePlayState.dragType!["action"];
        print(operation);
      }

      return Positioned(
        top: top,
        left: left,
        child: Container(
          width: gamePlayState.tileSize,
          height: gamePlayState.tileSize,
          color: Colors.blue,
          child: Center(
            child: Text(
              body,
              style: TextStyle(
                fontSize: gamePlayState.tileSize * 0.3,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    });
  }
}
