import 'package:flutter/material.dart';

class GamePlayState extends ChangeNotifier {
  late double _tileSize = 0.0;
  double get tileSize => _tileSize;
  void setTileSize(double value) {
    _tileSize = value;
    notifyListeners();
  }

  late Map<dynamic, dynamic> _targets = {};
  Map<dynamic, dynamic> get targets => _targets;
  void setTargets(Map<dynamic, dynamic> value) {
    _targets = value;
    notifyListeners();
  }

  late int _level = 0;
  int get level => _level;
  void setLevel(int value) {
    _level = value;
    notifyListeners();
  }

  late int _columns = 0;
  int get columns => _columns;
  void setColumns(int value) {
    _columns = value;
    notifyListeners();
  }

  late int _rows = 0;
  int get rows => _rows;
  void setRows(int value) {
    _rows = value;
    notifyListeners();
  }

  late Map<dynamic, dynamic> _previousTileData = {};
  Map<dynamic, dynamic> get previousTileData => _previousTileData;
  void setPreviousTileData(Map<dynamic, dynamic> value) {
    _previousTileData = value;
    notifyListeners();
  }

  late Map<dynamic, dynamic> _tileData = {};
  Map<dynamic, dynamic> get tileData => _tileData;
  void setTileData(Map<dynamic, dynamic> value) {
    _tileData = value;
    notifyListeners();
  }

  late int? _dragStartTileIndex;
  int? get dragStartTileIndex => _dragStartTileIndex;
  void setDragStartTileIndex(int? value) {
    _dragStartTileIndex = value;
    notifyListeners();
  }

  late int? _dragEndTileIndex;
  int? get dragEndTileIndex => _dragEndTileIndex;
  void setDragEndTileIndex(int? value) {
    _dragEndTileIndex = value;
    notifyListeners();
  }

  late int _selectedTileIndex;
  int get selectedTileIndex => _selectedTileIndex;
  void setSelectedTileIndex(int value) {
    _selectedTileIndex = value;
    notifyListeners();
  }

  late List<List<double>> _dragPath = [];
  List<List<double>> get dragPath => _dragPath;
  void setDragPath(List<List<double>> value) {
    _dragPath = value;
    notifyListeners();
  }

  late String? _dragDirection = null;
  String? get dragDirection => _dragDirection;
  void setDragDirection(String? value) {
    _dragDirection = value;
    notifyListeners();
  }

  late bool _isDragging = false;
  bool get isDragging => _isDragging;
  void setIsDragging(bool value) {
    _isDragging = value;
    notifyListeners();
  }

  late bool _isDragViolation = false;
  bool get isDragViolation => _isDragViolation;
  void setIsDragViolation(bool value) {
    _isDragViolation = value;
    notifyListeners();
  }
}
