import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gsure/models/order_model.dart';
import 'package:gsure/models/survey_app_model.dart';
import 'package:gsure/services/form_processing_service.dart';
import 'package:gsure/services/survey_service.dart';
import 'package:hive/hive.dart';

part 'survey_event.dart';
part 'survey_state.dart';

class SurveyBloc extends Bloc<SurveyEvent, SurveyState> {
  final SurveyService _surveyService;

  SurveyBloc(this._surveyService) : super(SurveyInitial()) {
    on<GetDataSurveyFromOrder>(_getDataSurveyFromOrder);
    on<SendSurveyData>(_sendSurveyData);
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
      emit(SendingSurvey()); // Tampilkan loading

      // --- PROSES UNTUK API ---
      // 1. Masak data menggunakan resep API
      final apiService = FormProcessingServiceAPI();
      final Map<String, dynamic> apiData =
          apiService.processFormToAPI(event.formAnswers);

      // 2. Kirim data ke API
      await _surveyService.sendSurveyData(apiData);

      // --- PROSES UNTUK HIVE (HANYA JIKA API SUKSES) ---
      // 3. Masak data LAGI menggunakan resep Hive
      final hiveService = FormProcessingService();
      final Map<String, dynamic> hiveData =
          hiveService.processFormToNestedMap(event.formAnswers);

      // 4. Ubah status menjadi 'DONE'
      hiveData['status'] = 'DONE';

      // 5. Simpan data yang sudah sesuai format Hive
      final box = Hive.box<AplikasiSurvey>('survey_apps');
      final aplikasi = AplikasiSurvey.fromJson(hiveData);
      await box.put(event.uniqueId, aplikasi);

      // 6. Emit state sukses
      emit(SendSurveySuccess(event.uniqueId));
    } catch (e) {
      emit(SendSurveyFailure(e.toString()));
    }
  }
  // Future<void> _sendSurveyData(
  //   SendSurveyData event,
  //   Emitter<SurveyState> emit,
  // ) async {
  //   emit(SendingSurvey()); // 1. Emit state loading
  //   try {
  //     // 2. Panggil service untuk mengirim data
  //     await _surveyService.sendSurveyData(event.surveyData);
  //     emit(SendSurveySuccess(event.uniqueId)); // 3. Emit state sukses
  //   } catch (e) {
  //     emit(
  //       SendSurveyFailure(e.toString()),
  //     ); // 4. Emit state gagal jika ada error
  //   }
  // }
}
