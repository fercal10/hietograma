// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'curveEquation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CurveEquationAdapter extends TypeAdapter<CurveEquation> {
  @override
  final int typeId = 3;

  @override
  CurveEquation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CurveEquation(
      period: fields[1] as int,
      mult: fields[2] as double,
      power: fields[3] as double,
    )..id = fields[0] as int;
  }

  @override
  void write(BinaryWriter writer, CurveEquation obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.period)
      ..writeByte(2)
      ..write(obj.mult)
      ..writeByte(3)
      ..write(obj.power);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurveEquationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
