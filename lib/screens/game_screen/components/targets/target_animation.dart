import 'package:flutter/material.dart';
import 'package:number_crush/providers/game_play_state.dart';
import 'package:provider/provider.dart';

class TargetAnimation extends StatefulWidget {
  final Map<String,dynamic> data;
  final AnimationController numberFoundController;
  const TargetAnimation({
    super.key,
    required this.data,
    required this.numberFoundController,
  });

  @override
  State<TargetAnimation> createState() => _TargetAnimationState();
}


class _TargetAnimationState extends State<TargetAnimation> {

  late Animation<double> numberFoundShadowAnimation;  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeAnimations();
  }

  void initializeAnimations() {
    final List<TweenSequenceItem<double>> numberFoundShadowSequence = [
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0,end: 1.0,),weight: 30.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.0,end: 1.0,),weight: 10.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.0,end: 0.0,),weight: 60.0),
    ];    

    numberFoundShadowAnimation = TweenSequence<double>(numberFoundShadowSequence).animate(widget.numberFoundController);    
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<GamePlayState>(
      builder: (context,gamePlayState,child) {
        final double size = (gamePlayState.tileSize*gamePlayState.columns)/5;
        return Positioned(
          top: (gamePlayState.tileSize-size)/2,
          left: size*widget.data["index"],
          child: AnimatedBuilder(
            animation: widget.numberFoundController,
            builder: (context,child) {
              return Container(
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
                      color: Colors.orange.withOpacity(numberFoundShadowAnimation.value)
                    ),          
                  ),
                ),
              );
            }
          ),
        );
      }
    );
  }
}