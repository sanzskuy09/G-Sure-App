// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_pasangan_penjamin_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataPasanganPenjaminAdapter extends TypeAdapter<DataPasanganPenjamin> {
  @override
  final int typeId = 8;

  @override
  DataPasanganPenjamin read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataPasanganPenjamin(
      namapasanganpenjamin: fields[0] as String?,
      agamapasanganpenjamin: fields[1] as String?,
      warganegarapasanganpenjamin: fields[2] as String?,
      notelponpasanganpenjamin: fields[3] as String?,
      nowapasanganpenjamin: fields[4] as String?,
      pekerjaanpasanganpenjamin: fields[7] as String?,
      namaperusahaanpasanganpenjamin: fields[8] as String?,
      jabatanpasanganpenjamin: fields[9] as String?,
      ketjabatanpasanganpenjamin: fields[10] as String?,
      alamatperusahaanpasanganpenjamin: fields[11] as String?,
      kodeposperusahaanpasanganpenjamin: fields[12] as String?,
      noteleponusahapasanganpenjamin: fields[13] as String?,
      masakerjapasanganpenjamin: fields[14] as String?,
      gajipasanganpenjamin: fields[15] as Double?,
      slipgajipasanganpenjamin: fields[16] as String?,
      payrollpasanganpenjamin: fields[17] as String?,
      bidangusahapasanganpenjamin: fields[18] as String?,
      lamausahapasanganpenjamin: fields[19] as String?,
      omzetusahapasanganpenjamin: fields[20] as Double?,
      profitusahapasanganpenjamin: fields[21] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DataPasanganPenjamin obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.namapasanganpenjamin)
      ..writeByte(1)
      ..write(obj.agamapasanganpenjamin)
      ..writeByte(2)
      ..write(obj.warganegarapasanganpenjamin)
      ..writeByte(3)
      ..write(obj.notelponpasanganpenjamin)
      ..writeByte(4)
      ..write(obj.nowapasanganpenjamin)
      ..writeByte(7)
      ..write(obj.pekerjaanpasanganpenjamin)
      ..writeByte(8)
      ..write(obj.namaperusahaanpasanganpenjamin)
      ..writeByte(9)
      ..write(obj.jabatanpasanganpenjamin)
      ..writeByte(10)
      ..write(obj.ketjabatanpasanganpenjamin)
      ..writeByte(11)
      ..write(obj.alamatperusahaanpasanganpenjamin)
      ..writeByte(12)
      ..write(obj.kodeposperusahaanpasanganpenjamin)
      ..writeByte(13)
      ..write(obj.noteleponusahapasanganpenjamin)
      ..writeByte(14)
      ..write(obj.masakerjapasanganpenjamin)
      ..writeByte(15)
      ..write(obj.gajipasanganpenjamin)
      ..writeByte(16)
      ..write(obj.slipgajipasanganpenjamin)
      ..writeByte(17)
      ..write(obj.payrollpasanganpenjamin)
      ..writeByte(18)
      ..write(obj.bidangusahapasanganpenjamin)
      ..writeByte(19)
      ..write(obj.lamausahapasanganpenjamin)
      ..writeByte(20)
      ..write(obj.omzetusahapasanganpenjamin)
      ..writeByte(21)
      ..write(obj.profitusahapasanganpenjamin);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataPasanganPenjaminAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
