part of 'survey_bloc.dart';

sealed class SurveyEvent extends Equatable {
  const SurveyEvent();

  @override
  List<Object> get props => [];
}

class GetDataSurveyFromOrder extends SurveyEvent {
  final String username;

  const GetDataSurveyFromOrder(this.username);

  @override
  List<Object> get props => [username];
}

// EVENT BARU
// class SendSurveyData extends SurveyEvent {
//   final String uniqueId; // <-- TAMBAHKAN INI
//   final Map<String, dynamic> surveyData;

//   const SendSurveyData({
//     required this.uniqueId, // <-- TAMBAHKAN INI
//     required this.surveyData,
//   });

//   @override
//   List<Object> get props => [uniqueId, surveyData];
// }
class SendSurveyData extends SurveyEvent {
  final String uniqueId;
  // ✅ UBAH INI: Kirim formAnswers yang belum diproses
  final Map<String, dynamic> formAnswers;

  const SendSurveyData({
    required this.uniqueId,
    required this.formAnswers, // <-- Ubah di sini
  });

  @override
  List<Object> get props => [uniqueId, formAnswers];
}
