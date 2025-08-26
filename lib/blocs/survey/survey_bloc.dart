import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gsure/models/order_model.dart';
import 'package:gsure/models/photo_data_model.dart';
import 'package:gsure/models/survey_app_model.dart';
import 'package:gsure/services/form_processing_service.dart';
import 'package:gsure/services/survey_service.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

part 'survey_event.dart';
part 'survey_state.dart';

class SurveyBloc extends Bloc<SurveyEvent, SurveyState> {
  final SurveyService _surveyService;

  SurveyBloc(this._surveyService) : super(SurveyInitial()) {
    on<GetDataSurveyFromOrder>(_getDataSurveyFromOrder);
    on<SendSurveyData>(_sendSurveyData);
    on<UploadSurveyFiles>(_onUploadSurveyFiles);
    // on<UploadTambahanSurveyFiles>(_onUploadTambahanSurveyFiles);
  }

  Future<void> _getDataSurveyFromOrder(
    GetDataSurveyFromOrder event,
    Emitter<SurveyState> emit,
  ) async {
    emit(LoadingListDataFromOrder());

    try {
      final List<OrderModel> data =
          await _surveyService.getDataListOrder(event.username);

      final List<OrderModel> filteredData =
          data.where((item) => item.is_survey == 1).toList();

      final box = await Hive.openBox<OrderModel>('orders');
      await box.clear();

      for (var order in filteredData) {
        await box.add(order);
      }

      emit(ListDataFromOrderSuccess());
    } catch (e) {
      emit(ErrorListDataFromOrder(e.toString()));
    }
  }

  // IMPLEMENTASI HANDLER BARU
  Future<void> _sendSurveyData(
    SendSurveyData event,
    Emitter<SurveyState> emit,
  ) async {
    try {
      emit(SendingSurvey());

      final apiService = FormProcessingServiceAPI();
      final Map<String, dynamic> apiData =
          apiService.processFormToAPI(event.formAnswers);

      await _surveyService.sendSurveyData(apiData);

      emit(SendSurveySuccess(event.uniqueId));
    } catch (e) {
      emit(SendSurveyFailure(e.toString()));
    }
  }

  Future<void> _onUploadSurveyFiles(
    UploadSurveyFiles event,
    Emitter<SurveyState> emit,
  ) async {
    try {
      emit(UploadingFiles());
      final logger = Logger();

      final apiService = FormProcessingServiceAPI();

      final Map<String, String> filesToUpload =
          apiService.processImageFormToAPI(event.formAnswers);

      final Map<String, String> dokumenFilesOnly = Map.fromEntries(
        filesToUpload.entries.where((entry) => !entry.key.startsWith('dok')),
      );

      logger.i(JsonEncoder.withIndent('  ').convert(dokumenFilesOnly));

      final textData = {
        'application_id': event.uniqueId,
        'nik': event.formAnswers['nik'],
        'odometer': event.formAnswers['odometer'],
        'created_by': event.formAnswers['created_by'],
        'updated_by': event.formAnswers['created_by'],
      };
      final Map<String, dynamic> fileData = {};

      event.formAnswers.forEach((key, value) {
        // Anda perlu kriteria untuk membedakan mana data teks dan mana data file.
        // Contoh sederhana: jika kunci mengandung kata 'dok' atau 'foto', anggap itu file.
        if (key.startsWith('dok')) {
          fileData[key] = value;
        }
      });

      final Map<String, List<String>> groupedFilesToUpload =
          apiService.groupFiles(fileData);

      await _surveyService.uploadSurveyFiles(
        filesToUpload: dokumenFilesOnly,
        textData: textData,
      );

      await _surveyService.uploadTambahanSurveyFiles(
        filesToUpload: groupedFilesToUpload,
        textData: textData,
      );

      final hiveService = FormProcessingService();
      final Map<String, dynamic> hiveData =
          hiveService.processFormToNestedMap(event.formAnswers);

      hiveData['status'] = 'DONE';

      final box = Hive.box<AplikasiSurvey>('survey_apps');
      final aplikasi = AplikasiSurvey.fromJson(hiveData);
      await box.put(event.uniqueId, aplikasi);

      emit(UploadFilesSuccess());
    } catch (e) {
      emit(UploadFilesFailed(e.toString()));
    }
  }
}
