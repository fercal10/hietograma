// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zone.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ZoneAdapter extends TypeAdapter<Zone> {
  @override
  final int typeId = 1;

  @override
  Zone read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Zone(
      name: fields[1] as String,
      heightMax: fields[3] as int,
      heightMin: fields[2] as int,
      curves: (fields[4] as List).cast<CurveIDF>(),
      coordinates: (fields[5] as List)
          .map((dynamic e) => (e as List).cast<double>())
          .toList(),
    )..id = fields[0] as int;
  }

  @override
  void write(BinaryWriter writer, Zone obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.heightMin)
      ..writeByte(3)
      ..write(obj.heightMax)
      ..writeByte(4)
      ..write(obj.curves)
      ..writeByte(5)
      ..write(obj.coordinates);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZoneAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
