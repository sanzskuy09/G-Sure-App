// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_penjamin_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataPenjaminAdapter extends TypeAdapter<DataPenjamin> {
  @override
  final int typeId = 7;

  @override
  DataPenjamin read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataPenjamin(
      jnspenjamin: fields[0] as String?,
      statuspernikahanpenjamin: fields[1] as String?,
      namapenjamin: fields[2] as String?,
      agamapenjamin: fields[3] as String?,
      warganegarapenjamin: fields[4] as String?,
      notelppenjamin: fields[5] as String?,
      nowapenjamin: fields[6] as String?,
      ktppenjamin: fields[7] as String?,
      tglktppenjamin: fields[8] as String?,
      simpenjamin: fields[9] as String?,
      npwppenjamin: fields[10] as String?,
      alamatpenjamin: fields[11] as String?,
      kotapenjamin: fields[12] as String?,
      namaibupenjamin: fields[13] as String?,
      statusrumahpenjamin: fields[14] as String?,
      lokasirumahpenjamin: fields[15] as String?,
      katrumahpenjamin: fields[16] as String?,
      buktimilikrumahpenjamin: fields[17] as String?,
      lamatinggalpenjamin: fields[18] as String?,
      dataPekerjaanPenjamin: fields[19] as DataPekerjaanPenjamin?,
    );
  }

  @override
  void write(BinaryWriter writer, DataPenjamin obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.jnspenjamin)
      ..writeByte(1)
      ..write(obj.statuspernikahanpenjamin)
      ..writeByte(2)
      ..write(obj.namapenjamin)
      ..writeByte(3)
      ..write(obj.agamapenjamin)
      ..writeByte(4)
      ..write(obj.warganegarapenjamin)
      ..writeByte(5)
      ..write(obj.notelppenjamin)
      ..writeByte(6)
      ..write(obj.nowapenjamin)
      ..writeByte(7)
      ..write(obj.ktppenjamin)
      ..writeByte(8)
      ..write(obj.tglktppenjamin)
      ..writeByte(9)
      ..write(obj.simpenjamin)
      ..writeByte(10)
      ..write(obj.npwppenjamin)
      ..writeByte(11)
      ..write(obj.alamatpenjamin)
      ..writeByte(12)
      ..write(obj.kotapenjamin)
      ..writeByte(13)
      ..write(obj.namaibupenjamin)
      ..writeByte(14)
      ..write(obj.statusrumahpenjamin)
      ..writeByte(15)
      ..write(obj.lokasirumahpenjamin)
      ..writeByte(16)
      ..write(obj.katrumahpenjamin)
      ..writeByte(17)
      ..write(obj.buktimilikrumahpenjamin)
      ..writeByte(18)
      ..write(obj.lamatinggalpenjamin)
      ..writeByte(19)
      ..write(obj.dataPekerjaanPenjamin);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataPenjaminAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
