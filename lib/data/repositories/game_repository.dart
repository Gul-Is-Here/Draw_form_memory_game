import 'package:draw_from_memory/core/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_level.dart';

class GameRepository {
  Future<List<GameLevel>> getLevels() async {
    final prefs = await SharedPreferences.getInstance();
    // Load saved progress (simplified)
    return AppConstants.gridSizes.map((size) {
      return GameLevel(
        gridSize: size,
        isUnlocked: size == 3 || (prefs.getBool('unlocked_$size') ?? false),

        stars: prefs.getInt('stars_$size') ?? 0,
      );
    }).toList();
  }

  Future<void> saveLevelProgress(int gridSize, int stars) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('stars_$gridSize', stars);
    if (stars >= 3 && gridSize < 5) {
      await prefs.setBool('unlocked_${gridSize + 1}', true);
    }
  }
}
