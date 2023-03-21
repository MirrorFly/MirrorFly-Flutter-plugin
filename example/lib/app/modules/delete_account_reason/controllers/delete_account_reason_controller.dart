import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:fly_chat_example/app/common/constants.dart';
import 'package:fly_chat/flysdk.dart';

import '../../../data/apputils.dart';
import '../../../data/session_management.dart';
import '../../../data/helper.dart';
import '../../../routes/app_pages.dart';

class DeleteAccountReasonController extends FullLifeCycleController
    with FullLifeCycleMixin {
  var reasonValue = "".obs;
  TextEditingController feedback = TextEditingController();

  var deleteReasons = [
    'I am changing my phone number',
    'MirrorFly is missing a feature',
    'MirrorFly is not working',
    'Other',
  ];

  get focusNode => FocusNode();

  deleteAccount() {
    Helper.showAlert(
        title: "Proceed to delete your account?",
        message:
            "Deleting your account is permanent. Your data cannot be recovered if you reactivate your MirrorFly account in future.",
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("CANCEL")),
          TextButton(
              onPressed: () async {
                deleteUserAccount();
              },
              child: const Text("OK")),
        ]);
  }

  Future<void> deleteUserAccount() async {
    if (await AppUtils.isNetConnected()) {
      Get.back();
      // Future.delayed(const Duration(milliseconds: 100), () {
        Helper.showLoading(message: "Deleting Account");
        FlyChat.deleteAccount(reasonValue.value, feedback.text).then((value) async {
          Helper.hideLoading();
          SessionManagement.clear().then((value){
            Get.offAllNamed(Routes.login);
          });
        }).catchError((error) {
          Helper.hideLoading();
          toToast("Unable to delete the account");
        });
      // });
    } else {
      toToast(Constants.noInternetConnection);
    }
  }

  @override
  void onDetached() {}

  @override
  void onInactive() {}

  @override
  void onPaused() {}

  @override
  void onResumed() {
    if (!KeyboardVisibilityController().isVisible) {
      if (focusNode.hasFocus) {
        focusNode.unfocus();
        Future.delayed(const Duration(milliseconds: 100), () {
          focusNode.requestFocus();
        });
      }
    }
  }
}
