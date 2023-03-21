import 'package:get/get.dart';
import 'package:fly_chat_example/app/modules/video_preview/controllers/video_play_controller.dart';


class VideoPlayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VideoPlayController>(
          () => VideoPlayController(),
    );
  }
}
