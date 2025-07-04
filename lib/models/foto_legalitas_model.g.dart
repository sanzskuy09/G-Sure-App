// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'foto_legalitas_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FotoLegalitasAdapter extends TypeAdapter<FotoLegalitas> {
  @override
  final int typeId = 10;

  @override
  FotoLegalitas read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FotoLegalitas(
      fotoktppemohon: fields[0] as String?,
      fotoktppasangan: fields[1] as String?,
      fotokk: fields[2] as String?,
      fotosima: fields[3] as String?,
      fotonpwp: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FotoLegalitas obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.fotoktppemohon)
      ..writeByte(1)
      ..write(obj.fotoktppasangan)
      ..writeByte(2)
      ..write(obj.fotokk)
      ..writeByte(3)
      ..write(obj.fotosima)
      ..writeByte(4)
      ..write(obj.fotonpwp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FotoLegalitasAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
