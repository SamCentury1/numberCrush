import 'package:flutter/material.dart';
import 'package:number_crush/functions/helpers.dart';
import 'package:number_crush/providers/game_play_state.dart';
import 'package:provider/provider.dart';

class TileWidget extends StatefulWidget {
  final int index;
  const TileWidget({super.key, required this.index});

  @override
  State<TileWidget> createState() => _TileWidgetState();
}

class _TileWidgetState extends State<TileWidget> {

  Color getTileColor(GamePlayState gamePlayState, int index) {
    Color res = Colors.white;
    Map<dynamic,dynamic> tileObject = gamePlayState.tileData[index];
    if (tileObject['active']) {
      if (tileObject['selected']) {
        res = Colors.green;
      } else if (tileObject['adjacent']) {
        res = Colors.yellow;
      } else {
        res = Colors.white;
      }
    } else {
      res = Colors.transparent;
    }
    return res;
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<GamePlayState>(
      builder: (context,gamePlayState,child) {
        final Map<String,dynamic> tileObject = gamePlayState.tileData[widget.index];
        return Positioned(
          top: Helpers().getTilePosition(gamePlayState,widget.index).dy,
          left: Helpers().getTilePosition(gamePlayState,widget.index).dx,
          child: Container(
            width: gamePlayState.tileSize,
            height: gamePlayState.tileSize,
            child: Center(
              child: tileObject['active']
              ? Stack(
                children: [
                  Container(
                    width: gamePlayState.tileSize*0.9,
                    height: gamePlayState.tileSize*0.9,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: Offset(-1.0,1.0),
                          blurRadius: 2.0,
                          spreadRadius: 1.0,
                        ),
                      ]
                    ),
                    child: Center(
                      child: Text(
                        tileObject["body"].toString(),
                        style: TextStyle(
                          color: Color.fromRGBO(10,10,10,1),
                          fontSize: gamePlayState.tileSize*0.3
                        ),
                      ),
                    ),                  
                  ),
                  Positioned(
                    top: (gamePlayState.tileSize*0.2)*0.5,
                    left: (gamePlayState.tileSize*0.2)*0.5,
                    child: Container(
                      width: gamePlayState.tileSize*0.7,
                      height: gamePlayState.tileSize*0.7,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: getTileColor(gamePlayState, widget.index),
                          width: gamePlayState.tileSize*0.06
                        )
                      ),
                    )
                  ),
                ],
              ) : SizedBox()
            ),
          ),
        );
      },
    );
  }
}