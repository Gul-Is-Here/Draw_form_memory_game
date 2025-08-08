import 'dart:async';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:draw_from_memory/data/repositories/game_repository.dart';
import 'package:draw_from_memory/data/repositories/settings_repository.dart';
import 'package:draw_from_memory/core/routes.dart';
import 'package:draw_from_memory/core/constants.dart';

class GameController extends GetxController {
  final int gridSize;
  final GameRepository _gameRepo = GameRepository();
  final SettingsRepository _settingsRepo = SettingsRepository();

  Timer? _patternTimer;
  final CountDownController timerController = CountDownController();

  var isLoadingNewPuzzle = true.obs;
  var isPatternVisible = true.obs;
  var score = 0.obs;
  var lives = 3.obs;
  var isGameOver = false.obs;
  var remainingTime = AppConstants.patternDisplayDuration.obs;

  late List<bool> pattern; // ✅ Fixed: marked as late
  late List<bool> userInput;

  GameController(this.gridSize);

  @override
  void onInit() {
    super.onInit();
    _loadInitialGame();
  }

  @override
  void onClose() {
    _patternTimer?.cancel();
    timerController.pause();
    super.onClose();
  }

  Future<void> _loadInitialGame() async {
    await _showLoading();
    _startNewRound();
  }

  Future<void> _showLoading() async {
    isLoadingNewPuzzle.value = true;
    await Future.delayed(500.ms);
    isLoadingNewPuzzle.value = false;
  }

  void _generatePattern() {
    final totalTiles = gridSize * gridSize;
    pattern = List.generate(totalTiles, (_) => Random().nextBool());
    userInput = List.filled(totalTiles, false);
  }

  void _startNewRound() {
    _generatePattern();
    isPatternVisible.value = true;
    remainingTime.value = AppConstants.patternDisplayDuration;
    timerController.restart();

    _patternTimer?.cancel();
    _patternTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime.value > 0) {
        remainingTime.value--;
      } else {
        timer.cancel();
      }
    });

    Timer(Duration(seconds: AppConstants.patternDisplayDuration), () {
      isPatternVisible.value = false;
      timerController.pause();
      update();
    });

    update();
  }

  void toggleTile(int index) async {
    if (isPatternVisible.value || isGameOver.value || isLoadingNewPuzzle.value)
      return;

    userInput[index] = !userInput[index];
    update();

    final settings = await _settingsRepo.getSettings();
    if (settings.hapticFeedbackEnabled && await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 50);
    }
  }

  Future<void> submit() async {
    if (isPatternVisible.value || isGameOver.value || isLoadingNewPuzzle.value)
      return;

    final isCorrect = _checkSolution();
    final settings = await _settingsRepo.getSettings();

    if (isCorrect) {
      score.value = _calculateScore();
      await _gameRepo.saveLevelProgress(gridSize, score.value);
      await _showLoading();
      _resetInputs();
      _startNewRound();
    } else {
      lives.value--;
      if (lives.value <= 0) {
        isGameOver.value = true;
        await Future.delayed(NumDurationExtensions(1).seconds);
        Get.offNamed(AppRoutes.levelSelect);
      } else {
        await _showLoading();
        _resetInputs();
        _startNewRound();
      }
    }
  }

  void _resetInputs() {
    userInput = List.filled(gridSize * gridSize, false);
    update();
  }

  bool _checkSolution() =>
      const ListEquality<bool>().equals(pattern, userInput);

  int _calculateScore() {
    final correctTiles = pattern.where((val) => val).length;
    final accuracy = correctTiles / pattern.length;
    return accuracy >= 0.9
        ? 3
        : accuracy >= 0.6
        ? 2
        : 1;
  }

  void restartGame() {
    lives.value = 3;
    score.value = 0;
    isGameOver.value = false;
    _resetInputs();
    _startNewRound();
  }
}
