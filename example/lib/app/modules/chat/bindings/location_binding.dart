import 'package:get/get.dart';
import 'package:fly_chat_example/app/modules/chat/controllers/location_controller.dart';

class LocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocationController>(
          () => LocationController(),
    );
  }
}
