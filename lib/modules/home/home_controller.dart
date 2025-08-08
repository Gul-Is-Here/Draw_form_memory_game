import 'package:get/get.dart';
import 'package:draw_from_memory/data/repositories/settings_repository.dart';

import '../../core/routes.dart';
import '../../data/models/game_settings.dart';

class HomeController extends GetxController {
  final SettingsRepository _settingsRepo = SettingsRepository();
  var settings = GameSettings().obs;

  @override
  void onInit() {
    _loadSettings();
    super.onInit();
  }

  Future<void> _loadSettings() async {
    settings.value = await _settingsRepo.getSettings();
  }

  void navigateToLevelSelect() => Get.toNamed(AppRoutes.levelSelect);
  void navigateToSettings() => Get.toNamed(AppRoutes.settings);
}