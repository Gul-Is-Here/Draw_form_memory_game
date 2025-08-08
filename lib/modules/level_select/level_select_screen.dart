import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:draw_from_memory/core/app_colors.dart';
import 'package:draw_from_memory/core/app_text_styles.dart';
import 'evel_select_controller.dart';

class LevelSelectScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LevelSelectController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Level', style: headingStyle),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withOpacity(0.8),
                AppColors.accent.withOpacity(0.6),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary.withOpacity(0.05),
              AppColors.accent.withOpacity(0.05),
            ],
          ),
        ),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ).animate().scale(duration: 500.ms),
            );
          }
          return Padding(
            padding: EdgeInsets.all(16),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 220,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 1.1,
              ),
              itemCount: controller.levels.length,
              itemBuilder: (_, index) {
                final level = controller.levels[index];
                return _LevelCard(
                  gridSize: level.gridSize,
                  stars: level.stars,
                  isUnlocked: level.isUnlocked,
                  onTap: () => controller.navigateToGame(level.gridSize),
                ).animate().scale(delay: (100 * index).ms);
              },
            ),
          );
        }),
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final int gridSize;
  final int stars;
  final bool isUnlocked;
  final VoidCallback onTap;

  const _LevelCard({
    required this.gridSize,
    required this.stars,
    required this.isUnlocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: 300.ms,
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: isUnlocked
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withOpacity(0.8),
                  AppColors.accent.withOpacity(0.6),
                ],
              )
            : LinearGradient(
                colors: [Colors.grey.shade300, Colors.grey.shade400],
              ),
        boxShadow: [
          BoxShadow(
            color: isUnlocked
                ? AppColors.primary.withOpacity(0.3)
                : Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: isUnlocked ? onTap : null,
          splashColor: isUnlocked ? Colors.white.withOpacity(0.2) : null,
          highlightColor: isUnlocked ? AppColors.accent.withOpacity(0.1) : null,
          child: Padding(
            padding: EdgeInsets.all(12), // Reduced padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min, // Added this line
              children: [
                // Grid Size Indicator
                Container(
                  width: 60, // Reduced size
                  height: 60, // Reduced size
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isUnlocked
                        ? Colors.white.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.3),
                    border: Border.all(
                      color: isUnlocked ? Colors.white : Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${gridSize}x$gridSize',
                      style: headingStyle.copyWith(
                        fontSize: 18, // Reduced font size
                        color: isUnlocked ? Colors.white : Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8), // Reduced spacing
                // Difficulty Label
                Text(
                  _getDifficultyLabel(),
                  style: bodyStyle.copyWith(
                    fontSize: 12, // Reduced font size
                    color: isUnlocked ? Colors.white : Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 6), // Reduced spacing
                // Stars Rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2,
                      ), // Reduced star spacing
                      child: Icon(
                        index < stars ? Icons.star : Icons.star_outline,
                        color: isUnlocked ? Colors.amber : Colors.grey.shade600,
                        size: 16, // Reduced icon size
                      ),
                    );
                  }),
                ),
                if (!isUnlocked) ...[
                  SizedBox(height: 4), // Reduced spacing
                  Icon(
                    Icons.lock_outline,
                    color: Colors.white.withOpacity(0.8),
                    size: 16, // Reduced icon size
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getDifficultyLabel() {
    switch (gridSize) {
      case 3:
        return 'EASY';
      case 4:
        return 'MEDIUM';
      case 5:
        return 'HARD';
      default:
        return 'CUSTOM';
    }
  }
}
