part of 'survey_bloc.dart';

sealed class SurveyEvent extends Equatable {
  const SurveyEvent();

  @override
  List<Object> get props => [];
}

class GetDataSurveyFromOrder extends SurveyEvent {}

// EVENT BARU
class SendSurveyData extends SurveyEvent {
  final String uniqueId; // <-- TAMBAHKAN INI
  final Map<String, dynamic> surveyData;

  const SendSurveyData({
    required this.uniqueId, // <-- TAMBAHKAN INI
    required this.surveyData,
  });

  @override
  List<Object> get props => [uniqueId, surveyData];
}
