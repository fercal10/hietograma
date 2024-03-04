import 'package:geobase/geobase.dart';
import 'package:hietograma/models/curveIDF.dart';
import 'package:hive/hive.dart';

part 'zone.g.dart';

@HiveType(typeId: 1)
class Zone extends HiveObject {
  @HiveField(0)
  int id = 0;
  @HiveField(1)
  String name;
  @HiveField(2)
  int heightMin;
  @HiveField(3)
  int heightMax;
  @HiveField(4)
  List<CurveIDF> curves;
  @HiveField(5)
  List<List<double>> coordinates;

  Zone(
      {required this.name,
      required this.heightMax,
      required this.heightMin,
      required this.curves,
      this.coordinates = const []});

  factory Zone.fromJson(Map<String, dynamic> json) => Zone(
      name: json["name"],
      heightMin: json["heightMin"],
      heightMax: json["heightMax"],
      curves:
          List<CurveIDF>.from(json["curves"].map((x) => CurveIDF.fromJson(x))),
      coordinates: List<List<double>>.from(
          json["coordinates"].map((x) => List<double>.from(x))));
}
