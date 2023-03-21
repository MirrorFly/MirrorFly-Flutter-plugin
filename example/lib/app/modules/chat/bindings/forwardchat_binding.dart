import 'package:get/get.dart';
import 'package:fly_chat_example/app/modules/chat/controllers/forwardchat_controller.dart';

class ForwardChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ForwardChatController());
  }
}