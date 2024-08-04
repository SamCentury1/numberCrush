import 'package:number_crush/settings/persistence/settings_persistence.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// An implementation of [SettingsPersistence] that uses
/// `package:shared_preferences`.

class LocalStorageSettingsPersistence extends SettingsPersistence {
  final Future<SharedPreferences> instanceFuture =
      SharedPreferences.getInstance();

  /// ========= GET THE DATA =================

  @override
  Future<Object> getUserData() async {
    final prefs = await instanceFuture;
    return json.decode(prefs.getString('userData') ?? "");
  }


  /// ========= SAVE THE DATA =================
  @override
  Future<void> saveUserData(Object value) async {
    final prefs = await instanceFuture;
    await prefs.setString('userData', json.encode(value));
  }


}
