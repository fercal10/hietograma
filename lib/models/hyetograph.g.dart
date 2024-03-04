// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hyetograph.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HyetographAdapter extends TypeAdapter<Hyetograph> {
  @override
  final int typeId = 0;

  @override
  Hyetograph read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Hyetograph(
      name: fields[1] as String,
      altitude: fields[3] as int,
      baseTime: fields[4] as int,
      totalRainDuration: fields[5] as int,
      returnPeriod: fields[6] as int,
      zone: fields[7] as Zone,
    )
      ..id = fields[0] as int
      ..create = fields[2] as DateTime;
  }

  @override
  void write(BinaryWriter writer, Hyetograph obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.create)
      ..writeByte(3)
      ..write(obj.altitude)
      ..writeByte(4)
      ..write(obj.baseTime)
      ..writeByte(5)
      ..write(obj.totalRainDuration)
      ..writeByte(6)
      ..write(obj.returnPeriod)
      ..writeByte(7)
      ..write(obj.zone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HyetographAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
