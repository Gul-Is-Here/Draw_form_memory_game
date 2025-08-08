import 'package:get/get.dart';
import 'package:draw_from_memory/data/repositories/game_repository.dart';
import 'package:draw_from_memory/data/models/game_level.dart';

import '../../core/routes.dart';

class LevelSelectController extends GetxController {
  final GameRepository _gameRepo = GameRepository();
  var levels = <GameLevel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    _loadLevels();
    super.onInit();
  }

  Future<void> _loadLevels() async {
    try {
      isLoading.value = true;
      levels.value = await _gameRepo.getLevels();
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToGame(int gridSize) {
    if (levels.any((level) => level.gridSize == gridSize && level.isUnlocked)) {
      Get.toNamed(AppRoutes.game, arguments: gridSize);
    } else {
      Get.snackbar('Locked', 'Complete previous levels to unlock!');
    }
  }
}