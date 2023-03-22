import 'package:get/get.dart';
import 'package:fly_chat_example/app/modules/contact_sync/controllers/contact_sync_controller.dart';

class ContactSyncBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ContactSyncController());
  }
}