import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:draw_from_memory/core/app_colors.dart';
import 'package:draw_from_memory/core/app_text_styles.dart';
import 'home_controller.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withOpacity(0.1),
                  AppColors.accent.withOpacity(0.1),
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated Logo
                  Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.8),
                              blurRadius: 20,
                              spreadRadius: 2,
                              offset: Offset(-4, -4),
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              spreadRadius: 1,
                              offset: Offset(4, 4),
                            ),
                          ],
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.primary.withOpacity(0.3),
                              AppColors.accent.withOpacity(0.3),
                            ],
                          ),
                        ),
                        child: Icon(
                          Icons.memory,
                          size: 80,
                          color: AppColors.primary,
                        ),
                      )
                      .animate()
                      .scale(duration: 800.ms)
                      .then(delay: 200.ms)
                      .shake(),

                  SizedBox(height: 40),

                  // Game Title
                  Text(
                    'Draw From Memory',
                    style: headingStyle.copyWith(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      foreground: Paint()
                        ..shader = LinearGradient(
                          colors: [AppColors.primary, AppColors.accent],
                        ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                    ),
                  ).animate().fadeIn(duration: 500.ms),

                  SizedBox(height: 40),

                  // Play Button
                  _buildNeumorphicButton(
                    onPressed: Get.find<HomeController>().navigateToLevelSelect,
                    icon: Icons.play_arrow_rounded,
                    label: 'Play Game',
                    color: AppColors.primary,
                  ).animate().slideX(
                    begin: -1,
                    duration: 500.ms,
                    curve: Curves.easeOutBack,
                  ),

                  SizedBox(height: 20),

                  // Settings Button
                  _buildNeumorphicButton(
                    onPressed: Get.find<HomeController>().navigateToSettings,
                    icon: Icons.settings,
                    label: 'Settings',
                    color: AppColors.accent,
                  ).animate().slideX(
                    begin: 1,
                    duration: 500.ms,
                    curve: Curves.easeOutBack,
                  ),
                ],
              ),
            ),
          ),

          // Info Button in top right corner
          Positioned(top: 40, right: 20, child: _buildInfoButton()),
        ],
      ),
    );
  }

  Widget _buildInfoButton() {
    return IconButton(
      icon: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withOpacity(0.2),
              AppColors.accent.withOpacity(0.2),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.8),
              blurRadius: 10,
              offset: Offset(-3, -3),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(3, 3),
            ),
          ],
        ),
        child: Icon(
          Icons.info_outline_rounded,
          color: AppColors.primary,
          size: 28,
        ),
      ),
      onPressed: () => _showHowToPlayDialog(),
    ).animate().fadeIn(delay: 300.ms);
  }

  void _showHowToPlayDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'How to Play',
          style: headingStyle.copyWith(color: AppColors.primary, fontSize: 24),
          textAlign: TextAlign.center,
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInstructionStep(
                '1.',
                'Look at the image carefully for a few seconds.',
              ),
              _buildInstructionStep('2.', 'Try to remember all the details.'),
              _buildInstructionStep(
                '3.',
                'Draw what you remember on the canvas.',
              ),
              _buildInstructionStep(
                '4.',
                'Compare your drawing with the original.',
              ),
              _buildInstructionStep('5.', 'Score points based on accuracy!'),
              SizedBox(height: 20),
              Text(
                'Tip: The better you remember details, the higher your score!',
                style: bodyStyle.copyWith(
                  fontStyle: FontStyle.italic,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Got It!',
              style: bodyStyle.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  Widget _buildInstructionStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: bodyStyle.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              fontSize: 16,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: bodyStyle.copyWith(fontSize: 16, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNeumorphicButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            blurRadius: 15,
            offset: Offset(-5, -5),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(5, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: color,
          backgroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24),
            SizedBox(width: 10),
            Text(
              label,
              style: bodyStyle.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
