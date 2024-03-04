import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hietograma/routes/routes.dart';
import 'package:hietograma/screens/hyetographScreen.dart';
import 'package:hietograma/util/dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HyetographScreen(),
      getPages: RouterHelper.route,
    );
  }
}
