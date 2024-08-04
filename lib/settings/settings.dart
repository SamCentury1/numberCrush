import 'package:flutter/foundation.dart';
import 'package:number_crush/settings/persistence/settings_persistence.dart';


/// An class that holds settings like [playerName] or [musicOn],
/// and saves them to an injected persistence store.

class SettingsController {
  final SettingsPersistence _persistence;



  ValueNotifier<Object> userData = ValueNotifier({});

  /// Creates a new instance of [SettingsController] backed by [persistence].
  SettingsController({required SettingsPersistence persistence})
      : _persistence = persistence;

  /// Asynchronously loads values from the injected persistence store.
  Future<void> loadStateFromPerisitence() async {
    await Future.wait([ 
      _persistence.getUserData().then((value) => userData.value = value),
    ]);
  }


  void setUserData(Object userObject) {
    userData.value = userObject;
    _persistence.saveUserData(userData.value);
  }

}
