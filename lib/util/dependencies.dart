import 'package:get/get.dart';
import 'package:hietograma/controllers/zoneController.dart';

import 'package:hive_flutter/adapters.dart';

import '../controllers/hyetographController.dart';
import '../models/curveEquation.dart';
import '../models/curveIDF.dart';
import '../models/hyetograph.dart';
import '../models/zone.dart';


Future<void> init()async{
  await Hive.initFlutter();

  Hive.registerAdapter(HyetographAdapter());
  Hive.registerAdapter(ZoneAdapter());
  Hive.registerAdapter(CurveIDFAdapter());
  Hive.registerAdapter(CurveEquationAdapter());

  Get.lazyPut(()=>ZoneController());
  Get.lazyPut(()=>HyetographController());


}