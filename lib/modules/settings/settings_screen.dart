import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'settings_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: colorScheme.onPrimary,
          ),
        ),
        backgroundColor: colorScheme.primary,
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          children: [
            _buildStyledSwitchTile(
              context,
              title: 'Sound Effects',
              value: controller.settings.value.soundEnabled,
              onChanged: controller.toggleSound,
            ),
            SizedBox(height: 12),
            _buildStyledSwitchTile(
              context,
              title: 'Haptic Feedback',
              value: controller.settings.value.hapticFeedbackEnabled,
              onChanged: controller.toggleHaptics,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyledSwitchTile(
    BuildContext context, {
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withOpacity(0.1)),
      ),
      child: SwitchListTile(
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: colorScheme.onBackground,
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: colorScheme.primary,
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}
