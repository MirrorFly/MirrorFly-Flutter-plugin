import 'package:get/get.dart';
import 'package:fly_chat_example/app/modules/dashboard/controllers/recent_chat_search_controller.dart';


class RecentSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecentChatSearchController>(
          () => RecentChatSearchController(),
    );
  }
}
