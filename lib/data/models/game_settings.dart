class GameSettings {
   bool soundEnabled;
   bool hapticFeedbackEnabled;
  final String themeMode; // 'light', 'dark', 'system'

  GameSettings({
    this.soundEnabled = true,
    this.hapticFeedbackEnabled = true,
    this.themeMode = 'light',
  });
}