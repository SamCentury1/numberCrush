import 'package:flutter/material.dart';

class AnimationState extends ChangeNotifier {
  late bool _shouldRunOperationAnimation = false;
  bool get shouldRunOperationAnimation => _shouldRunOperationAnimation;
  void setShouldRunOperationAnimation(bool value) {
    _shouldRunOperationAnimation = value;
    notifyListeners();
  }

  late bool _shouldRunTileSelectedAnimation = false;
  bool get shouldRunTileSelectedAnimation => _shouldRunTileSelectedAnimation;
  void setShouldRunTileSelectedAnimation(bool value) {
    _shouldRunTileSelectedAnimation = value;
    notifyListeners();
  }  

  late bool _shouldRunNumberFoundAnimation = false;
  bool get shouldRunNumberFoundAnimation => _shouldRunNumberFoundAnimation;
  void setShouldRunNumberFoundAnimation(bool value) {
    _shouldRunNumberFoundAnimation = value;
    notifyListeners();
  }

  late bool _isAnimating = false;
  bool get isAnimating => _isAnimating;
  void setIsAnimating(bool value) {
    _isAnimating = value;
    notifyListeners();
  }  
}
