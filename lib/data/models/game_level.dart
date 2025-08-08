class GameLevel {
  final int gridSize;
  final int stars;
  final bool isUnlocked;

  GameLevel({
    required this.gridSize,
    this.stars = 0,
    this.isUnlocked = false,
  });
}