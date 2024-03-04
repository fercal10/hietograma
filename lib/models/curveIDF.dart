import 'package:hietograma/models/curveEquation.dart';
import 'package:hive/hive.dart';

part 'curveIDF.g.dart';

@HiveType(typeId: 2)
class CurveIDF extends HiveObject {
  @HiveField(0)
  int id = 0;
  @HiveField(1)
  int heightMin;
  @HiveField(2)
  int heightMax;
  @HiveField(3)
  List<CurveEquation> curveEquations;
  @HiveField(4)
  String name;

  CurveIDF(
      {required this.name,
      required this.heightMin,
      required this.heightMax,
      required this.curveEquations});

  factory CurveIDF.fromJson(Map<String, dynamic> json) => CurveIDF(
      heightMin: json["heightMin"],
      heightMax: json["heightMax"],
      name: json["name"],
      curveEquations: List<CurveEquation>.from(
          json["curveEquations"].map((x) => CurveEquation.fromJson(x))));
}
