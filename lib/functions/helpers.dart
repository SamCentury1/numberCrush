import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:number_crush/functions/game_logic.dart';
import 'package:number_crush/providers/animation_state.dart';
import 'package:number_crush/providers/game_play_state.dart';
import 'package:number_crush/providers/settings_state.dart';
import 'package:number_crush/screens/game_screen/game_screen.dart';
import 'package:number_crush/screens/home_screen/home_screen.dart';

class Helpers {
  void navigateToGameScreen(BuildContext context, GamePlayState gamePlayState,SettingsState settingsState, int levelIndex) {
    late Map<dynamic, dynamic> levelData = settingsState.levelData .firstWhere((element) => element["level"] == levelIndex);
    double boardSize = (settingsState.screenSizeData['width'] * 0.95) < 360
        ? (settingsState.screenSizeData['width'] * 0.95)
        : 360;
    gamePlayState.setTileSize(boardSize / levelData['columns']);
    gamePlayState.setLevel(levelData['level']);
    Map<dynamic, dynamic> tileData = Helpers().deepCopyTileData(levelData['tileData']);
    gamePlayState.setTileData(tileData);
    gamePlayState.setRows(levelData['rows']);
    gamePlayState.setColumns(levelData['columns']);
    gamePlayState.setTurnData([]);
    gamePlayState.setLives(5);
    late Map<int, bool> targets = {};
    for (int i in levelData['targets']) {
      targets[i] = false;
    }
    gamePlayState.setTargets(targets);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const GameScreen()));
    Helpers().setTurnData(gamePlayState, 0);
  }

  void navigateToMainMenu(BuildContext context) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  Offset getTilePosition(GamePlayState gamePlayState, int tileIndex) {
    final Map<String, dynamic> tileObject = gamePlayState.tileData[tileIndex];
    final int row = int.parse(tileObject['id'].split("_")[0]);
    final int column = int.parse(tileObject['id'].split("_")[1]);
    late Offset res = Offset(((column - 1) * gamePlayState.tileSize),
        ((row - 1) * gamePlayState.tileSize));
    if (gamePlayState.dragPath.isNotEmpty) {
      if (gamePlayState.dragStartTileIndex == tileIndex) {
        List<double> initialLocalPosition = gamePlayState.dragPath[0];
        List<double> currentLocalPosition =
            gamePlayState.dragPath[gamePlayState.dragPath.length - 1];
        double xPos = currentLocalPosition[0] -
            ((initialLocalPosition[0] -
                ((column - 1) * gamePlayState.tileSize)));
        double yPos = currentLocalPosition[1] -
            ((initialLocalPosition[1] - ((row - 1) * gamePlayState.tileSize)));
        res = Offset(xPos, yPos);
      }
    }
    return res;
  }

  int getTileIndexWWithId(int row, int col, int axisCount) {
    late int res = ((row - 1) * axisCount) + col - 1;
    return res;
  }

  int getTileAxis(double val, double tileSize, int axisCount) {
    int res = 0;
    for (int i = 0; i < axisCount; i++) {
      double lowerBoundaryValue = i * tileSize;
      double upperBoundaryValue = (i + 1) * tileSize;
      if (val >= lowerBoundaryValue && val <= upperBoundaryValue) {
        res = i + 1;
      }
    }
    return res;
  }

  Map<String, dynamic> getTileObjectWithId(
      GamePlayState gamePlayState, String tileId) {
    late Map<String, dynamic> res = {};
    gamePlayState.tileData.forEach((key, value) {
      if (value["id"] == tileId) {
        res = value;
      }
    });
    return res;
  }

  bool getIsOutOfBounds(GamePlayState gamePlayState, var details) {
    late bool res = false;
    double lowX = 0.0;
    double lowY = 0.0;
    double upperX = gamePlayState.tileSize * gamePlayState.columns;
    double upperY = gamePlayState.tileSize * gamePlayState.rows;
    if (details.localPosition.dx >= lowX &&
        details.localPosition.dx <= upperX &&
        details.localPosition.dy >= lowY &&
        details.localPosition.dy <= upperY) {
      res = false;
    } else {
      res = true;
    }
    return res;
  }

  void getCoordinatesPath(
    GamePlayState gamePlayState,
    AnimationState animationState,
    List<double> coords,
  ) {
    List<List<double>> path = gamePlayState.dragPath;
    if (path.isEmpty) {
      List<List<double>> newPath = [...path, coords];
      gamePlayState.setDragPath(newPath);
    } else {
      if (path[path.length - 1] != coords) {
        getDragDirection(gamePlayState);
        List<double> initialCoords = path[0];
        List<double> updatedCoords = coords;

        late Map<String, dynamic> directionData = validateSwipeDirection(
            gamePlayState, gamePlayState.dragStartTileIndex);

        if (gamePlayState.dragDirection == "right") {
          if (directionData["right"]["action"] == "block") {
            updatedCoords = initialCoords;
            gamePlayState.setDistanceToExecute(0.0);
            gamePlayState.setDragType(null);
          } else {
            double updatedY = initialCoords[1];
            double updatedX = coords[0];
            gamePlayState.setDragType(directionData["right"]);
            gamePlayState.setDistanceToExecute((coords[0] - initialCoords[0]));
            if (coords[0] - initialCoords[0] >= gamePlayState.tileSize) {
              updatedX = initialCoords[0] + gamePlayState.tileSize;
              executeTileSwipe(gamePlayState, 'right', animationState);
            }
            updatedCoords = [updatedX, updatedY];
          }
        } else if (gamePlayState.dragDirection == "left") {
          if (directionData["left"]["action"] == "block") {
            updatedCoords = initialCoords;
            gamePlayState.setDistanceToExecute(0.0);
            gamePlayState.setDragType(null);
          } else {
            double updatedY = initialCoords[1];
            double updatedX = coords[0];
            gamePlayState.setDragType(directionData["left"]);
            gamePlayState.setDistanceToExecute((initialCoords[0] - coords[0]));
            if (initialCoords[0] - coords[0] >= gamePlayState.tileSize) {
              updatedX = initialCoords[0] - gamePlayState.tileSize;
              executeTileSwipe(gamePlayState, 'left', animationState);
            }
            updatedCoords = [updatedX, updatedY];
          }
        } else if (gamePlayState.dragDirection == "down") {
          if (directionData["down"]["action"] == "block") {
            updatedCoords = initialCoords;
            gamePlayState.setDistanceToExecute(0.0);
            gamePlayState.setDragType(null);
          } else {
            double updatedX = initialCoords[0];
            double updatedY = coords[1];
            gamePlayState.setDragType(directionData["down"]);
            gamePlayState.setDistanceToExecute((coords[1] - initialCoords[1]));
            if (coords[1] - initialCoords[1] >= gamePlayState.tileSize) {
              updatedY = initialCoords[1] + gamePlayState.tileSize;
              executeTileSwipe(gamePlayState, 'down', animationState);
            }
            updatedCoords = [updatedX, updatedY];
          }
        } else if (gamePlayState.dragDirection == "up") {
          if (directionData["up"]["action"] == "block") {
            updatedCoords = initialCoords;
            gamePlayState.setDistanceToExecute(0.0);
            gamePlayState.setDragType(null);
          } else {
            double updatedX = initialCoords[0];
            double updatedY = coords[1];
            gamePlayState.setDragType(directionData["up"]);
            gamePlayState.setDistanceToExecute((initialCoords[1] - coords[1]));
            if (initialCoords[1] - coords[1] >= gamePlayState.tileSize) {
              updatedY = initialCoords[1] - gamePlayState.tileSize;
              executeTileSwipe(gamePlayState, 'up', animationState);
            }
            updatedCoords = [updatedX, updatedY];
          }
        } else {
          gamePlayState.setDragType(null);
        }
        List<List<double>> newPath = [...path, updatedCoords];
        gamePlayState.setDragPath(newPath);
      }
    }
  }

  void getDragDirection(GamePlayState gamePlayState) {
    final List<double> firstCoords = gamePlayState.dragPath[0];
    final List<double> lastCoords = gamePlayState.dragPath.isEmpty
        ? firstCoords
        : gamePlayState.dragPath[gamePlayState.dragPath.length - 1];
    final double initialX = firstCoords[0];
    final double initialY = firstCoords[1];
    final double lastX = lastCoords[0];
    final double lastY = lastCoords[1];
    late double xDistance = (lastX - initialX);
    late double yDistance = (lastY - initialY);
    late double xDistanceAbs = xDistance.abs();
    late double yDistanceAbs = yDistance.abs();
    late double gap = gamePlayState.tileSize * 0.05;

    if (xDistanceAbs > gap || yDistanceAbs > gap) {
      if (xDistanceAbs > yDistanceAbs) {
        if (xDistance > 0) {
          gamePlayState.setDragDirection("right");
        } else {
          gamePlayState.setDragDirection("left");
        }
      } else {
        if (yDistance > 0) {
          gamePlayState.setDragDirection("down");
        } else {
          gamePlayState.setDragDirection("up");
        }
      }
    }
  }

  Map<String, dynamic> validateSwipeDirection(
      GamePlayState gamePlayState, int? tileIndex) {
    Map<String, dynamic> tileObject = gamePlayState.tileData[tileIndex];
    String selectedTileId = tileObject['id'];
    int row = int.parse(selectedTileId.split("_")[0]);
    int col = int.parse(selectedTileId.split("_")[1]);
    int left = col - 1 == 0 ? -1 : col - 1;
    int top = row - 1 == 0 ? -1 : row - 1;
    int right = col + 1 == (gamePlayState.columns + 1) ? -1 : col + 1;
    int bottom = row + 1 == (gamePlayState.rows + 1) ? -1 : row + 1;

    String leftId = left == -1 ? "" : "${row}_$left";
    String topId = top == -1 ? "" : "${top}_$col";
    String rightId = right == -1 ? "" : "${row}_$right";
    String bottomId = bottom == -1 ? "" : "${bottom}_$col";

    Map<String, dynamic>? leftTile =
        leftId == "" ? null : getTileObjectWithId(gamePlayState, leftId);
    Map<String, dynamic>? topTile =
        topId == "" ? null : getTileObjectWithId(gamePlayState, topId);
    Map<String, dynamic>? rightTile =
        rightId == "" ? null : getTileObjectWithId(gamePlayState, rightId);
    Map<String, dynamic>? bottomTile =
        bottomId == "" ? null : getTileObjectWithId(gamePlayState, bottomId);

    late Map<String, dynamic> directionData = {
      "left": leftTile,
      "up": topTile,
      "right": rightTile,
      "down": bottomTile,
    };
    late Map<String, dynamic> res = {
      "left": {"tile": leftTile, "action": ""},
      "up": {"tile": topTile, "action": ""},
      "right": {"tile": rightTile, "action": ""},
      "down": {"tile": bottomTile, "action": ""},
    };

    directionData.forEach((key, value) {
      if (value == null) {
        res[key]["action"] = "block";
      } else {
        if (value["active"]) {
          if (tileObject["selected"]) {
            res[key]["action"] = "add";
          }
          if (!tileObject["selected"] && value["adjacent"]) {
            res[key]["action"] = "block";
          }
          if (value["selected"]) {
            res[key]["action"] = "subtract";
          }
          if (!value["selected"] && !value["adjacent"]) {
            res[key]["action"] = "block";
          }
        } else if (!value["active"]) {
          res[key]["action"] = "move";
        }
      }
    });
    return res;
  }

  void executeTileSwipe(GamePlayState gamePlayState, String direction, AnimationState animationState) {
    final Map<String, dynamic> directionData = validateSwipeDirection(gamePlayState, gamePlayState.dragStartTileIndex);
    final Map<String, dynamic> actionData = directionData[direction];
    final Map<String, dynamic> sourceTileObject = gamePlayState.tileData[gamePlayState.dragStartTileIndex];
    final String? action = actionData["action"];
    late bool didScore = false;
    if (action == "move") {
      executeMove(gamePlayState, sourceTileObject, actionData);
      animationState.setShouldRunTileSelectedAnimation(true);
      animationState.setIsAnimating(true);
      Future.delayed(const Duration(milliseconds: 200), () {
        animationState.setShouldRunTileSelectedAnimation(false);
        animationState.setIsAnimating(false);
      });
    } else if (action == "add" || action == "subtract") {
      if (action == "add") {
        executeAdd(gamePlayState, sourceTileObject, actionData);
      } else {
        executeSubtract(gamePlayState, sourceTileObject, actionData);
      }
      didScore = true;
    } else {
      print("something went wrong : action = $action");
    }

    setTurnData(gamePlayState, gamePlayState.turnData.length);
    gamePlayState.setDistanceToExecute(0);
    validateScore(gamePlayState, animationState);

    if (didScore) {
      animationState.setShouldRunOperationAnimation(true);
      animationState.setIsAnimating(true);
      Future.delayed(const Duration(milliseconds: 600), () {
        animationState.setShouldRunOperationAnimation(false);
        animationState.setIsAnimating(false);
      });
    }
    gamePlayState.setDragDirection(null);
  }

  void validateScore(GamePlayState gamePlayState, AnimationState animationState) {
    List<int> numbers = [];
    gamePlayState.tileData.forEach((key, value) {
      numbers.add(value["body"]);
    });
    // bool didScore = false;
    gamePlayState.targets.forEach((key, value) {
      if (numbers.contains(key)) {
        if (!value) {
          gamePlayState.targets[key] = true;
          // // didScore = true;
          // animationState.setShouldRunNumberFoundAnimation(true);
          // Future.delayed(const Duration(milliseconds: 2000), () {
          //   animationState.setShouldRunNumberFoundAnimation(false);
          // });          
        }
      }
    });
    checkGameOver(gamePlayState);
  }


  void checkGameOver(GamePlayState gamePlayState) {
    int targets = gamePlayState.targets.length;
    int completed = 0;
    gamePlayState.targets.forEach((key, value) {
      if (value) {
        completed++;
      }
    });
    if (targets == completed) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        gamePlayState.setIsGameOver(true);
      });
    }
  }

  void executeMove(GamePlayState gamePlayState,
      Map<String, dynamic> sourceObject, Map<String, dynamic> targetObject) {
    final int? sourceTile = gamePlayState.dragStartTileIndex;
    final int targetTile = targetObject["tile"]["key"];
    final int sourceBody = sourceObject["body"];
    // if (sourceObject["selected"]) {
    //   gamePlayState.setSelectedTileIndex(targetTile);
    // }
    gamePlayState.tileData.forEach((key, value) {
      if (key == sourceTile) {
        value.update("active", (v) => false);
        value.update("body", (v) => 0);
      } else if (key == targetTile) {
        value.update("active", (v) => true);
        // value.update("selected", (v) => true);
        value.update("body", (v) => sourceBody);
      }
    });
    // if (sourceObject["selected"]) {
    gamePlayState.setSelectedTileIndex(targetTile);
    updateTileDataPostTileSelection(gamePlayState);
    // }
  }

  void executeAdd(GamePlayState gamePlayState,
      Map<String, dynamic> sourceObject, Map<String, dynamic> targetObject) {
    final int? sourceTile = gamePlayState.dragStartTileIndex;
    final int sourceBody = sourceObject["body"];
    final int targetTile = targetObject["tile"]["key"];
    final int targetBody = targetObject["tile"]["body"];

    gamePlayState.tileData.forEach((key, value) {
      if (key == sourceTile) {
        value.update("active", (v) => false);
        value.update("body", (v) => 0);
        value.update("selected", (v) => false);
      } else if (key == targetTile) {
        value.update("active", (v) => true);
        value.update("body", (v) => (sourceBody + targetBody));
      }
    });
    gamePlayState.setSelectedTileIndex(targetTile);
    updateTileDataPostTileSelection(gamePlayState);
  }

  void executeSubtract(GamePlayState gamePlayState,
      Map<String, dynamic> sourceObject, Map<String, dynamic> targetObject) {
    final int? sourceTile = gamePlayState.dragStartTileIndex;
    final int sourceBody = sourceObject["body"];
    final int targetTile = targetObject["tile"]["key"];
    final int targetBody = targetObject["tile"]["body"];
    gamePlayState.tileData.forEach((key, value) {
      if (key == sourceTile) {
        value.update("active", (v) => false);
        value.update("body", (v) => 0);
        value.update("selected", (v) => false);
      } else if (key == targetTile) {
        value.update("active", (v) => true);
        value.update("body", (v) => (targetBody - sourceBody));
      }
    });
    gamePlayState.setSelectedTileIndex(targetTile);
    updateTileDataPostTileSelection(gamePlayState);
  }

  void updateTileDataPostTileSelection(GamePlayState gamePlayState) {
    int tileIndex = gamePlayState.selectedTileIndex;
    Map<String, dynamic> selectedTileObject = gamePlayState.tileData[tileIndex];
    String selectedTileId = selectedTileObject['id'];
    final int row = int.parse(selectedTileId.split("_")[0]);
    final int col = int.parse(selectedTileId.split("_")[1]);

    int left = col - 1 == 0 ? -1 : col - 1;
    int top = row - 1 == 0 ? -1 : row - 1;
    int right = col + 1 == (gamePlayState.columns + 1) ? -1 : col + 1;
    int bottom = row + 1 == (gamePlayState.rows + 1) ? -1 : row + 1;

    List<String> adjacentTileIds = [];

    String leftId = left == -1 ? "" : "${row}_$left";
    String topId = top == -1 ? "" : "${top}_$col";
    String rightId = right == -1 ? "" : "${row}_$right";
    String bottomId = bottom == -1 ? "" : "${bottom}_$col";

    for (String item in [leftId, topId, rightId, bottomId]) {
      if (item != "") {
        adjacentTileIds.add(item);
      }
    }

    Map<dynamic, dynamic> newTileData = gamePlayState.tileData;
    newTileData.forEach((key, value) {
      if (adjacentTileIds.contains(value["id"])) {
        value.update("selected", (v) => false);
        value.update("adjacent", (v) => true);
      } else if (key == tileIndex) {
        value.update("selected", (v) => true);
        value.update("adjacent", (v) => false);
      } else {
        value.update("selected", (v) => false);
        value.update("adjacent", (v) => false);
      }
    });
  }

  void getDragEndTileIndex(GamePlayState gamePlayState, var details) {
    late double dx = details.localPosition.dx;
    late double dy = details.localPosition.dy;
    int tileCol = getTileAxis(dx, gamePlayState.tileSize, gamePlayState.columns);
    int tileRow = getTileAxis(dy, gamePlayState.tileSize, gamePlayState.rows);
    int tileIndex = getTileIndexWWithId(tileRow, tileCol, gamePlayState.columns);
    gamePlayState.setDragEndTileIndex(tileIndex);
  }

  Map<dynamic, dynamic> deepCopyTileData(Map<dynamic, dynamic> original) {
    final Map<dynamic, dynamic> copy = {};

    original.forEach((key, value) {
      final Map<String, dynamic> valueCopy = {};

      value.forEach((innerKey, innerValue) {
        valueCopy[innerKey] = innerValue;
      });

      copy[key] = valueCopy;
    });

    return copy;
  }

  Map<int, bool> deepCopyTargetData(Map<int, bool> original) {
    final Map<int, bool> copy = {};

    original.forEach((key, value) {
      copy[key] = value;
    });

    return copy;
  }

  int? getSourceTileObjectForTurnData(
      GamePlayState gamePlayState, int? tileId, String direction) {
    late int? res;
    if (tileId == null) {
      res = null;
    } else {
      if (direction == "left") {
        res = tileId + 1;
      } else if (direction == "right") {
        res = tileId - 1;
      } else if (direction == "up") {
        res = tileId + gamePlayState.columns;
      } else if (direction == "down") {
        res = tileId - gamePlayState.columns;
      }
    }
    return res;
  }

  void setTurnData(GamePlayState gamePlayState, int turn) {
    int? targetId;
    int? sourceId;
    String? outcome;
    String direction = gamePlayState.dragDirection ?? "";
    int? foundNumber = null;

    if (gamePlayState.dragType != null) {
      outcome = gamePlayState.dragType!["action"];
      targetId = gamePlayState.dragType!["tile"]["key"];
      sourceId = getSourceTileObjectForTurnData(gamePlayState, targetId, direction);
    }

    if (outcome == "add" || outcome == "subtract") {
      int candidate = gamePlayState.tileData[targetId]["body"];
      gamePlayState.targets.forEach((key,value) {
        if (!value) {
          if (key==candidate) {
            foundNumber = candidate;
          }
        }
      });
    }

    final Map<String, dynamic> turnData = {
      "turn": turn,
      "tileData": deepCopyTileData(gamePlayState.tileData),
      "targets": deepCopyTargetData(gamePlayState.targets),
      "outcome": outcome,
      "direction": gamePlayState.dragDirection,
      "sourceTile": sourceId,
      "targetTile": targetId,
      "numberFound": foundNumber,
    };

    // print(turnData);

    List<Map<String, dynamic>> newTurnData = List.from(gamePlayState.turnData); // Create a new list
    newTurnData.add(turnData);

    gamePlayState.setTurnData(newTurnData);
    gamePlayState.setDragType(null);
  }

  double getOpacity(GamePlayState gamePlayState, int index) {
    late double res = 1.0;
    if (gamePlayState.dragType != null) {
      final String action = gamePlayState.dragType!["action"];
      if (gamePlayState.dragStartTileIndex == index && action != "move") {
        res = ((gamePlayState.tileSize - gamePlayState.distanceToExecute) /
            gamePlayState.tileSize);
      } else {
        res = 1.0;
      }
    } else {
      res = 1.0;
    }

    if (res > 1.0) {
      return res = 1.0;
    }
    if (res < 0.0) {
      return res = 0.0;
    }
    return res;
  }


  int? getFoundNumber(GamePlayState gamePlayState) {
    late int? res = null;

    if (gamePlayState.turnData.length >1) {
      final Map<dynamic,dynamic> prevTurn1 = gamePlayState.turnData[gamePlayState.turnData.length-1];
      // final Map<dynamic,dynamic> prevTurn2 = gamePlayState.turnData[gamePlayState.turnData.length-2];
      // print(prevTurn1);
      final Map<int,bool> prevTargets1 = prevTurn1["targets"];
      gamePlayState.targets.forEach((key,value) {
        if (prevTargets1[key] != value) {
          res = key;
        }
      });
    }
    return res;
  }

  int getSelectedTileIndex(Map<dynamic,dynamic> tileData) {
    int res = 0;
    tileData.forEach((key, value) {
      if (value["selected"]) {
        res = key;
      }
    });
    return res;
  }

  // void getAnimationOrder(GamePlayState gamePlayState, AnimationState animationState) {
  //   Map<dynamic,dynamic> prevTurn = gamePlayState.turnData[gamePlayState.turnData.length-1];

  //   int? didScore = getFoundNumber(gamePlayState);

  //   if (didScore != null) {
  //     animationState.setShouldRunNumberFoundAnimation(true);
  //     animationState.setShouldRunOperationAnimation(true);
  //     Future.delayed(const Duration(milliseconds: 2000), () {
  //       animationState.setShouldRunNumberFoundAnimation(false);
  //       animationState.setShouldRunOperationAnimation(false);
  //     });
  //   } else {
  //     if (prevTurn["outcome"] == "add" || prevTurn["outcome"] == "subtract") {
  //       animationState.setShouldRunOperationAnimation(true);
  //       Future.delayed(const Duration(milliseconds: 600), () {
  //         animationState.setShouldRunOperationAnimation(false);
  //       });        
  //     }  
  //   }

  // } 
}
