import 'dart:ui';

import 'package:number_crush/providers/game_play_state.dart';

class Helpers {
  Offset getTilePosition(GamePlayState gamePlayState, int tileIndex) {
    final Map<String,dynamic> tileObject = gamePlayState.tileData[tileIndex];
    final int row = int.parse(tileObject['id'].split("_")[0]);
    final int column = int.parse(tileObject['id'].split("_")[1]);
    late Offset res = Offset(((column-1) * gamePlayState.tileSize), ((row-1)*gamePlayState.tileSize));
    if (gamePlayState.dragPath.isNotEmpty) {
      if (gamePlayState.dragStartTileIndex == tileIndex) {
        List<double> initialLocalPosition = gamePlayState.dragPath[0];
        List<double> currentLocalPosition = gamePlayState.dragPath[gamePlayState.dragPath.length-1];
        double xPos = currentLocalPosition[0] - ((initialLocalPosition[0] - ((column - 1) * gamePlayState.tileSize)));
        double yPos = currentLocalPosition[1] - ((initialLocalPosition[1] - ((row - 1) * gamePlayState.tileSize)));
        res = Offset(xPos,yPos);
      }
    }
    return res;
  }

  int getTileIndexWWithId(int row, int col, int axisCount) {
    late int res = ((row-1)*axisCount)+col-1;
    return res;
  }

  int getTileAxis(double val, double tileSize, int axisCount) {
    int res = 0;
    for (int i=0; i<axisCount; i++) {
      double lowerBoundaryValue = i*tileSize;
      double upperBoundaryValue = (i+1)*tileSize;
      if (val >= lowerBoundaryValue && val <= upperBoundaryValue) {
        res = i+1;
      }
    }
    return res;
  }

  Map<String,dynamic> getTileObjectWithId(GamePlayState gamePlayState, String tileId) {
    late Map<String,dynamic> res = {};
    gamePlayState.tileData.forEach((key,value) {
      if (value["id"]==tileId) {
        res = value;
        res["key"]=key;
      }
    });
    return res;
  }

  bool getIsOutOfBounds(GamePlayState gamePlayState, var details) {
    late bool res = false;
    double lowX = 0.0;
    double lowY = 0.0;
    double upperX = gamePlayState.tileSize*gamePlayState.columns;
    double upperY = gamePlayState.tileSize*gamePlayState.rows;
    if (details.localPosition.dx >= lowX
    && details.localPosition.dx <= upperX
    && details.localPosition.dy >= lowY
    && details.localPosition.dy <= upperY) {
      res = false;
    } else {
      res = true;
    }
    return res;
  }

  void getCoordinatesPath(GamePlayState gamePlayState, List<double> coords) {
    List<List<double>> path = gamePlayState.dragPath;
    if (path.isEmpty) {
      List<List<double>> newPath = [...path,coords];
      gamePlayState.setDragPath(newPath);
    } else {
      if (path[path.length-1] != coords) {
        getDragDirection(gamePlayState);
        List<double> initialCoords = path[0];
        List<double> updatedCoords = coords;

        late Map<String,dynamic> directionData = validateSwipeDirection(gamePlayState,gamePlayState.dragStartTileIndex);

        if (gamePlayState.dragDirection == "right") {
          if (directionData["right"]["action"] == "block") {
            updatedCoords = initialCoords;
          } else {
            double updatedY = initialCoords[1];
            double updatedX = coords[0];
            if (coords[0] - initialCoords[0] >= gamePlayState.tileSize) {
              updatedX = initialCoords[0]+gamePlayState.tileSize;
              executeTileSwipe(gamePlayState,'right');
              updatedCoords = [updatedX,updatedY];
            }
          }
        } else if (gamePlayState.dragDirection == "left") {
          if (directionData["left"]["action"] == "block") {
            updatedCoords = initialCoords;
          } else {
            double updatedY = initialCoords[1];
            double updatedX = coords[0];
            if (initialCoords[0] - coords[0] >= gamePlayState.tileSize) {
              updatedX = initialCoords[0]-gamePlayState.tileSize;
              executeTileSwipe(gamePlayState,'left');              
              updatedCoords = [updatedX,updatedY];
            }    
          }
        } else if (gamePlayState.dragDirection == "down") {
          if (directionData["down"]["action"] == "block") {
            updatedCoords = initialCoords;
          } else {
            double updatedY = initialCoords[0];
            double updatedX = coords[1];
            if (coords[1] - initialCoords[0] >= gamePlayState.tileSize) {
              updatedY = initialCoords[1]+gamePlayState.tileSize;
              executeTileSwipe(gamePlayState,'down');
              updatedCoords = [updatedX,updatedY];
            }    
          }
        } else if (gamePlayState.dragDirection == "up") {
          updatedCoords = initialCoords;
          } else {
          if (directionData["up"]["action"] == "block") {
            double updatedY = initialCoords[0];
            double updatedX = coords[1];
            if (initialCoords[1] - coords[0] >= gamePlayState.tileSize) {
              updatedY = initialCoords[1]-gamePlayState.tileSize;
              executeTileSwipe(gamePlayState,'up');  
              updatedCoords = [updatedX,updatedY];
            }   
          }
        }
        List<List<double>> newPath = [...path,updatedCoords];
        gamePlayState.setDragPath(newPath);
      }
    }
  }

