import 'dart:convert';
import 'dart:io';

import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gsure/blocs/auth/auth_bloc.dart';
import 'package:gsure/blocs/survey/survey_bloc.dart';
import 'package:gsure/models/question_model.dart';
import 'package:gsure/models/survey_app_model.dart';
import 'package:gsure/services/form_processing_service.dart';
import 'package:gsure/shared/theme.dart';
import 'package:gsure/ui/pages/loading_lottie_page.dart';
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
  List<bool> openStates = [];
  int openIndex = 0;
  DateTime? selectedDate;
  int visibleSectionCount = 1;
  // bool _isFormDirty = false;

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
      lottieAsset: 'assets/animations/warning.json',
      confirmButtonColor: redColor,
      confirmButtonText: 'Ya, Keluar',
    );

    return isConfirmed ?? false;
  }

  Future<bool> _showAlertDialog(BuildContext context) async {
    final bool? isConfirmed = await showLottieConfirmationDialog(
      context: context,
      title: 'Peringatan?',
      message:
          'Data ini sudah dikirim dan tidak dapat diedit kembali. silahkan hubungi admin.',
      lottieAsset: 'assets/animations/warning.json',
      confirmButtonColor: redColor,
      confirmButtonText: 'Ya, paham',
    );

    return isConfirmed ?? false;
  }

  void _showInputConfirmDialog() async {
    final bool? isConfirmed = await showLottieConfirmationDialog(
      context: context,
      title: 'Simpan Kembali Proses?',
      message:
          'Data akan disimpan di data lokal kemabli. Pastikan semua data sudah benar.',
      lottieAsset: 'assets/animations/success.json',
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

      finalForm.addAll({'status': 'DRAFT'});

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

  void _sendAplikasiToAPI() {
    context.read<SurveyBloc>().add(
          SendSurveyData(
            uniqueId: '${widget.surveyKey}', // <-- PASS ID DARI SINI
            formAnswers: formAnswers,
          ),
        );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoadingLottiePage()),
    );
  }

  void _showInputConfirmDialogToAPI() async {
    final bool? isConfirmed = await showLottieConfirmationDialog(
      context: context,
      title: 'Kirim Data?',
      message:
          'Proses akan dikirim dan tidak bisa dikembalikan. Pastikan semua data sudah benar.',
      lottieAsset: 'assets/animations/success.json', // Ganti dengan path Anda
      confirmButtonColor: successColor,
      confirmButtonText: 'Lanjutkan',
    );

    if (isConfirmed == true) {
      if (!context.mounted) return;
      _sendAplikasiToAPI();
    }
  }

  void _initializeFormAnswers(AplikasiSurvey survey) {
    formAnswers = survey.toFlatJson();

    final authState = context.read<AuthBloc>().state;

    if (authState is AuthSuccess) {
      formAnswers['created_by'] = authState.user.username;
      formAnswers['updated_by'] = authState.user.username;
    } else {
      formAnswers['created_by'] = 'unknown_user';
      formAnswers['updated_by'] = 'unknown_user';
    }

    formAnswers['nik'] = _currentSurvey?.nik;

    print('scoreliveness: ${_currentSurvey?.dataPemohon?.scoreliveness}');
  }

  void _showConfirmationDialog() {
    // 1. Lakukan pemisahan data di sini
    final Map<String, dynamic> jsonData = {};
    final Map<String, Map<String, dynamic>> fileData = {};

    // final formService = FormProcessingServiceAPI();
    // final Map<String, dynamic> finalForm =
    //     formService.processFormToAPI(formAnswers);

    // // printPrettyJson(finalForm);

    // finalForm.forEach((section, value) {
    //   print('[$section]: ${jsonEncode(value)}');
    // });

    final formService = FormProcessingService();

    final Map<String, dynamic> finalForm =
        formService.processFormToNestedMap(formAnswers);

    // ✅ TAMBAHKAN BLOK INI UNTUK MELIHAT ISI FINALFORM
    // JsonEncoder encoder =
    //     JsonEncoder.withIndent('  '); // '  ' untuk 2 spasi indentasi

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

    // String prettyprint = encoder.convert(finalForm);
    // print("--- ISI FINALFORM ---");
    // print(prettyprint);
    // print("---------------------");
    // ==========================================================

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
                // Text(fileString,
                //     style:
                //         const TextStyle(fontFamily: 'monospace', fontSize: 12)),
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
                // _sendAplikasiToAPI();
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

  @override
  void initState() {
    super.initState();
    // Load question data
    loadQuestionData().then((data) {
      setState(() {
        _question = data;
        openStates = List<bool>.filled(data.length, false);
      });
    });

    final box = Hive.box<AplikasiSurvey>('survey_apps');
    _currentSurvey = box.get(widget.surveyKey);

    if (_currentSurvey != null) {
      _initializeFormAnswers(_currentSurvey!);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _currentSurvey?.status == 'DONE') {
        _showAlertDialog(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
      canPop: false,
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
          if (state is SendSurveyFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    '❌ Gagal mengirim data: Data ini sudah pernah dikirim'),
                backgroundColor: Colors.red.shade300,
              ),
            );
          }

          if (state is UploadFilesFailed) {
            Navigator.pop(context);

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('❌ Gagal upload file: ${state.error}'),
                backgroundColor: Colors.red));
          }

          if (state is SendSurveySuccess) {
            context.read<SurveyBloc>().add(
                  UploadSurveyFiles(
                    uniqueId: state.uniqueId,
                    formAnswers: formAnswers,
                  ),
                );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('DRAFT ID : ${widget.surveyKey}'),
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
                isOpen: openStates[index],
                onOpenSection: () {
                  setState(() {
                    openStates[index] = true;
                    for (int i = 0; i < openStates.length; i++) {
                      if (i != index) {
                        openStates[i] = false;
                      }
                    }
                  });
                },
                onCloseSection: () {
                  setState(() {
                    openStates[index] = false;
                  });
                },
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
                    setState(() {
                      openStates[index] = true;
                    });
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
                    // onPressed: _showInputConfirmDialog,
                    isDisabled: _currentSurvey?.status == 'DONE' ?? true,
                    onPressed: _currentSurvey?.status == 'DONE'
                        ? () {}
                        : _showInputConfirmDialog,
                    // : _showConfirmationDialog,
                  ),
                  BuildButton(
                    iconData: Icons.send,
                    title: "Kirim",
                    isDisabled: _currentSurvey?.status == 'DONE' ?? true,
                    onPressed: _currentSurvey?.status == 'DONE'
                        ? () {}
                        : _showInputConfirmDialogToAPI,
                  ),
                  BuildButton(
                    iconData: Icons.arrow_forward_ios,
                    title: "Berikutnya",
                    // isDisabled: visibleSectionCount == _question.length,
                    // onPressed: _showNextSection,
                    // isDisabled: _currentSurvey?.status == 'DONE' ?? true,
                    // onPressed: _currentSurvey?.status == 'DONE'
                    //     ? () {}
                    //     : _showNextSection,
                    isDisabled: true,
                    onPressed: () {},
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
