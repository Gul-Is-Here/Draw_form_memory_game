import 'package:get/get.dart';
import 'evel_select_controller.dart';


class LevelSelectBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LevelSelectController());
  }
}