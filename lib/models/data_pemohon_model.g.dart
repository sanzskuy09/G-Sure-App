// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_pemohon_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataPemohonAdapter extends TypeAdapter<DataPemohon> {
  @override
  final int typeId = 4;

  @override
  DataPemohon read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataPemohon(
      katpemohon: fields[0] as String?,
      statuspernikahan: fields[1] as String?,
      nama: fields[2] as String?,
      agamapemohon: fields[3] as String?,
      pendidikan: fields[4] as String?,
      warganegarapemohon: fields[5] as String?,
      nomortelepon: fields[6] as String?,
      nohp: fields[7] as String?,
      email: fields[8] as String?,
      sim: fields[9] as String?,
      npwp: fields[10] as String?,
      namaibu: fields[11] as String?,
      statusrumah: fields[12] as String?,
      lokasirumah: fields[13] as String?,
      katrumahpemohon: fields[14] as String?,
      buktimilikrumahpemohon: fields[15] as String?,
      lamatinggalpemohon: fields[16] as String?,
      dataPekerjaan: fields[17] as DataPekerjaan?,
    );
  }

  @override
  void write(BinaryWriter writer, DataPemohon obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.katpemohon)
      ..writeByte(1)
      ..write(obj.statuspernikahan)
      ..writeByte(2)
      ..write(obj.nama)
      ..writeByte(3)
      ..write(obj.agamapemohon)
      ..writeByte(4)
      ..write(obj.pendidikan)
      ..writeByte(5)
      ..write(obj.warganegarapemohon)
      ..writeByte(6)
      ..write(obj.nomortelepon)
      ..writeByte(7)
      ..write(obj.nohp)
      ..writeByte(8)
      ..write(obj.email)
      ..writeByte(9)
      ..write(obj.sim)
      ..writeByte(10)
      ..write(obj.npwp)
      ..writeByte(11)
      ..write(obj.namaibu)
      ..writeByte(12)
      ..write(obj.statusrumah)
      ..writeByte(13)
      ..write(obj.lokasirumah)
      ..writeByte(14)
      ..write(obj.katrumahpemohon)
      ..writeByte(15)
      ..write(obj.buktimilikrumahpemohon)
      ..writeByte(16)
      ..write(obj.lamatinggalpemohon)
      ..writeByte(17)
      ..write(obj.dataPekerjaan);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataPemohonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
