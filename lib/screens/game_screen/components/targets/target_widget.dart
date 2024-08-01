import 'package:flutter/material.dart';
import 'package:number_crush/providers/game_play_state.dart';
import 'package:provider/provider.dart';

class TargetWidget extends StatefulWidget {
  final Map<String,dynamic> data;
  const TargetWidget({
    super.key,
    required this.data,
  });

  @override
  State<TargetWidget> createState() => _TargetWidgetState();
}

class _TargetWidgetState extends State<TargetWidget> {

  Color getTargetColor(Map<String,dynamic> targetData) {
    Color res = Color.fromARGB(255, 250, 250, 250);
    if (targetData["isFound"]) {
      res =  Color.fromARGB(255, 63, 64, 65);
    }
    return res;
  }


  Color getTextColor(Map<String,dynamic> targetData) {
    Color res = Color.fromARGB(255, 63, 64, 65);
    if (targetData["isFound"]) {
      res =   Color.fromARGB(255, 250, 250, 250);
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GamePlayState>(
      builder: (context,gamePlayState,child) {
        final double size = (gamePlayState.tileSize*gamePlayState.columns)/5;
        return Positioned(
          top:(gamePlayState.tileSize-size)/2,
          left: size*widget.data["index"],
          child: Container(
            width: size,
            height: size,
            child: Center(
              child: Container(
                width: size *0.75,
                height: size *0.75,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(60.0)),
                  border: Border.all(
                    color: Color.fromARGB(255, 63, 64, 65) ,
                    width: gamePlayState.tileSize * 0.05,
                  ),
                  color: getTargetColor(widget.data)
                ),
                child: Center(
                  child: Text(
                    widget.data["number"].toString(),
                    style: TextStyle(
                      fontSize: size*0.3,
                      color: getTextColor(widget.data)
                    ),
                  ),
                ),                
              ),
            ),
          ),
        );
      }
    );
  }
}