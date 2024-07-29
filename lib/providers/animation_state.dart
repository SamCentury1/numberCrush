import 'package:flutter/material.dart';

class AnimationState extends ChangeNotifier {
  late bool _shouldRunOperationAnimation = false;
  bool get shouldRunOperationAnimation => _shouldRunOperationAnimation;
  void setShouldRunOperationAnimation(bool value) {
    _shouldRunOperationAnimation = value;
    notifyListeners();
  }
}
