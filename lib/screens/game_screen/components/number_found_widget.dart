import 'dart:math';

import 'package:flutter/material.dart';
import 'package:number_crush/functions/helpers.dart';
import 'package:number_crush/providers/game_play_state.dart';
import 'package:provider/provider.dart';

class NumberFoundWidget extends StatefulWidget {
  final int index;
  final AnimationController animationController;
  final AnimationController wordFoundController;
  const NumberFoundWidget({
    super.key, 
    required this.index,
    required this.animationController,
    required this.wordFoundController,
  });

  @override
  State<NumberFoundWidget> createState() => _NumberFoundWidgetState();
}

class _NumberFoundWidgetState extends State<NumberFoundWidget> with TickerProviderStateMixin{

  

  Map<String,dynamic> getDisplayData(GamePlayState gamePlayState, int index) {
    Map<String,dynamic> res = {};
    Map<String,dynamic> tileObject = gamePlayState.tileData[index];
    String tileId = tileObject["id"];
    int row = int.parse(tileId.split("_")[0]);
    int col = int.parse(tileId.split("_")[1]);
    double yPos = (row - 1) * gamePlayState.tileSize;
    double xPos = (col - 1) * gamePlayState.tileSize; 

    res = {"top" : yPos, "left": xPos, "body": tileObject["body"]}; 
    return res;
  }

  List<Map<String,dynamic>> getParticleData(GamePlayState gamePlayState) {
    final Random rand = Random();
    late List<Map<String,dynamic>> res = [];
    double ts = gamePlayState.tileSize;
    double gap = ts*0.25;    
    for (int i=0; i<10; i++) {
      // int top = rand.nextInt((ts-gap).round())+gap.round(); 
      // int left = rand.nextInt((ts-gap).round())+gap.round();
      int randXNegaitve = rand.nextInt(9);
      int randYNegaitve = rand.nextInt(9);
      int dxSign = randXNegaitve >= 5 ? -1 : 1;
      int dyDign = randYNegaitve >= 5 ? -1 : 1;
      double dx = ((rand.nextInt(60)+30)/10)*dxSign;
      double dy = ((rand.nextInt(60)+30)/10)*dyDign; 
      double size = rand.nextInt(7)+2;   
      // int top = 
      late Map<String,dynamic> map = {};
      map = {"dx":dx, "dy":dy, "size":size};
      res.add(map);
    }
    return res;
  }




  late GamePlayState _gamePlayState;
  late List<Map<String,dynamic>> particleData;
  late Animation<Offset> offsetAnimation1;
  late Animation<Offset> offsetAnimation2;
  late Animation<Offset> offsetAnimation3;
  late Animation<Offset> offsetAnimation4;
  late Animation<Offset> offsetAnimation5;
  late Animation<Offset> offsetAnimation6;
  late Animation<Offset> offsetAnimation7;
  late Animation<Offset> offsetAnimation8;
  late Animation<Offset> offsetAnimation9;
  late Animation<Offset> offsetAnimation10;

