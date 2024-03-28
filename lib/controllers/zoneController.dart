import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../models/zone.dart';


class ZoneController extends GetxController {
  late final Box<Zone> _zoneBox;
  final zones = <Zone>[];
  final String filePath = "assents/seedDataConCoordenadas.json";

  @override
  Future<void> onInit() async {
    await getZones();
    super.onInit();
  }



  Future<void> getZones() async {
    _zoneBox =  await Hive.openBox<Zone>('zones');
    await _zoneBox.clear();
    await seedData();

    loadZones();
  }

  Future<void> seedData() async {
    final String response = await rootBundle.loadString(filePath);
    final data = jsonDecode(response);
    final zones = data['zones'];
    if (zones != null) {
      zones.forEach((element) async {
        Zone newZone = Zone.fromJson(element);
         _zoneBox.add(newZone);
      });
    }
  }

  Zone? getZoneById(int id) {
    return _zoneBox.get(id);
  }

  void loadZones() {
    zones.clear();
    zones.addAll(_zoneBox.values);
    update();
  }
}
