import 'package:flutter/material.dart';
import 'package:number_crush/functions/game_logic.dart';
import 'package:number_crush/providers/game_play_state.dart';
import 'package:number_crush/providers/settings_state.dart';
import 'package:number_crush/screens/game_screen/components/tile_widget.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late SettingsState settingsState;
  @override
  void initState() {
    super.initState();
    settingsState = Provider.of<SettingsState>(context, listen: false);
  }

  List<Widget> getTargetElements(GamePlayState gamePlayState) {
    final Map<dynamic, dynamic> items = gamePlayState.targets;
    late List<Widget> res = [];
    items.forEach((key, value) {
      Widget targetWidget = Container(
        width: gamePlayState.tileSize * 0.5,
        height: gamePlayState.tileSize * 0.5,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(60.0)),
            border: Border.all(
              color: value ? Colors.green : Colors.grey.withOpacity(0.5),
              width: gamePlayState.tileSize * 0.05,
            )),
        child: Center(
          child: Text(key.toString()),
        ),
      );
      res.add(targetWidget);
    });
    return res;
  }

  List<Widget> getTileElements(GamePlayState gamePlayState) {
    late List<Widget> res = [];
    final Map<dynamic, dynamic> items = gamePlayState.tileData;
    items.forEach((key, value) {
      Widget tile = TileWidget(index: key);
      res.add(tile);
    });
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GamePlayState>(builder: (context, gamePlayState, child) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Level ${gamePlayState.level}"),
          ),
          body: SizedBox(
            width: settingsState.screenSizeData['width'],
            height: settingsState.screenSizeData['height'],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: gamePlayState.tileSize * 6,
                  height: gamePlayState.tileSize,
                  child: Center(
                    child: SizedBox(
                      width: gamePlayState.tileSize * 5.5,
                      height: gamePlayState.tileSize * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: getTargetElements(gamePlayState),
                      ),
                    ),
                  ),
                ),
                Text(gamePlayState.dragDirection ?? ""),
                GestureDetector(
                  onPanStart: (details) =>
                      GameLogic().executePanStart(gamePlayState, details),
                  onPanUpdate: (details) =>
                      GameLogic().executePanUpdate(gamePlayState, details),
                  onPanEnd: (details) =>
                      GameLogic().executePanEnd(gamePlayState, details),
                  child: Container(
                      width: gamePlayState.tileSize * gamePlayState.columns,
                      height: gamePlayState.tileSize * gamePlayState.rows,
                      color: Color.fromRGBO(233, 233, 233, 1),
                      child: Stack(
                        children: getTileElements(gamePlayState),
                      )),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
