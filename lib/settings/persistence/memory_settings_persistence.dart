import 'package:number_crush/settings/persistence/settings_persistence.dart';

/// An in-memory implementation of [SettingsPersistence].
/// Useful for testing.

class MemoryOnlySettingsPersistence implements SettingsPersistence {

  Object userData = {};

  /// ============= GET ===================
  @override
  Future<Object> getUserData() async => userData;


  /// =========== SAVE ========================

  @override
  Future<void> saveUserData(Object value) async => userData = value;

}
