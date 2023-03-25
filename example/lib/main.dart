import 'package:flutter/material.dart';
import 'package:fly_chat/fly_chat.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlyChat.init(ChatBuilder(
      domainBaseUrl: 'https://api-uikit-qa.contus.us/api/v1/',
      licenseKey: 'ckIjaccWBoMNvxdbql8LJ2dmKqT5bp',
      groupConfig: GroupConfig(
          enableGroup: true,
          maxMembersCount: 250), iOSContainerID: 'group.com.mirrorfly.qa'));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      );
  }
}

class MyAppState extends ChangeNotifier {
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Column(
        children: [
          Text('A random idea:'),
        ],
      ),
    );
  }
}
