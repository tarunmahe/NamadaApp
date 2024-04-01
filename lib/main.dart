import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:namadaapp/actions/balance.dart';
import 'package:namadaapp/api/apicontroller.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:namadaapp/firebase_options.dart';
import 'package:namadaapp/namada/splash.dart';

Future main() async {
  await dotenv.load(fileName: ".env");

  Get.put(ApiController());
  Get.put(BalanceController());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Namada Utilities',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
