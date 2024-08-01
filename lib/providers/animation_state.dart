import 'package:flutter/material.dart';

class AnimationState extends ChangeNotifier {
  late bool _shouldRunOperationAnimation = false;
  bool get shouldRunOperationAnimation => _shouldRunOperationAnimation;
  void setShouldRunOperationAnimation(bool value) {
    _shouldRunOperationAnimation = value;
    notifyListeners();
  }

  late bool _shouldRunNumberFoundAnimation = false;
  bool get shouldRunNumberFoundAnimation => _shouldRunNumberFoundAnimation;
  void setShouldRunNumberFoundAnimation(bool value) {
    _shouldRunNumberFoundAnimation = value;
    notifyListeners();
  }  
}
