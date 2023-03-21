import 'package:get/get.dart';
import 'package:fly_chat_example/app/modules/login/controllers/country_controller.dart';


class CountryListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CountryController>(
      () => CountryController(),
    );
  }
}
