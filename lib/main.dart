import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:draw_from_memory/core/routes.dart';
import 'package:draw_from_memory/modules/home/home_screen.dart';
import 'package:draw_from_memory/modules/home/home_binding.dart';
import 'package:draw_from_memory/modules/settings/settings_screen.dart';
import 'package:draw_from_memory/modules/settings/settings_binding.dart';
import 'package:draw_from_memory/modules/level_select/level_select_screen.dart';
import 'package:draw_from_memory/modules/game/game_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Draw From Memory',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      initialRoute: AppRoutes.home,
      initialBinding: HomeBinding(),
      getPages: [
        
        GetPage(name: AppRoutes.home, page: () => HomeScreen(), binding: HomeBinding()),
        GetPage(name: AppRoutes.settings, page: () => SettingsScreen(), binding: SettingsBinding()),
        GetPage(name: AppRoutes.levelSelect, page: () => LevelSelectScreen()),
        GetPage(name: AppRoutes.game, page: () => GameScreen(gridSize: Get.arguments)),
      ],
    );
  }
}