import 'package:get/get.dart';
import 'package:fly_chat_example/app/modules/dashboard/controllers/dashboard_controller.dart';


class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(
          () => DashboardController(),
    );
  }
}
