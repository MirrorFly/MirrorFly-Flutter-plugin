import 'package:flutter/material.dart';
import 'package:mirrorfly_plugin/mirrorfly.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Mirrorfly.initializeSDK(
      licenseKey: 'your license key',
      iOSContainerID: 'your app group id',
      flyCallback: (FlyResponse response){
        if(response.isSuccess){
          LogMessage.d("onSuccess", response.message);
        }else{
          LogMessage.d("onFailure", response.exception?.message.toString());
        }
      });//Must be same as AppGroups given in Xcode Capability
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Name App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyAppState extends ChangeNotifier {}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // var appState = context.watch<MyAppState>();

    return const Scaffold(
      body: Column(
        children: [
          Text('Welcome to Mirrorfly'),
        ],
      ),
    );
  }
}
