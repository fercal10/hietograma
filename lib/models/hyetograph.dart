import 'package:get/get.dart';
import 'package:hietograma/models/zone.dart';
import 'package:hive/hive.dart';

import '../util/sharedFunctions.dart';
import 'curveEquation.dart';

part 'hyetograph.g.dart';


@HiveType(typeId: 0)
class Hyetograph extends HiveObject{

  @HiveField(0)
  int id=0;
  @HiveField(1)
  String name;
  @HiveField(2)
  DateTime create= DateTime.now();
  @HiveField(3)
  int altitude;
  @HiveField(4)
  int baseTime;
  @HiveField(5)
  int totalRainDuration;
  @HiveField(6)
  int returnPeriod;
  @HiveField(7)
  Zone zone;
  @HiveField(8)
  String sectorName;

  Hyetograph({
    required this.name,
    required this.altitude,
    required this.baseTime,
    required this.totalRainDuration,
    required this.returnPeriod,
    required this.zone,
    required this.sectorName,
});

  int getIndexSector() {
    return zone.curves.indexWhere((curve)=>curve.name==sectorName);
  }

  List<double> getData(){
    final curveEquations = getCurveEquations();
    List<double> tempList =[];
    List<int> durations =getDurations();
    for (int i = 0; i < durations.length; i++) {
      int periodo = periodToIndex(returnPeriod);
      double actual = curveEquations[periodo].calculate(durations[i]);
      double anterior = i != 0 ? curveEquations[periodo].calculate(durations[i - 1]) : 0;
      double result = i != 0 ? anterior - actual : actual;
      tempList.add(result.toPrecision(2));
    }
    return tempList;
  }

  List<int> getDurations(){
    List<int> tempList = [];
    for (int i = baseTime; i <= totalRainDuration; i += baseTime) {
      tempList.add(i);
    }
    return tempList;

  }

  List<CurveEquation> getCurveEquations(){
    return zone.curves[getIndexSector()].curveEquations;
  }



}