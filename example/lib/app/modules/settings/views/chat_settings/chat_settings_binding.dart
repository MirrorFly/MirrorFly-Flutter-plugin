import 'package:get/get.dart';
import 'package:fly_chat_example/app/modules/settings/views/chat_settings/chat_settings_controller.dart';

class ChatSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatSettingsController());
  }
}