import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_settings.dart';

class SettingsRepository {
  static const _keySound = 'sound_enabled';
  static const _keyHaptics = 'haptics_enabled';
  static const _keyTheme = 'theme_mode';

  Future<GameSettings> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return GameSettings(
      soundEnabled: prefs.getBool(_keySound) ?? true,
      hapticFeedbackEnabled: prefs.getBool(_keyHaptics) ?? true,
      themeMode: prefs.getString(_keyTheme) ?? 'light',
    );
  }

  Future<void> saveSettings(GameSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keySound, settings.soundEnabled);
    await prefs.setBool(_keyHaptics, settings.hapticFeedbackEnabled);
    await prefs.setString(_keyTheme, settings.themeMode);
  }
}