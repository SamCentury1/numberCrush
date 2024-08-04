import 'package:number_crush/functions/helpers.dart';
import 'package:number_crush/providers/animation_state.dart';
import 'package:number_crush/providers/game_play_state.dart';

class GameLogic {
  void executePanStart(GamePlayState gamePlayState, var details) {
    late double dx = details.localPosition.dx;
    late double dy = details.localPosition.dy;
    if (!gamePlayState.isDragging) {
      int tileCol = Helpers().getTileAxis(dx, gamePlayState.tileSize, gamePlayState.columns);
      int tileRow = Helpers().getTileAxis(dy, gamePlayState.tileSize, gamePlayState.rows);
      int tileIndex = Helpers().getTileIndexWWithId(tileRow, tileCol, gamePlayState.columns);
      gamePlayState.setDragStartTileIndex(tileIndex);
    }
  }

  void executePanUpdate(
      GamePlayState gamePlayState, AnimationState animationState, var details) {
    late bool isOutOfBounds = Helpers().getIsOutOfBounds(gamePlayState, details);
    if (!isOutOfBounds) {
      Map<String, dynamic> tileObject = gamePlayState.tileData[gamePlayState.dragStartTileIndex];
      if (tileObject["active"]) {
        late double dx = details.localPosition.dx;
        late double dy = details.localPosition.dy;
        List<double> coords = [dx, dy];
        Helpers().getCoordinatesPath(gamePlayState, animationState, coords);
        gamePlayState.setIsDragging(true);
      }
    } else {
      gamePlayState.setIsDragging(false);
      gamePlayState.setDragPath([]);
    }
  }

  int getPreviousTurnSelectedTileIndex(GamePlayState gamePlayState) {
    int res = 0;
    if (gamePlayState.turnData.length > 1) {
      Map<dynamic, dynamic> lastTurnTileData =
          gamePlayState.turnData[gamePlayState.turnData.length - 1]['tileData'];
      lastTurnTileData.forEach((key, value) {
        if (value['selected']) {
          res = key;
        }
      });
    } else {
      res = 0;
    }
    return res;
  }

  void executePanEnd(GamePlayState gamePlayState, AnimationState animationState, var details) {
    Helpers().getDragEndTileIndex(gamePlayState, details);
    if (gamePlayState.dragStartTileIndex == gamePlayState.dragEndTileIndex) {
      if (gamePlayState.tileData[gamePlayState.dragEndTileIndex]["active"]) {
        gamePlayState.setSelectedTileIndex(gamePlayState.dragEndTileIndex!);
        if (gamePlayState.selectedTileIndex != getPreviousTurnSelectedTileIndex(gamePlayState)) {
          animationState.setShouldRunTileSelectedAnimation(true);
          animationState.setIsAnimating(true);
          Helpers().updateTileDataPostTileSelection(gamePlayState);
          Helpers().setTurnData(gamePlayState, gamePlayState.turnData.length);
          Future.delayed(const Duration(milliseconds: 200), () {
            animationState.setShouldRunTileSelectedAnimation(false);
            animationState.setIsAnimating(false);
          });
        } else {
          print("you tried to select that mf again");
        }
      }
    }

    // Helpers().getAnimationOrder(gamePlayState,animationState);

    gamePlayState.setDragStartTileIndex(null);
    gamePlayState.setDragPath([]);
    gamePlayState.setIsDragging(false);
    gamePlayState.setDragDirection("none");
    gamePlayState.setIsDragViolation(false);
    // gamePlayState.setDragEndTileIndex(null);
    gamePlayState.setDragType(null);
    gamePlayState.setDistanceToExecute(0.0);
  }

  void executeUndo(GamePlayState gamePlayState) {
    if (gamePlayState.turnData.length > 1 && gamePlayState.lives > 0) {
      gamePlayState.turnData.removeLast();

      final Map<dynamic, dynamic> previousTurnData = gamePlayState.turnData[gamePlayState.turnData.length - 1];
      final Map<dynamic, dynamic> previousTileData = Helpers().deepCopyTileData(previousTurnData['tileData']);
      final Map<int, bool> previousTargetData = Helpers().deepCopyTargetData(previousTurnData['targets']);

      List<Map<String, dynamic>> newTurnData =List.from(gamePlayState.turnData);
      gamePlayState.setTurnData(newTurnData);

      gamePlayState.setTileData(previousTileData);
      gamePlayState.setTargets(previousTargetData);
      gamePlayState.setLives(gamePlayState.lives - 1);

      // Helpers().updateTileDataPostTileSelection(gamePlayState);
    }
  }
}
