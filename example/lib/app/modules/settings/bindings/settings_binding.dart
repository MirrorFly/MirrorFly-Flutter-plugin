import 'package:get/get.dart';
import 'package:fly_chat_example/app/modules/settings/controllers/settings_controller.dart';

class SettingsBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(
          () => SettingsController(),
    );
  }

}