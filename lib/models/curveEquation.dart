import 'dart:math';
import 'package:hive/hive.dart';
part 'curveEquation.g.dart';


@HiveType(typeId: 3)
class CurveEquation extends HiveObject {
  @HiveField(0)
  int id=0;
  @HiveField(1)
  int period;
  @HiveField(2)
  double mult;
  @HiveField(3)
  double power;

  CurveEquation(
      {required this.period, required this.mult, required this.power});

  double calculate(int x) {
    return (mult * (pow(x, power)));
  }

  factory CurveEquation.fromJson(Map<String, dynamic> json) => CurveEquation(
        period: json["period"],
        mult: json["mult"]?.toDouble(),
        power: json["power"]?.toDouble(),
      );
}
