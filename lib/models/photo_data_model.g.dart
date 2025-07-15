// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PhotoDataAdapter extends TypeAdapter<PhotoData> {
  @override
  final int typeId = 12;

  @override
  PhotoData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PhotoData(
      path: fields[0] as String?,
      timestamp: fields[1] as DateTime?,
      latitude: fields[2] as double?,
      longitude: fields[3] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, PhotoData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.path)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.latitude)
      ..writeByte(3)
      ..write(obj.longitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhotoDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
