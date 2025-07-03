// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'survey_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SurveyDataAdapter extends TypeAdapter<SurveyData> {
  @override
  final int typeId = 2;

  @override
  SurveyData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SurveyData()
      ..kddealer = fields[0] as String?
      ..statuspernikahan = fields[1] as String?
      ..pekerjaan = fields[2] as String?
      ..nama = fields[3] as String?
      ..hargakendaraan = fields[4] as String?
      ..rt = fields[5] as String?
      ..rw = fields[6] as String?
      ..kodepos = fields[7] as String?
      ..odometer = fields[8] as String?
      ..fotounitdepanPath = fields[9] as String?
      ..fotostnkPath = fields[10] as String?
      ..namapasangan = fields[11] as String?
      ..isPenjamin = fields[12] as String?
      ..telppenjamin = fields[13] as String?
      ..dokumen1Path = fields[14] as String?;
  }

  @override
  void write(BinaryWriter writer, SurveyData obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.kddealer)
      ..writeByte(1)
      ..write(obj.statuspernikahan)
      ..writeByte(2)
      ..write(obj.pekerjaan)
      ..writeByte(3)
      ..write(obj.nama)
      ..writeByte(4)
      ..write(obj.hargakendaraan)
      ..writeByte(5)
      ..write(obj.rt)
      ..writeByte(6)
      ..write(obj.rw)
      ..writeByte(7)
      ..write(obj.kodepos)
      ..writeByte(8)
      ..write(obj.odometer)
      ..writeByte(9)
      ..write(obj.fotounitdepanPath)
      ..writeByte(10)
      ..write(obj.fotostnkPath)
      ..writeByte(11)
      ..write(obj.namapasangan)
      ..writeByte(12)
      ..write(obj.isPenjamin)
      ..writeByte(13)
      ..write(obj.telppenjamin)
      ..writeByte(14)
      ..write(obj.dokumen1Path);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SurveyDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
