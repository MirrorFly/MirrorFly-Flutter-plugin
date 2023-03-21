import 'package:get/get.dart';
import 'package:fly_chat_example/app/modules/settings/views/notification/notification_alert_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NotificationAlertController());
  }
}