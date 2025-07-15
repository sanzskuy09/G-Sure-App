import 'dart:convert';
import 'dart:io';

import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gsure/blocs/survey/survey_bloc.dart';
import 'package:gsure/models/question_model.dart';
import 'package:gsure/models/survey_app_model.dart';
import 'package:gsure/services/form_processing_service.dart';
import 'package:gsure/shared/theme.dart';
import 'package:gsure/ui/widgets/buttons.dart';
import 'package:gsure/ui/widgets/lottie_confirm_dialog.dart';
import 'package:gsure/ui/widgets/question_section.dart';
import 'package:hive_flutter/adapters.dart';

class DraftDetailPage extends StatefulWidget {
  final dynamic surveyKey;

  const DraftDetailPage({
    super.key,
    required this.surveyKey,
  });

  @override
  State<DraftDetailPage> createState() => _DraftDetailPageState();
}

class _DraftDetailPageState extends State<DraftDetailPage> {
  AplikasiSurvey? _currentSurvey;
  Map<String, dynamic> formAnswers = {};
  List<QuestionSection> _question = [];
  // List<bool> openStates = [];
  int openIndex = 0;
  DateTime? selectedDate;
  int visibleSectionCount = 1; // hanya tampilkan satu section di awal
  // bool _isFormDirty = false;

  void _showNextSection() {
    final nextCount = visibleSectionCount + 1;
    final totalVisible = _question.length;
    if (nextCount <= totalVisible) {
      setState(() {
        visibleSectionCount = nextCount;
      });
    }
  }

  Future<List<QuestionSection>> loadQuestionData() async {
    final String jsonStr =
        await rootBundle.loadString('assets/question_data1.json');
    final List<dynamic> jsonData = json.decode(jsonStr);
    return jsonData.map((e) => QuestionSection.fromJson(e)).toList();
  }

  Future<bool> _showExitConfirmDialog(BuildContext context) async {
    final bool? isConfirmed = await showLottieConfirmationDialog(
      context: context,
      title: 'Keluar dari Halaman?',
      message: 'Data yang belum disimpan akan hilang. Anda yakin ingin keluar?',
      lottieAsset: 'assets/animations/warning.json', // Ganti dengan path Anda
      confirmButtonColor: redColor,
      confirmButtonText: 'Ya, Keluar',
    );

    return isConfirmed ?? false;
  }

