import 'package:flutter/material.dart';

class SettingsState extends ChangeNotifier {
  late Map<String,dynamic> _screenSizeData = {"width": 0.0, "height": 0.0};
  Map<String,dynamic>  get screenSizeData => _screenSizeData;
  void setScreenSizeData(Map<String,dynamic>  value) {
    _screenSizeData = value;
    notifyListeners();
  }

  final List<Map<dynamic,dynamic>> _levelData = [
    {
      "level": 1, 
      "rows": 3, 
      "columns": 3,
      "targets": [12,16,22,27,31],
      "tileData": {
        0 : {"id": "1_1", "body": 6, "selected": true, "adjacent": false, "active": true},
        1 : {"id": "1_2", "body": 1, "selected": false, "adjacent": true, "active": true},
        2 : {"id": "1_3", "body": 4, "selected": false, "adjacent": false, "active": true},
        3 : {"id": "2_1", "body": 7, "selected": false, "adjacent": true, "active": true},
        4 : {"id": "2_2", "body": 3, "selected": false, "adjacent": false, "active": true},
        5 : {"id": "2_3", "body": 8, "selected": false, "adjacent": false, "active": true},
        6 : {"id": "3_1", "body": 4, "selected": false, "adjacent": false, "active": true},
        7 : {"id": "3_2", "body": 6, "selected": false, "adjacent": false, "active": true},
        8 : {"id": "3_3", "body": 2, "selected": false, "adjacent": false, "active": true},
      }
    },

    {
      "level": 2, 
      "rows": 3, 
      "columns": 3,
      "targets": [15,21,24,31,38],
      "tileData": {
        0 : {"id": "1_1", "body": 2, "selected": true, "adjacent": false, "active": true},
        1 : {"id": "1_2", "body": 4, "selected": false, "adjacent": true, "active": true},
        2 : {"id": "1_3", "body": 6, "selected": false, "adjacent": false, "active": true},
        3 : {"id": "2_1", "body": 1, "selected": false, "adjacent": true, "active": true},
        4 : {"id": "2_2", "body": 6, "selected": false, "adjacent": false, "active": true},
        5 : {"id": "2_3", "body": 2, "selected": false, "adjacent": false, "active": true},
        6 : {"id": "3_1", "body": 7, "selected": false, "adjacent": false, "active": true},
        7 : {"id": "3_2", "body": 5, "selected": false, "adjacent": false, "active": true},
        8 : {"id": "3_3", "body": 4, "selected": false, "adjacent": false, "active": true},
      }
    },

    {
      "level": 3, 
      "rows": 3, 
      "columns": 3,
      "targets": [11,19,25,33,37],
      "tileData": {
        0 : {"id": "1_1", "body": 4, "selected": true, "adjacent": false, "active": true},
        1 : {"id": "1_2", "body": 6, "selected": false, "adjacent": true, "active": true},
        2 : {"id": "1_3", "body": 1, "selected": false, "adjacent": false, "active": true},
        3 : {"id": "2_1", "body": 7, "selected": false, "adjacent": true, "active": true},
        4 : {"id": "2_2", "body": 7, "selected": false, "adjacent": false, "active": true},
        5 : {"id": "2_3", "body": 1, "selected": false, "adjacent": false, "active": true},
        6 : {"id": "3_1", "body": 5, "selected": false, "adjacent": false, "active": true},
        7 : {"id": "3_2", "body": 3, "selected": false, "adjacent": false, "active": true},
        8 : {"id": "3_3", "body": 6, "selected": false, "adjacent": false, "active": true},
      }
    },

    {
      "level": 4, 
      "rows": 3, 
      "columns": 3,
      "targets": [10,16,28,36,46],
      "tileData": {
        0 : {"id": "1_1", "body": 4, "selected": true, "adjacent": false, "active": true},
        1 : {"id": "1_2", "body": 9, "selected": false, "adjacent": true, "active": true},
        2 : {"id": "1_3", "body": 3, "selected": false, "adjacent": false, "active": true},
        3 : {"id": "2_1", "body": 7, "selected": false, "adjacent": true, "active": true},
        4 : {"id": "2_2", "body": 8, "selected": false, "adjacent": false, "active": true},
        5 : {"id": "2_3", "body": 2, "selected": false, "adjacent": false, "active": true},
        6 : {"id": "3_1", "body": 9, "selected": false, "adjacent": false, "active": true},
        7 : {"id": "3_2", "body": 3, "selected": false, "adjacent": false, "active": true},
        8 : {"id": "3_3", "body": 4, "selected": false, "adjacent": false, "active": true},
      }
    },

    {
      "level": 5, 
      "rows": 3, 
      "columns": 3,
      "targets": [11,22,33,44,55],
      "tileData": {
        0 : {"id": "1_1", "body": 1, "selected": true, "adjacent": false, "active": true},
        1 : {"id": "1_2", "body": 7, "selected": false, "adjacent": true, "active": true},
        2 : {"id": "1_3", "body": 3, "selected": false, "adjacent": false, "active": true},
        3 : {"id": "2_1", "body": 9, "selected": false, "adjacent": true, "active": true},
        4 : {"id": "2_2", "body": 3, "selected": false, "adjacent": false, "active": true},
        5 : {"id": "2_3", "body": 5, "selected": false, "adjacent": false, "active": true},
        6 : {"id": "3_1", "body": 9, "selected": false, "adjacent": false, "active": true},
        7 : {"id": "3_2", "body": 1, "selected": false, "adjacent": false, "active": true},
        8 : {"id": "3_3", "body": 4, "selected": false, "adjacent": false, "active": true},
      }
    },

    {
      "level": 6, 
      "rows": 3, 
      "columns": 3,
      "targets": [12,23,24,35,41],
      "tileData": {
        0 : {"id": "1_1", "body": 6, "selected": true, "adjacent": false, "active": true},
        1 : {"id": "1_2", "body": 1, "selected": false, "adjacent": true, "active": true},
        2 : {"id": "1_3", "body": 6, "selected": false, "adjacent": false, "active": true},
        3 : {"id": "2_1", "body": 5, "selected": false, "adjacent": true, "active": true},
        4 : {"id": "2_2", "body": 7, "selected": false, "adjacent": false, "active": true},
        5 : {"id": "2_3", "body": 1, "selected": false, "adjacent": false, "active": true},
        6 : {"id": "3_1", "body": 5, "selected": false, "adjacent": false, "active": true},
        7 : {"id": "3_2", "body": 8, "selected": false, "adjacent": false, "active": true},
        8 : {"id": "3_3", "body": 8, "selected": false, "adjacent": false, "active": true},
      }
    }, 


    {
      "level": 7, 
      "rows": 4, 
      "columns": 4,
      "targets": [25,44,58,59,71],
      "tileData": {
        0 : {"id": "1_1", "body": 3, "selected": true, "adjacent": false, "active": true},
        1 : {"id": "1_2", "body": 4, "selected": false, "adjacent": true, "active": true},
        2 : {"id": "1_3", "body": 1, "selected": false, "adjacent": false, "active": true},
        3 : {"id": "1_4", "body": 2, "selected": false, "adjacent": false, "active": true},
        4 : {"id": "2_1", "body": 6, "selected": false, "adjacent": true, "active": true},
        5 : {"id": "2_2", "body": 5, "selected": false, "adjacent": false, "active": true},
        6 : {"id": "2_3", "body": 8, "selected": false, "adjacent": false, "active": true},
        7 : {"id": "2_4", "body": 1, "selected": false, "adjacent": false, "active": true},
        8 : {"id": "3_1", "body": 7, "selected": false, "adjacent": false, "active": true},
        9 : {"id": "3_2", "body": 3, "selected": false, "adjacent": false, "active": true},
        10 : {"id": "3_3", "body": 9, "selected": false, "adjacent": false, "active": true},
        11 : {"id": "3_4", "body": 5, "selected": false, "adjacent": false, "active": true},
        12 : {"id": "4_1", "body": 1, "selected": false, "adjacent": false, "active": true},
        13 : {"id": "4_2", "body": 5, "selected": false, "adjacent": false, "active": true},
        14 : {"id": "4_3", "body": 4, "selected": false, "adjacent": false, "active": true},
        15 : {"id": "4_4", "body": 7, "selected": false, "adjacent": false, "active": true},
      }
    }, 

    {
      "level": 8, 
      "rows": 4, 
      "columns": 4,
      "targets": [23,45,46,56,83],
      "tileData": {
        0 : {"id": "1_1", "body": 5, "selected": true, "adjacent": false, "active": true},
        1 : {"id": "1_2", "body": 9, "selected": false, "adjacent": true, "active": true},
        2 : {"id": "1_3", "body": 2, "selected": false, "adjacent": false, "active": true},
        3 : {"id": "1_4", "body": 9, "selected": false, "adjacent": false, "active": true},
        4 : {"id": "2_1", "body": 8, "selected": false, "adjacent": true, "active": true},
        5 : {"id": "2_2", "body": 7, "selected": false, "adjacent": false, "active": true},
        6 : {"id": "2_3", "body": 4, "selected": false, "adjacent": false, "active": true},
        7 : {"id": "2_4", "body": 6, "selected": false, "adjacent": false, "active": true},
        8 : {"id": "3_1", "body": 8, "selected": false, "adjacent": false, "active": true},
        9 : {"id": "3_2", "body": 2, "selected": false, "adjacent": false, "active": true},
        10 : {"id": "3_3", "body": 5, "selected": false, "adjacent": false, "active": true},
        11 : {"id": "3_4", "body": 3, "selected": false, "adjacent": false, "active": true},
        12 : {"id": "4_1", "body": 7, "selected": false, "adjacent": false, "active": true},
        13 : {"id": "4_2", "body": 9, "selected": false, "adjacent": false, "active": true},
        14 : {"id": "4_3", "body": 2, "selected": false, "adjacent": false, "active": true},
        15 : {"id": "4_4", "body": 9, "selected": false, "adjacent": false, "active": true},
      }
    },               
  ];
  List<Map<dynamic,dynamic>> get levelData => _levelData;
}