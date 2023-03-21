import 'package:get/get.dart';

import 'package:fly_chat_example/app/modules/settings/views/blocked/blocked_list_controller.dart';

class BlockedListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BlockedListController());
  }
}