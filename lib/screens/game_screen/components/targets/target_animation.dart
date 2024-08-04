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


  late Animation<double> rippleAnimation1;
  late Animation<double> rippleAnimation2;
  late Animation<double> rippleAnimation3;  

  late Animation<Color?> colorAnimation;
  late Animation<Color?> textColorAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeAnimations();
  }

  void initializeAnimations() {
       


    final List<TweenSequenceItem<double>> rippleSquence1 = [
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0,end: 1.0,),weight: 50.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.0,end: 1.0,),weight: 50.0),
    ];    
    rippleAnimation1 = TweenSequence<double>(rippleSquence1).animate(widget.numberFoundController);     

    final List<TweenSequenceItem<double>> rippleSquence2 = [
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0,end: 0.0,),weight: 20.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0,end: 1.0,),weight: 50.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 1.0,end: 1.0,),weight: 30.0),
    ];    
    rippleAnimation2 = TweenSequence<double>(rippleSquence2).animate(widget.numberFoundController);    

    final List<TweenSequenceItem<double>> rippleSquence3 = [
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0,end: 0.0,),weight: 40.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0,end: 1.0,),weight: 50.0),
      TweenSequenceItem<double>(tween: Tween<double>(begin: 0.0,end: 0.0,),weight: 10.0),
    ];    
    rippleAnimation3 = TweenSequence<double>(rippleSquence3).animate(widget.numberFoundController);    

    const Color color_0 = Colors.white;
    const Color color_1 = Color.fromARGB(255, 63, 64, 65);

    final List<TweenSequenceItem<Color?>> targetColorSequence = [
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_0, end:color_0), weight: 90.0),
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_0, end: color_1), weight: 10.0),
    ];
    colorAnimation = TweenSequence<Color?>(targetColorSequence).animate(widget.numberFoundController);



    final List<TweenSequenceItem<Color?>> textColorSequence = [
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_0, end:color_1), weight: 20.0),
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_1, end: color_0), weight: 20.0),
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_0, end:color_1), weight: 20.0),
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_1, end: color_0), weight: 20.0),
      TweenSequenceItem<Color?>(tween: ColorTween(begin: color_0, end:color_1), weight: 20.0),          
    ];
    textColorAnimation = TweenSequence<Color?>(textColorSequence).animate(widget.numberFoundController);    

                            
  }


  double getSize(double originalSize, double endSize, Animation<double> animation) {
    double res = originalSize;
    res = originalSize + (endSize - originalSize)*animation.value;
    return res;
  }

  double getPosition(double originalSize, double endSize, Animation<double> animation) {
    double res = (endSize-originalSize)/2;
    res = (1-animation.value) * res;
    return res;
  }  


  @override
  Widget build(BuildContext context) {
    return Consumer<GamePlayState>(
      builder: (context,gamePlayState,child) {
        final double size = (gamePlayState.tileSize*gamePlayState.columns)/5;
        final double size1 = size*0.75;
        return Positioned(
          top: (gamePlayState.tileSize-size)/2,
          left: size*widget.data["index"],
          child: AnimatedBuilder(
            animation: widget.numberFoundController,
            builder: (context,child) {
              return Container(
                width: size,
                height: size,
                child: Stack(
                  children: [
                    Positioned(
                      left: getPosition(size1, size, rippleAnimation1),
                      top: getPosition(size1, size, rippleAnimation1),
                      child: Opacity(
                        opacity: (1.0-rippleAnimation1.value),
                        child: Container(
                          width: getSize(size1, size, rippleAnimation1),
                          height:getSize(size1, size, rippleAnimation1),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(60.0)),
                            color: Colors.white,
                            border: Border.all(
                              color: Color.fromARGB(255, 63, 64, 65) ,
                              width: gamePlayState.tileSize*0.03
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 5.0,
                                spreadRadius: 2.5,
                                offset: Offset.zero,
                        
                              )
                            ]
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: getPosition(size1, size, rippleAnimation2),
                      top: getPosition(size1, size, rippleAnimation2),
                      child: Opacity(
                        opacity: (1.0-rippleAnimation2.value),
                        child: Container(
                          width: getSize(size1, size, rippleAnimation2),
                          height:getSize(size1, size, rippleAnimation2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(60.0)),
                            color: Colors.white,
                            border: Border.all(
                              color: Color.fromARGB(255, 63, 64, 65) ,
                              width: gamePlayState.tileSize*0.03
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 5.0,
                                spreadRadius: 2.5,
                                offset: Offset.zero,
                        
                              )
                            ]                          
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: getPosition(size1, size, rippleAnimation3),
                      top: getPosition(size1, size, rippleAnimation3),
                      child: Opacity(
                        opacity: (1.0-rippleAnimation3.value),
                        child: Container(
                          width: getSize(size1, size, rippleAnimation3),
                          height:getSize(size1, size, rippleAnimation3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(60.0)),
                            color: Colors.white,
                            border: Border.all(
                              color: Color.fromARGB(255, 63, 64, 65) ,
                              width: gamePlayState.tileSize*0.03
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 5.0,
                                spreadRadius: 2.5,
                                offset: Offset.zero,
                        
                              )
                            ]                          
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: (size-size1)/2,
                      top: (size-size1)/2,
                      child: Container(
                        width: size1,
                        height: size1,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(60.0)),
                          border: Border.all(
                            color: colorAnimation.value ?? Colors.transparent,
                            width: gamePlayState.tileSize * 0.05,
                          ),
                          color: colorAnimation.value ?? Colors.transparent,
                        ),
                        child: Center(
                          child: Text(
                            widget.data["number"].toString(),
                            style: TextStyle(
                              fontSize: size*0.3,
                              color: textColorAnimation.value ?? Colors.transparent,
                            ),
                          ),
                        ),                
                      ),
                    ),
                  ],
                ),
                // child: Center(
                //   child: Container(
                //     width: size *0.6,
                //     height: size *0.6,
                //     decoration: BoxDecoration(
                //       borderRadius: const BorderRadius.all(Radius.circular(60.0)),
                //       border: Border.all(
                //         color: Color.fromARGB(255, 63, 64, 65) ,
                //         width: gamePlayState.tileSize * 0.01,
                //       ),
                //       color: Colors.white
                //     ),
                //     child: Center(
                //       child: Text(
                //         widget.data["number"].toString(),
                //         style: TextStyle(
                //           fontSize: size*0.3,
                //           color: Colors.white,
                //           shadows: [
                //             Shadow(
                //               color: Colors.black.withOpacity(numberFoundShadowAnimation1.value),
                //               blurRadius: 5.0,
                //               offset: Offset.zero
                //             )
                //           ] 
                //         ),
                //       ),
                    // ),
                  // ),
                // ),
              );
            }
          ),
        );
      }
    );
  }
}