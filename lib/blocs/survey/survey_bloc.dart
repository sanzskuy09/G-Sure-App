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
      emit(SendingSurvey()); // Tampilkan loading

      // --- PROSES UNTUK API ---
      // 1. Masak data menggunakan resep API
      final apiService = FormProcessingServiceAPI();
      final Map<String, dynamic> apiData =
          apiService.processFormToAPI(event.formAnswers);

      // // 2. Kirim data ke API
      await _surveyService.sendSurveyData(apiData);

      // --- PROSES UNTUK HIVE (HANYA JIKA API SUKSES) ---
      // 3. Masak data LAGI menggunakan resep Hive
      // final hiveService = FormProcessingService();
      // final Map<String, dynamic> hiveData =
      //     hiveService.processFormToNestedMap(event.formAnswers);

      // // 4. Ubah status menjadi 'DONE'
      // hiveData['status'] = 'DONE';

      // // 5. Simpan data yang sudah sesuai format Hive
      // final box = Hive.box<AplikasiSurvey>('survey_apps');
      // final aplikasi = AplikasiSurvey.fromJson(hiveData);
      // await box.put(event.uniqueId, aplikasi);

      // 6. Emit state sukses
      emit(SendSurveySuccess(event.uniqueId));
    } catch (e) {
      emit(SendSurveyFailure(e.toString()));
    }
  }

// Di dalam SurveyBloc
  Future<void> _onUploadSurveyFiles(
    UploadSurveyFiles event,
    Emitter<SurveyState> emit,
  ) async {
    try {
      emit(UploadingFiles()); // State untuk progress bar
      final logger = Logger();

      final apiService = FormProcessingServiceAPI();

      // 1. Dapatkan daftar file (Map<String, String>)
      final Map<String, String> filesToUpload =
          apiService.processImageFormToAPI(event.formAnswers);

      // 2. Dapatkan daftar tambahan file

      // logger.i(JsonEncoder.withIndent('  ').convert(filesToUpload));
      // print(filesToUpload);

      // 2. Siapkan data teks
      final textData = {
        'application_id': event.uniqueId,
        'nik': event.formAnswers['nik'],
        'odometer': event.formAnswers['odometer'],
        'created_by': event.formAnswers['created_by'],
        'updated_by': event.formAnswers['created_by'],
        // Tambahkan field teks lain yang dibutuhkan API di sini
      };
      final Map<String, dynamic> fileData = {};

      // 2. Pisahkan data dari event.formAnswers
      event.formAnswers.forEach((key, value) {
        // Anda perlu kriteria untuk membedakan mana data teks dan mana data file.
        // Contoh sederhana: jika kunci mengandung kata 'dok' atau 'foto', anggap itu file.
        if (key.startsWith('dok')) {
          fileData[key] = value;
        }
      });

      // 3. Panggil groupFiles HANYA dengan data file
      final Map<String, List<String>> groupedFilesToUpload =
          apiService.groupFiles(fileData);

      // logger.i(JsonEncoder.withIndent('  ').convert(fileData));
      // print(fileData);
      // logger.i(JsonEncoder.withIndent('  ').convert(groupedFilesToUpload));
      // 4. Sekarang data Anda sudah benar dan siap dikirim

      // --- TAMBAHKAN DEBUG PRINT DI SINI ---
      print("🔍 DATA TEKS YANG AKAN DIKIRIM:");
      print(event.formAnswers);
      print(textData);
// ------------------------------------

      await _surveyService.uploadSurveyFiles(
        filesToUpload: filesToUpload,
        textData: textData,
      );

      await _surveyService.uploadTambahanSurveyFiles(
        filesToUpload: groupedFilesToUpload,
        textData: textData,
      );

      // logger.i(JsonEncoder.withIndent('  ').convert(filesToUpload));
      // 3. Panggil service yang mengirim file aktual

      // final filesTambahanToUpload = apiService.groupFiles(event.formAnswers);

      // 3. Setelah semua file berhasil, update data di Hive dengan status DONE
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

  // Future<void> _onUploadTambahanSurveyFiles(
  //   UploadTambahanSurveyFiles event,
  //   Emitter<SurveyState> emit,
  // ) async {
  //   try {
  //     emit(UploadingFiles()); // State untuk progress bar
  //     final logger = Logger();

  //     final apiService = FormProcessingServiceAPI();
  //     // final Map<String, dynamic> apiData =
  //     //     apiService.processImageFormToAPI(event.formAnswers);
  //     // print(event.formAnswers);

  //     logger.i(JsonEncoder.withIndent('  ').convert(event.formAnswers));

  //     // 1. Dapatkan daftar file (Map<String, String>)
  //     final Map<String, String> filesToUpload =
  //         apiService.processImageFormToAPI(event.formAnswers);

  //     // 2. Siapkan data teks
  //     final textData = {
  //       'application_id': event.uniqueId,
  //       'nik': event.formAnswers['nik'],
  //       'odometer': event.formAnswers['odometer'],
  //       'created_by': event.formAnswers['created_by'],
  //       'updated_by': event.formAnswers['created_by'],
  //       // Tambahkan field teks lain yang dibutuhkan API di sini
  //     };

  //     // logger.i(JsonEncoder.withIndent('  ').convert(filesToUpload));
  //     // 3. Panggil service yang mengirim file aktual
  //     await _surveyService.uploadSurveyFiles(
  //       filesToUpload: filesToUpload,
  //       textData: textData,
  //     );

  //     // 3. Setelah semua file berhasil, update data di Hive dengan status DONE
  //     final hiveService = FormProcessingService();
  //     final Map<String, dynamic> hiveData =
  //         hiveService.processFormToNestedMap(event.formAnswers);

  //     hiveData['status'] = 'DONE';

  //     final box = Hive.box<AplikasiSurvey>('survey_apps');
  //     final aplikasi = AplikasiSurvey.fromJson(hiveData);
  //     await box.put(event.uniqueId, aplikasi);

  //     emit(UploadFilesSuccess());
  //   } catch (e) {
  //     emit(UploadFilesFailed(e.toString()));
  //   }
  // }

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
