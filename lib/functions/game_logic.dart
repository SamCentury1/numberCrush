import 'package:number_crush/functions/helpers.dart';
import 'package:number_crush/providers/game_play_state.dart';

class GameLogic {
  void executePanStart(GamePlayState gamePlayState, var details) {
    late double dx = details.localPosition.dx;
    late double dy = details.localPosition.dy;
    int tileCol = Helpers()
        .getTileAxis(dx, gamePlayState.tileSize, gamePlayState.columns);
    int tileRow =
        Helpers().getTileAxis(dy, gamePlayState.tileSize, gamePlayState.rows);
    int tileIndex =
        Helpers().getTileIndexWWithId(tileRow, tileCol, gamePlayState.columns);
    gamePlayState.setDragStartTileIndex(tileIndex);
  }

  void executePanUpdate(GamePlayState gamePlayState, var details) {
    late bool isOutOfBounds =
        Helpers().getIsOutOfBounds(gamePlayState, details);
    if (!isOutOfBounds) {
      Map<String, dynamic> tileObject =
          gamePlayState.tileData[gamePlayState.dragStartTileIndex];
      if (tileObject["active"]) {
        late double dx = details.localPosition.dx;
        late double dy = details.localPosition.dy;
        List<double> coords = [dx, dy];
        Helpers().getCoordinatesPath(gamePlayState, coords);
        gamePlayState.setIsDragging(true);
      }
    } else {
      gamePlayState.setIsDragging(false);
      gamePlayState.setDragPath([]);
    }
  }

  void executePanEnd(GamePlayState gamePlayState, var details) {
    Helpers().getDragEndTileIndex(gamePlayState, details);
    if (gamePlayState.dragStartTileIndex == gamePlayState.dragEndTileIndex) {
      if (gamePlayState.tileData[gamePlayState.dragEndTileIndex]["active"]) {
        gamePlayState.setSelectedTileIndex(gamePlayState.dragEndTileIndex!);
        Helpers().updateTileDataPostTileSelection(gamePlayState);
      }
    }
    gamePlayState.setDragStartTileIndex(null);
    gamePlayState.setDragPath([]);
    gamePlayState.setIsDragging(false);
    gamePlayState.setDragDirection("none");
    gamePlayState.setIsDragViolation(false);
    gamePlayState.setDragEndTileIndex(null);
  }
}