  late Animation<double> opacityAnimation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _gamePlayState = Provider.of<GamePlayState>(context, listen: false);
    setState(() {
      particleData = getParticleData(_gamePlayState);
    });
    initializeAnimations(particleData);
  }

  void initializeAnimations(List<Map<String,dynamic>> particleData) {
    offsetAnimation1 = Tween<Offset>(
      begin: Offset.zero,end: Offset(particleData[0]["dx"], particleData[0]["dy"]),
    ).animate(widget.animationController); 
    offsetAnimation2 = Tween<Offset>(
      begin: Offset.zero,end: Offset(particleData[1]["dx"], particleData[1]["dy"]),
    ).animate(widget.animationController); 
    offsetAnimation3 = Tween<Offset>(
      begin: Offset.zero,end: Offset(particleData[2]["dx"], particleData[2]["dy"]),
    ).animate(widget.animationController); 
    offsetAnimation4 = Tween<Offset>(
      begin: Offset.zero,end: Offset(particleData[3]["dx"], particleData[3]["dy"]),
    ).animate(widget.animationController);
    offsetAnimation5 = Tween<Offset>(
      begin: Offset.zero,end: Offset(particleData[4]["dx"], particleData[4]["dy"]),
    ).animate(widget.animationController);
    offsetAnimation6 = Tween<Offset>(
      begin: Offset.zero,end: Offset(particleData[5]["dx"], particleData[5]["dy"]),
    ).animate(widget.animationController); 
    offsetAnimation7 = Tween<Offset>(
      begin: Offset.zero,end: Offset(particleData[6]["dx"], particleData[6]["dy"]),
    ).animate(widget.animationController);
    offsetAnimation8 = Tween<Offset>(
      begin: Offset.zero,end: Offset(particleData[7]["dx"], particleData[7]["dy"]),
    ).animate(widget.animationController);
    offsetAnimation9 = Tween<Offset>(
      begin: Offset.zero,end: Offset(particleData[8]["dx"], particleData[8]["dy"]),
    ).animate(widget.animationController);
    offsetAnimation10 = Tween<Offset>(
      begin: Offset.zero,end: Offset(particleData[9]["dx"], particleData[9]["dy"]),
    ).animate(widget.animationController);    

    final List<TweenSequenceItem<double>> opacitySequence = [
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0,end: 1.0,),weight: 10.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.0,end: 0.0,),weight: 90.0),
    ];    
    opacityAnimation = TweenSequence<double>(opacitySequence).animate(widget.animationController);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GamePlayState>(
      builder: (context, gamePlayState, child) {
        // final Map<String, dynamic> tileObject = gamePlayState.tileData[widget.index];
        final Map<String, dynamic> displayData = getDisplayData(gamePlayState, widget.index);
        // final List<Map<String,dynamic>> particleData = getParticleData(gamePlayState);
        return Positioned(
          top: displayData["top"],
          left: displayData["left"],
          child: Container(
            width: gamePlayState.tileSize,
            height: gamePlayState.tileSize,
            child: Center(
              child:Stack(
                // children: getParticleData(gamePlayState, displayData["body"].toString(),)
                children: [
                  particle(gamePlayState.tileSize,offsetAnimation1,opacityAnimation,particleData[0]["size"]),
                  particle(gamePlayState.tileSize,offsetAnimation2,opacityAnimation,particleData[1]["size"]),
                  particle(gamePlayState.tileSize,offsetAnimation3,opacityAnimation,particleData[2]["size"]),
                  particle(gamePlayState.tileSize,offsetAnimation4,opacityAnimation,particleData[3]["size"]),
                  particle(gamePlayState.tileSize,offsetAnimation5,opacityAnimation,particleData[4]["size"]),
                  particle(gamePlayState.tileSize,offsetAnimation6,opacityAnimation,particleData[5]["size"]),
                  particle(gamePlayState.tileSize,offsetAnimation7,opacityAnimation,particleData[6]["size"]),
                  particle(gamePlayState.tileSize,offsetAnimation8,opacityAnimation,particleData[7]["size"]),
                  particle(gamePlayState.tileSize,offsetAnimation9,opacityAnimation,particleData[8]["size"]),
                  particle(gamePlayState.tileSize,offsetAnimation10,opacityAnimation,particleData[9]["size"]),                  
                ],
              )
            )
          ),
        );
      },
    );
  }
}

Widget particle(double ts, Animation<Offset> offsetAnimation, Animation<double> opacityAnimation,double size) {
  double center = (ts-10)/2;
  return AnimatedBuilder(
    animation: opacityAnimation,
    builder: (context,child) {
      return Positioned(
        top: center,
        left: center,
        child: SlideTransition(
          position: offsetAnimation,
          child: Transform.rotate(
            angle: ((360/size) / 180 * size),
            child: Container(
              color: Colors.white.withOpacity(opacityAnimation.value),
              width: size,
              height: size,
            ),
          ),
        )
      );
    }
  );
}