  void getDragDirection(GamePlayState gamePlayState) {
    final List<double> firstCoords = gamePlayState.dragPath[0];
    final List<double> lastCoords = gamePlayState.dragPath.isEmpty ? firstCoords : gamePlayState.dragPath[gamePlayState.dragPath.length-1];
    late double xTravelled = 0.0;
    late double yTravelled = 0.0;
    final double initialX = firstCoords[0];
    final double initialY = firstCoords[1];
    final double lastX = lastCoords[0];
    final double lastY = lastCoords[1];

    for (int i=0; i<gamePlayState.dragPath.length; i++) {
      List<double> coords = gamePlayState.dragPath[i];
      List<double> prevCoords = i == 0 ? gamePlayState.dragPath[i] : gamePlayState.dragPath[i-1];

      double xDiff = (prevCoords[0]-coords[0]).abs();
      xTravelled = xTravelled + xDiff;

      double yDiff = (prevCoords[1]-coords[1]).abs();
      yTravelled = yTravelled + yDiff;
    }

    late double xDistance = (lastX - initialX).abs();
    late double yDistance = (lastY - initialY).abs();

    if (xDistance > gamePlayState.tileSize*0.05 || yDistance > gamePlayState.tileSize*0.05) {
      if (xDistance > yDistance) {
        if (lastX > initialX) {
          gamePlayState.setDragDirection("right");
        } else if (lastX < initialX) {
          gamePlayState.setDragDirection("right");
        }
      } else {
        if (lastY > initialY) {
          gamePlayState.setDragDirection("down");
        } else if (lastY < initialY) {
          gamePlayState.setDragDirection("up");
        }        
      }
    }
  }


  Map<String,dynamic> validateSwipeDirection(GamePlayState gamePlayState, int? tileIndex) {
    Map<String,dynamic> tileObject = gamePlayState.tileData[tileIndex];
    String selectedTileId = tileObject['id'];
    int row = int.parse(selectedTileId.split("_")[0]);
    int col = int.parse(selectedTileId.split("_")[1]);
    int left = col-1 == 0 ? -1 : col-1;
    int top = row-1 == 0 ? -1 : row-1;
    int right = col+1 == (gamePlayState.columns+1) ? -1 : col+1;
    int bottom = row+1 == (gamePlayState.rows+1) ? -1 : row+1;

    String leftId = left == -1 ? "" : "${row}_$left";
    String topId = top == -1 ? "" : "${top}_$col";
    String rightId = right == -1 ? "" : "${row}_$right";
    String bottomId = bottom == -1 ? "" : "${bottom}_$col";

    Map<String,dynamic>? leftTile = leftId == "" ? null : getTileObjectWithId(gamePlayState,leftId);
    Map<String,dynamic>? topTile = topId == "" ? null : getTileObjectWithId(gamePlayState,topId);
    Map<String,dynamic>? rightTile = rightId == "" ? null : getTileObjectWithId(gamePlayState,rightId);
    Map<String,dynamic>? bottomTile = bottomId == "" ? null : getTileObjectWithId(gamePlayState,bottomId);

    late Map<String,dynamic> directionData = {
      "left" : leftTile,
      "up" : topTile,
      "right" : rightTile,
      "down" : bottomTile,
    };
    late Map<String,dynamic> res = {
      "left": {"tile": leftTile, "action":""},
      "up": {"tile": topTile, "action":""},
      "right": {"tile": rightTile, "action":""},
      "down": {"tile": bottomTile, "action":""},
    };

    directionData.forEach((key,value) {
      if (value == null) {
        res[key]["action"]="block";
      } else {
        if (value["active"]) {
          if (tileObject["selected"]) {
            res[key]["action"]="add";
          }
          if (!tileObject["selected"] && value["adjacent"]) {
            res[key]["action"]="block";
          }
          if (value["selected"]) {
            res[key]["action"]="subtract";
          }
          if (!value["selected"] && !value["adjacent"]) {
            res[key]["action"]="block";
          }          
        } else if (!value["active"]) {
          res[key]["action"]="move";
        }
      }
    });
    print(res);
    return res;
  }


