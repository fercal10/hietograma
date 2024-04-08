import 'package:get/get.dart';
import 'package:Hietograma/controllers/zoneController.dart';

import 'package:hive_flutter/adapters.dart';

import '../controllers/hyetographController.dart';
import '../models/curveEquation.dart';
import '../models/curveIDF.dart';
import '../models/hyetograph.dart';
import '../models/zone.dart';

Future<void> init() async {
  await Hive.initFlutter();

  Hive.registerAdapter(CurveEquationAdapter());
  Hive.registerAdapter(CurveIDFAdapter());
  Hive.registerAdapter(ZoneAdapter());
  Hive.registerAdapter(HyetographAdapter());

  Get.lazyPut(() => ZoneController());
  Get.lazyPut(() => HyetographController());
}
