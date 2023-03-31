import 'package:flutter/material.dart';
import 'package:fly_chat/fly_chat.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlyChat.init(
      baseUrl: 'https://api-uikit-qa.contus.us/api/v1/',
      licenseKey: 'your license key',
      iOSContainerID: 'group.com.mirrorfly.qa');
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

class MyAppState extends ChangeNotifier {}

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