  void executeTileSwipe(GamePlayState gamePlayState, String direction) {
    final Map<String,dynamic> directionData = validateSwipeDirection(gamePlayState, gamePlayState.dragStartTileIndex);
    final Map<String,dynamic> actionData = directionData[direction];
    final Map<String,dynamic> sourceTileObject = gamePlayState.tileData[gamePlayState.dragStartTileIndex];
    final String action = directionData["action"];
    if (action == "move") {
      executeMove(gamePlayState,sourceTileObject,actionData);
    } else if (action == "add") {
      executeAdd(gamePlayState,sourceTileObject,actionData);
    } else if (action == "subtract") {
      executeSubtract(gamePlayState,sourceTileObject,actionData);
    } else {
      print("something went wrong");
    }
    validateScore(gamePlayState);
  }

  void validateScore(GamePlayState gamePlayState) {
    List<int> numbers = [];
    gamePlayState.tileData.forEach((key,value) {
      numbers.add(value["body"]);
    });
    gamePlayState.targets.forEach((key,value) {
      if (numbers.contains(key)) {
        gamePlayState.targets[key] = true;
      }
    });
  }


  void executeMove(GamePlayState gamePlayState,Map<String,dynamic> sourceObject,Map<String,dynamic> targetObject ) {
    final int? sourceTile = gamePlayState.dragStartTileIndex;
    final int sourceBody = sourceObject["body"];
    final int targetTile = targetObject["tile"]["key"];
    gamePlayState.setPreviousTileData(gamePlayState.tileData);
    if (sourceObject["selected"]) {
      gamePlayState.setSelectedTileIndex(targetTile);
    }
    gamePlayState.tileData.forEach((key,value) {
      if (key==sourceTile) {
        value.update("active", (v) => false);
        value.update("body", (v) => 0);        
      } else if (key==targetTile) {
        value.update("active", (v) => true);
        value.update("body", (v) => sourceBody);        
      }
    });
    if (sourceObject["selected"]) {
      gamePlayState.setSelectedTileIndex(targetTile);
      updateTileDataPostTileSelection(gamePlayState);
    }
  }

  void executeAdd(GamePlayState gamePlayState,Map<String,dynamic> sourceObject,Map<String,dynamic> targetObject ) {
    final int? sourceTile = gamePlayState.dragStartTileIndex;
    final int sourceBody = sourceObject["body"];
    final int targetTile = targetObject["tile"]["key"];
    final int targetBody = targetObject["body"];
    gamePlayState.tileData.forEach((key,value) {
      if (key==sourceTile) {
        value.update("active", (v) => false);
        value.update("body", (v) => 0);
        value.update("selected", (v) => false);
      } else if (key==targetTile) {
        value.update("active", (v) => true);
        value.update("body", (v) => sourceBody+targetBody);
      }
    });
    gamePlayState.setSelectedTileIndex(targetTile);
    updateTileDataPostTileSelection(gamePlayState);    
  }

  void executeSubtract(GamePlayState gamePlayState,Map<String,dynamic> sourceObject,Map<String,dynamic> targetObject ) {
    final int? sourceTile = gamePlayState.dragStartTileIndex;
    final int sourceBody = sourceObject["body"];
    final int targetTile = targetObject["tile"]["key"];
    final int targetBody = targetObject["body"];
    gamePlayState.tileData.forEach((key,value) {
      if (key==sourceTile) {
        value.update("active", (v) => false);
        value.update("body", (v) => 0);
        value.update("selected", (v) => false);
      } else if (key==targetTile) {
        value.update("active", (v) => true);
        value.update("body", (v) => targetBody-sourceBody);
      }
    });
    gamePlayState.setSelectedTileIndex(targetTile);
    updateTileDataPostTileSelection(gamePlayState);    
  }

  void updateTileDataPostTileSelection(GamePlayState gamePlayState) {
    int tileIndex = gamePlayState.selectedTileIndex;
    Map<String,dynamic> selectedTileObject = gamePlayState.tileData[tileIndex];
    String selectedTileId = selectedTileObject['id'];
    final int row = int.parse(selectedTileId.split("_")[0]);
    final int col = int.parse(selectedTileId.split("_")[1]);

    int left = col-1 == 0 ? -1 : col-1;
    int top = row-1 == 0 ? -1 : row-1;
    int right = col+1 == (gamePlayState.columns+1) ? -1 : col+1;
    int bottom = row+1 == (gamePlayState.rows+1) ? -1 : row+1;

    List<String> adjacentTileIds = [];

    String leftId = left == -1 ? "" : "${row}_$left";
    String topId = left == -1 ? "" : "${top}_$col";
    String rightId = left == -1 ? "" : "${row}_$right";
    String bottomId = left == -1 ? "" : "${bottom}_$col";

    for (String item in [leftId,topId,rightId,bottomId]) {
      if (item != "") {
        adjacentTileIds.add(item);
      }
    }

    Map<dynamic,dynamic> newTileData = gamePlayState.tileData;
    newTileData.forEach((key,value) {
      if (adjacentTileIds.contains(value["id"])) {
        value.update("selected", (v) => false);
        value.update("adjacent", (v) => true);
      } else if (key==tileIndex) {
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
}