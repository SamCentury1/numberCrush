import 'package:flutter/material.dart';
import 'package:number_crush/functions/helpers.dart';
import 'package:number_crush/providers/game_play_state.dart';
import 'package:provider/provider.dart';

class TileTappedDecoration extends StatefulWidget {
  final int index;
  final bool isCurrent;
  final AnimationController tileTappedController;
  const TileTappedDecoration({
    super.key,
    required this.index,
    required this.isCurrent,
    required this.tileTappedController,
  });

  @override
  State<TileTappedDecoration> createState() => _TileTappedDecorationState();
}

class _TileTappedDecorationState extends State<TileTappedDecoration> {

  late Animation<Color?> tileColorAnimationEnter;
  late Animation<Color?> tileColorAnimationExit;

  late Animation<Color?> textColorAnimationEnter;
  late Animation<Color?> textColorAnimationExit;

  Color getColorAnimation(GamePlayState gamePlayState, int index, bool isCurrent, List<Animation<Color?>> colorAnimations ) {
    Color? res = Color.fromARGB(255, 63, 64, 65);
    if (isCurrent) {
      res = colorAnimations[0].value ?? Colors.transparent;
    } else {
      res = colorAnimations[1].value ?? Colors.transparent;
    }
    return res;
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeAnimations();
  }

  void initializeAnimations() {
    Color color_0 = Colors.white;
    Color color_1 = Color.fromARGB(255, 63, 64, 65);;

    tileColorAnimationEnter = ColorTween(begin:color_0,end: color_1).animate(widget.tileTappedController);
    tileColorAnimationExit = ColorTween(begin:color_1,end: color_0).animate(widget.tileTappedController);

    textColorAnimationEnter = ColorTween(begin:color_1,end: color_0).animate(widget.tileTappedController);
    textColorAnimationExit = ColorTween(begin:color_0,end: color_1).animate(widget.tileTappedController);    
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GamePlayState>(
      builder: (context,gamePlayState,child) {
        String tileId = gamePlayState.tileData[widget.index]["id"];
        int row = int.parse(tileId.split("_")[0]);
        int col = int.parse(tileId.split("_")[1]);
        Map<String,dynamic> tileObject = gamePlayState.tileData[widget.index];
        return AnimatedBuilder(
          animation: widget.tileTappedController,
          builder: (context,child) {
            return Positioned(
              top: (row - 1) * gamePlayState.tileSize,
              left: (col - 1) * gamePlayState.tileSize,
              child: Container(
                width: gamePlayState.tileSize,
                height: gamePlayState.tileSize,
                child: Center(
                  child: Container(
                    width: gamePlayState.tileSize * 0.9,
                    height: gamePlayState.tileSize * 0.9,
                    decoration: BoxDecoration(
                      color: getColorAnimation(gamePlayState, widget.index,widget.isCurrent, [tileColorAnimationEnter,tileColorAnimationExit]),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: Offset(0, 0),
                          blurRadius: 7.0,
                          spreadRadius: 2.0,
                        )                  
                      ],
                    ),
                    child: Center(
                      child: Text(
                        tileObject["body"].toString(),
                        style: TextStyle(
                          color: getColorAnimation(gamePlayState, widget.index,widget.isCurrent, [textColorAnimationEnter,textColorAnimationExit]),
                          fontSize: gamePlayState.tileSize*0.3
                        ),
                      ),
                    ),
                  )
                )
              ),
            );
          }
        );
      }
    );
  }
}