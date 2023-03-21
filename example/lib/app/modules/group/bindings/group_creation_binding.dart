import 'package:get/get.dart';
import 'package:fly_chat_example/app/modules/group/controllers/group_creation_controller.dart';

class GroupCreationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GroupCreationController());
  }
}