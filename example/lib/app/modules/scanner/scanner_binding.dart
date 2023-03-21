import 'package:get/get.dart';
import 'package:fly_chat_example/app/modules/scanner/scanner_controller.dart';

class ScannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ScannerController());
  }
}