// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'foto_kendaraan_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FotoKendaraanAdapter extends TypeAdapter<FotoKendaraan> {
  @override
  final int typeId = 9;

  @override
  FotoKendaraan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FotoKendaraan(
      odometer: fields[0] as String?,
      fotounitdepan: fields[1] as String?,
      fotounitbelakang: fields[2] as String?,
      fotounitinteriordepan: fields[3] as String?,
      fotounitmesinplat: fields[4] as String?,
      fotomesin: fields[5] as String?,
      fotounitselfiecmo: fields[6] as String?,
      fotospeedometer: fields[7] as String?,
      fotogesekannoka: fields[8] as String?,
      fotostnk: fields[9] as String?,
      fotonoticepajak: fields[10] as String?,
      fotobpkb1: fields[11] as String?,
      fotobpkb2: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FotoKendaraan obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.odometer)
      ..writeByte(1)
      ..write(obj.fotounitdepan)
      ..writeByte(2)
      ..write(obj.fotounitbelakang)
      ..writeByte(3)
      ..write(obj.fotounitinteriordepan)
      ..writeByte(4)
      ..write(obj.fotounitmesinplat)
      ..writeByte(5)
      ..write(obj.fotomesin)
      ..writeByte(6)
      ..write(obj.fotounitselfiecmo)
      ..writeByte(7)
      ..write(obj.fotospeedometer)
      ..writeByte(8)
      ..write(obj.fotogesekannoka)
      ..writeByte(9)
      ..write(obj.fotostnk)
      ..writeByte(10)
      ..write(obj.fotonoticepajak)
      ..writeByte(11)
      ..write(obj.fotobpkb1)
      ..writeByte(12)
      ..write(obj.fotobpkb2);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FotoKendaraanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
