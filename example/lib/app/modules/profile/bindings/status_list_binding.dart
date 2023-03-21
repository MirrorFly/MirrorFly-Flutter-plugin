import 'package:get/get.dart';
import 'package:fly_chat_example/app/modules/profile/controllers/status_controller.dart';

class StatusListBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<StatusListController>(
          () => StatusListController(),
    );
  }

}