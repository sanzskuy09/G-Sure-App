// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_alamat_survey_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataAlamatSurveyAdapter extends TypeAdapter<DataAlamatSurvey> {
  @override
  final int typeId = 3;

  @override
  DataAlamatSurvey read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataAlamatSurvey(
      alamatsurvey: fields[0] as String?,
      rtsurvey: fields[1] as String?,
      rwsurvey: fields[2] as String?,
      kodepoksurvey: fields[3] as String?,
      kelsurvey: fields[4] as String?,
      kecsurvey: fields[5] as String?,
      kotasurvey: fields[6] as String?,
      provinsisurvey: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DataAlamatSurvey obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.alamatsurvey)
      ..writeByte(1)
      ..write(obj.rtsurvey)
      ..writeByte(2)
      ..write(obj.rwsurvey)
      ..writeByte(3)
      ..write(obj.kodepoksurvey)
      ..writeByte(4)
      ..write(obj.kelsurvey)
      ..writeByte(5)
      ..write(obj.kecsurvey)
      ..writeByte(6)
      ..write(obj.kotasurvey)
      ..writeByte(7)
      ..write(obj.provinsisurvey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataAlamatSurveyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
