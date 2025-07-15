// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_kendaraan_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataKendaraanAdapter extends TypeAdapter<DataKendaraan> {
  @override
  final int typeId = 2;

  @override
  DataKendaraan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataKendaraan(
      kondisiKendaraan: fields[0] as String?,
      merkkendaraan: fields[1] as String?,
      typekendaraan: fields[2] as String?,
      tahunkendaraan: fields[3] as String?,
      nopolisikendaraan: fields[4] as String?,
      hargakendaraan: fields[5] as String?,
      uangmuka: fields[6] as String?,
      pokokhutang: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DataKendaraan obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.kondisiKendaraan)
      ..writeByte(1)
      ..write(obj.merkkendaraan)
      ..writeByte(2)
      ..write(obj.typekendaraan)
      ..writeByte(3)
      ..write(obj.tahunkendaraan)
      ..writeByte(4)
      ..write(obj.nopolisikendaraan)
      ..writeByte(5)
      ..write(obj.hargakendaraan)
      ..writeByte(6)
      ..write(obj.uangmuka)
      ..writeByte(7)
      ..write(obj.pokokhutang);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataKendaraanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