  void _showConfirmationDialog() {
    // 1. Lakukan pemisahan data di sini
    final Map<String, dynamic> jsonData = formAnswers;
    final Map<String, Map<String, dynamic>> fileData = {};

    final formService = FormProcessingServiceAPI();
    final Map<String, dynamic> finalForm =
        formService.processFormToAPI(formAnswers);

    // printPrettyJson(finalForm);

    finalForm.forEach((section, value) {
      print('[$section]: ${jsonEncode(value)}');
    });

    for (final entry in formAnswers.entries) {
      final key = entry.key;
      final value = entry.value;
      if (value is Map && value.containsKey('file')) {
        fileData[key] = Map<String, dynamic>.from(value);
      } else if (value != null) {
        jsonData[key] = value;
      }
    }

    // 2. Format data menjadi string JSON yang rapi untuk ditampilkan
    const encoder = JsonEncoder.withIndent('  ');
    // final String jsonString = encoder.convert(jsonData);
    final String jsonString = encoder.convert(finalForm);
    // Untuk file, kita tampilkan key dan path-nya saja agar ringkas
    final String fileString = encoder.convert(fileData.map((key, value) =>
        MapEntry(
            key, (value['file'] as File?)?.path ?? 'Path tidak ditemukan')));

    // 3. Tampilkan dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Konfirmasi Pengiriman"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Data JSON yang akan dikirim:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(jsonString,
                    style:
                        const TextStyle(fontFamily: 'monospace', fontSize: 12)),
                const SizedBox(height: 16),
                const Text("File yang akan di-upload:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(fileString,
                    style:
                        const TextStyle(fontFamily: 'monospace', fontSize: 12)),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Batal"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FilledButton(
              child: const Text("Kirim"),
              onPressed: () {
                // _saveAplikasiToHive();
                // Navigator.of(context).pop(); // Tutup dialog
                // _submitSurvey(jsonData,
                //     fileData); // Panggil fungsi submit dengan data yang sudah dipisah
              },
            ),
          ],
        );
      },
    );
  }

  void _showInputConfirmDialog() async {
    final bool? isConfirmed = await showLottieConfirmationDialog(
      context: context,
      title: 'Lanjutkan Proses?',
      message:
          'Proses akan dilanjutkan ke tahap survey lapangan. Pastikan semua data sudah benar.',
      lottieAsset: 'assets/animations/success.json', // Ganti dengan path Anda
      confirmButtonColor: successColor,
      confirmButtonText: 'Lanjutkan',
    );

    if (isConfirmed == true) {
      if (!context.mounted) return;
      _saveAplikasiToHive();
    }
  }

  void _saveAplikasiToHive() {
    try {
      final formService = FormProcessingService();

      final Map<String, dynamic> finalForm =
          formService.processFormToNestedMap(formAnswers);

      final box = Hive.box<AplikasiSurvey>('survey_apps');
      final aplikasi = AplikasiSurvey.fromJson(finalForm);
      final uniqueId = widget.surveyKey;
      box.put(uniqueId, aplikasi);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('✅ Aplikasi berhasil disimpan secara lokal!')),
      );

      Navigator.pushNamedAndRemoveUntil(context, '/list-survey', (_) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Gagal menyimpan data: $e')),
      );
    }
  }

  // HANYA MENGIRIM EVENT, TIDAK LEBIH
  void _sendAplikasiToAPI() {
    final formService = FormProcessingServiceAPI();
    final Map<String, dynamic> finalForm =
        formService.processFormToAPI(formAnswers);

    // Cukup panggil event. Biarkan BlocListener yang menangani sisanya.
    context.read<SurveyBloc>().add(
          SendSurveyData(
            uniqueId: widget.surveyKey, // <-- PASS ID DARI SINI
            surveyData: finalForm,
          ),
        );
  }

