
import 'package:get/get.dart';
import 'package:draw_from_memory/data/repositories/settings_repository.dart';

import '../../data/models/game_settings.dart';

class SettingsController extends GetxController {
  final SettingsRepository _repo = SettingsRepository();
  var settings = GameSettings().obs;

  @override
  void onInit() {
    _loadSettings();
    super.onInit();
  }

  Future<void> _loadSettings() async {
    settings.value = await _repo.getSettings();
  }

  void toggleSound(bool value) {
    settings.update((val) => val?.soundEnabled = value);
    _repo.saveSettings(settings.value);
  }

  void toggleHaptics(bool value) {
    settings.update((val) => val?.hapticFeedbackEnabled = value);
    _repo.saveSettings(settings.value);
  }
}