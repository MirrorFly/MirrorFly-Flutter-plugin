import 'package:flutter/material.dart';
// import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:fly_chat/fly_chat.dart';

import '../../common/constants.dart';

class CallView extends StatelessWidget {
  const CallView({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () async {
          // await FlutterOverlayWindow.closeOverlay();
        },
        child: Container(
          padding: const EdgeInsets.all(20.0),
          color: Colors.white,
          child: Column(
            children: [
              Text(
                "Anna williams",
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    ?.copyWith(color: Colors.white),
              ),
              Text(
                "Calling…",
                style: TextStyle(color: Colors.white60),
              ),
              const SizedBox(height: 30,),
              ClipOval(
                child: Image.asset(
                  profileImg,
                  height: 150,
                  width: 150,
                ),
              ),
              Spacer(),
              Row(children: [
                TextButton(onPressed: (){
                  FlyChat.getDefaultNotificationUri().then((value) => debugPrint(value.toString()));
                }, child: Text("Accept")),
                TextButton(onPressed: () async {
                  // await FlutterOverlayWindow.closeOverlay();
                }, child: Text("Decline"))
              ],)
            ],
          ),
        ),
      ),
    );
  }
}