// Fungsi _showConfirmDialogSendData Anda sudah benar, tidak perlu diubah.
  void _showConfirmDialogSendData() async {
    final bool? isConfirmed = await showLottieConfirmationDialog(
      context: context,
      title: 'Lanjutkan Proses?',
      message:
          'Proses akan dilanjutkan ke tahap survey lapangan. Pastikan semua data sudah benar.',
      lottieAsset: 'assets/animations/success.json',
      confirmButtonColor: successColor,
      confirmButtonText: 'Lanjutkan',
    );

    if (isConfirmed == true) {
      if (!context.mounted) return;
      _sendAplikasiToAPI(); // Panggil fungsi yang sudah disederhanakan
    }
  }

  // 3. Buat fungsi terpisah agar initState tetap rapi.
  void _initializeFormAnswers(AplikasiSurvey survey) {
    formAnswers = survey.toFlatJson();

    // print(survey);

    // print(jsonEncode(formAnswers));
    // formAnswers = {
    //   'katpemohon': 'PERORANGAN', // Contoh nilai default
    //   // 'namadealer': survey.dataPemohon?.cabang,
    //   // 'application_id': survey.dataPemohon?.id,
    //   // 'nik': survey.dataPemohon?.nik,
    //   // 'statuspernikahan': survey.dataPemohon?.statusperkawinan,
    //   // 'nama': survey.dataPemohon?.nama,
    //   // 'namapasangan': survey.dataPemohon?.namapasangan,
    //   // 'ktppasangan': survey.dataPemohon?.nikpasangan,
    //   'isPenjaminExist': 'Ya',
    // };
  }

  @override
  void initState() {
    super.initState();
    // Load question data
    loadQuestionData().then((data) {
      setState(() {
        _question = data;
      });
    });

    // Load survey data from Hive
    final box = Hive.box<AplikasiSurvey>('survey_apps');
    _currentSurvey = box.get(widget.surveyKey);

    // Initialize form answers if survey data is available
    if (_currentSurvey != null) {
      _initializeFormAnswers(_currentSurvey!);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ambil box Hive
    final AplikasiSurvey? survey = _currentSurvey;

    if (_question.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (survey == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(
          child: Text('Data survey tidak ditemukan.'),
        ),
      );
    }

    return PopScope(
      canPop: false, // Hanya bisa pop jika form tidak kotor/berubah
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) {
          return;
        }
        final shouldPop = await _showExitConfirmDialog(context);
        if (context.mounted && shouldPop) {
          Navigator.of(context).pop();
        }
      },
      child: BlocListener<SurveyBloc, SurveyState>(
        listener: (context, state) {
          // Logika untuk bereaksi terhadap perubahan state BLoC
          if (state is SendingSurvey) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) =>
                  const Center(child: CircularProgressIndicator()),
            );
          }

          if (state is SendSurveySuccess) {
            // JIKA PENGIRIMAN API SUKSES...
            try {
              // 1. Buka box Hive
              final box = Hive.box<AplikasiSurvey>('survey_apps');

              // 2. Ambil data yang ada menggunakan ID dari state
              final surveyToUpdate = box.get(state.uniqueId);

              if (surveyToUpdate != null) {
                // 3. Buat objek baru dengan status yang sudah diubah
                final updatedSurvey = surveyToUpdate.copyWith(status: 'DONE');

                // 4. Simpan kembali objek yang sudah diupdate ke Hive
                box.put(state.uniqueId, updatedSurvey);

                print(
                    'Status survei ID: ${state.uniqueId} berhasil diupdate ke DONE');
              }
            } catch (e) {
              print('Gagal mengupdate status di Hive: $e');
            }

            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop(); // Tutup dialog loading
            }
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('✅ Data berhasil dikirim!')),
            );
            // Contoh navigasi setelah sukses
            Navigator.pushNamedAndRemoveUntil(
                context, '/list-survey', (_) => false);
          }

          if (state is SendSurveyFailure) {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop(); // Tutup dialog loading
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('❌ Gagal: ${state.error}')),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('DRAFT SURVEY'),
          ),
          body: Accordion(
            headerBackgroundColor: secondaryColor,
            headerBorderColor: secondaryColor,
            headerBorderColorOpened: Colors.transparent,
            headerBackgroundColorOpened: primaryColor,
            contentBackgroundColor: Colors.white,
            contentBorderColor: primaryColor,
            contentBorderWidth: 2,
            contentHorizontalPadding: 10,
            scaleWhenAnimating: true,
            openAndCloseAnimation: true,
            headerPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
            sectionClosingHapticFeedback: SectionHapticFeedback.light,
            children: List.generate(_question.length, (index) {
              // final actualIndex = visibleSectionIndexes[index];
              final item = _question[index];

              return AccordionSection(
                isOpen: false,
                contentVerticalPadding: 10,
                leftIcon: const Icon(
                  Icons.question_answer_outlined,
                  color: Colors.white,
                ),
                header: Text(
                  item.title,
                  style: whiteTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: semiBold,
                  ),
                ),
                content: SectionFieldContent(
                  item: item,
                  formAnswers: formAnswers,
                  onFieldChanged: () {
                    setState(() {});
                  },
                ),
              );
            }),
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 18),
              decoration: BoxDecoration(
                color: whiteColor,
                border: Border(
                  top: BorderSide(
                    color: lightBackgorundColor, // Warna border

                    width: 1.0, // Ketebalan border
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  BuildButton(
                    iconData: Icons.save_as,
                    title: "Simpan",
                    onPressed: _showInputConfirmDialog,
                  ),
                  BuildButton(
                    iconData: Icons.send,
                    title: "Kirim",
                    // onPressed: () {},
                    // isDisabled: true,
                    onPressed: _showConfirmDialogSendData,
                    // onPressed: _showConfirmationDialog,
                  ),
                  BuildButton(
                    iconData: Icons.arrow_forward_ios,
                    title: "Berikutnya",
                    isDisabled: visibleSectionCount == _question.length,
                    onPressed: _showNextSection,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
