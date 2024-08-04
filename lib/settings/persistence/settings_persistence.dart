/// An interface of persistence stores for settings.
///
/// Implementations can range from simple in-memory storage through
/// local preferences to cloud-based solutions.
abstract class SettingsPersistence {
  /// ========== GET THE DATA ===================
  Future<Object> getUserData();

  /// ========== SAVE THE DATA ===================
  Future<void> saveUserData(Object value);
}
