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

// =============== Send Data Survey To API =============== //
class SendingSurvey extends SurveyState {}

class SendSurveySuccess extends SurveyState {
  final String uniqueId;
  const SendSurveySuccess(this.uniqueId);

  @override
  List<Object> get props => [uniqueId];
}

class SendSurveyFailure extends SurveyState {
  final String error;

  const SendSurveyFailure(this.error);

  @override
  List<Object> get props => [error];
}

// =============== Send Upload Image To API =============== //
class UploadingFiles extends SurveyState {} // Untuk menampilkan progress

class UploadFilesSuccess extends SurveyState {}

class UploadFilesFailed extends SurveyState {
  final String error;
  const UploadFilesFailed(this.error);
}

// =============== Send Upload Image Tambahan To API =============== //
class UploadTambahanFilesSuccess extends SurveyState {}

class UploadTambahanFilesFailed extends SurveyState {
  final String error;
  const UploadTambahanFilesFailed(this.error);
}
