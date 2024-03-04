// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'curveIDF.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CurveIDFAdapter extends TypeAdapter<CurveIDF> {
  @override
  final int typeId = 2;

  @override
  CurveIDF read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CurveIDF(
      name: fields[4] as String,
      heightMin: fields[1] as int,
      heightMax: fields[2] as int,
      curveEquations: (fields[3] as List).cast<CurveEquation>(),
    )..id = fields[0] as int;
  }

  @override
  void write(BinaryWriter writer, CurveIDF obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.heightMin)
      ..writeByte(2)
      ..write(obj.heightMax)
      ..writeByte(3)
      ..write(obj.curveEquations)
      ..writeByte(4)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurveIDFAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
