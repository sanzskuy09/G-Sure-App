part of 'survey_bloc.dart';

sealed class SurveyState extends Equatable {
  const SurveyState();

  @override
  List<Object> get props => [];
}

final class SurveyInitial extends SurveyState {}

// =============== Get Data Survey From Order =============== //
class ListDataFromOrderSuccess extends SurveyState {}

class LoadingListDataFromOrder extends SurveyState {}

class ErrorListDataFromOrder extends SurveyState {
  final String message;
  const ErrorListDataFromOrder(this.message);
  @override
  List<Object> get props => [message];
}
