import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:draw_from_memory/core/app_colors.dart';
import '../../core/routes.dart';
import 'game_controller.dart';

class GameScreen extends StatelessWidget {
  final int gridSize;

  GameScreen({required this.gridSize});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${gridSize}x$gridSize',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 1,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: GetBuilder<GameController>(
        init: GameController(gridSize),
        builder: (controller) {
          if (controller.isLoadingNewPuzzle.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              Column(
                children: [
                  _buildLivesCounter(controller),
                  Expanded(child: _buildGrid(controller)),
                  _buildSubmitButton(controller),
                ],
              ),
              if (controller.isGameOver.value) _buildGameOverOverlay(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLivesCounter(GameController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Icon(
              index < controller.lives.value
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.redAccent,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGrid(GameController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: gridSize,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: gridSize * gridSize,
        itemBuilder: (_, index) => _buildTile(controller, index),
      ),
    );
  }

  Widget _buildTile(GameController controller, int index) {
    final isActive = controller.isPatternVisible.value
        ? controller.pattern[index]
        : controller.userInput[index];

    return GestureDetector(
      onTap: () => controller.toggleTile(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isActive ? AppColors.tileActive : AppColors.tileInactive,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(GameController controller) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: controller.submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 5,
        ),
        child: Text(
          'SUBMIT',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildGameOverOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.6),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'GAME OVER',
              style: TextStyle(
                fontSize: 36,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Get.offNamed(AppRoutes.levelSelect),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'BACK TO LEVELS',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
