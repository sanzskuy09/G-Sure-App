// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'survey_app_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AplikasiSurveyAdapter extends TypeAdapter<AplikasiSurvey> {
  @override
  final int typeId = 0;

  @override
  AplikasiSurvey read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AplikasiSurvey(
      id: fields[0] as String?,
      dataDealer: fields[1] as DataDealer?,
      dataKendaraan: fields[2] as DataKendaraan?,
      dataAlamatSurvey: fields[3] as DataAlamatSurvey?,
      dataPemohon: fields[4] as DataPemohon?,
      dataPasangan: fields[5] as DataPasangan?,
      dataKontakDarurat: fields[6] as DataKontakDarurat?,
      isPenjaminExist: fields[7] as String?,
      dataPenjamin: fields[8] as DataPenjamin?,
      dataPasanganPenjamin: fields[9] as DataPasanganPenjamin?,
      analisacmo: fields[10] as String?,
      fotoKendaraan: fields[11] as FotoKendaraan?,
      fotoLegalitas: fields[12] as FotoLegalitas?,
      fotoTempatTinggal: fields[13] as FotoTempatTinggal?,
      fotoPekerjaan: (fields[14] as List?)?.cast<PhotoData>(),
      fotoSimulasi: (fields[15] as List?)?.cast<PhotoData>(),
      fotoTambahan: (fields[16] as List?)?.cast<PhotoData>(),
    )
      ..status = fields[17] as String?
      ..updatedAt = fields[18] as String?;
  }

  @override
  void write(BinaryWriter writer, AplikasiSurvey obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.dataDealer)
      ..writeByte(2)
      ..write(obj.dataKendaraan)
      ..writeByte(3)
      ..write(obj.dataAlamatSurvey)
      ..writeByte(4)
      ..write(obj.dataPemohon)
      ..writeByte(5)
      ..write(obj.dataPasangan)
      ..writeByte(6)
      ..write(obj.dataKontakDarurat)
      ..writeByte(7)
      ..write(obj.isPenjaminExist)
      ..writeByte(8)
      ..write(obj.dataPenjamin)
      ..writeByte(9)
      ..write(obj.dataPasanganPenjamin)
      ..writeByte(10)
      ..write(obj.analisacmo)
      ..writeByte(11)
      ..write(obj.fotoKendaraan)
      ..writeByte(12)
      ..write(obj.fotoLegalitas)
      ..writeByte(13)
      ..write(obj.fotoTempatTinggal)
      ..writeByte(14)
      ..write(obj.fotoPekerjaan)
      ..writeByte(15)
      ..write(obj.fotoSimulasi)
      ..writeByte(16)
      ..write(obj.fotoTambahan)
      ..writeByte(17)
      ..write(obj.status)
      ..writeByte(18)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AplikasiSurveyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
