import 'dart:convert';
import 'dart:io';

import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gsure/blocs/auth/auth_bloc.dart';
import 'package:gsure/blocs/survey/survey_bloc.dart';
import 'package:gsure/models/order_model.dart';
import 'package:gsure/models/question_model.dart';
import 'package:gsure/models/survey_app_model.dart';
import 'package:gsure/services/form_processing_service.dart';
import 'package:gsure/shared/theme.dart';
import 'package:gsure/ui/widgets/buttons.dart';
import 'package:gsure/ui/widgets/lottie_confirm_dialog.dart';
import 'package:gsure/ui/widgets/question_section.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:gsure/blocs/form/form_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:dio/dio.dart';

class FormSurveyPage extends StatefulWidget {
  final OrderModel order;
  const FormSurveyPage({super.key, required this.order});

  @override
  State<FormSurveyPage> createState() => _FormSurveyPageState();
}

class _FormSurveyPageState extends State<FormSurveyPage> {
  // late List<Map<String, dynamic>> _question = questionData;
  Map<String, dynamic> formAnswers = {};
  List<QuestionSection> _question = [];
  List<bool> openStates = [];
  bool showSecondButton = false;
  int openIndex = 0;
  DateTime? selectedDate;
  int visibleSectionCount = 1; // hanya tampilkan satu section di awal
  // bool _isFormDirty = false;

  // void _showNextSection() {
  //   final nextCount = visibleSectionCount + 1;
  //   final totalVisible = _question.length;
  //   if (nextCount <= totalVisible) {
  //     setState(() {
  //       visibleSectionCount = nextCount;
  //     });
  //   }
  // }

  void _showNextSection() {
    final nextCount = visibleSectionCount + 1;
    final totalVisible = _question.length;
    if (nextCount <= totalVisible) {
      setState(() {
        visibleSectionCount = nextCount;

        // Tutup semua section
        openStates = List.generate(visibleSectionCount, (_) => false);

        // Buka section terakhir yang baru ditambahkan
        final lastIndex = visibleSectionCount - 1;
        if (lastIndex >= 0) {
          openStates[lastIndex] = true;
        }
      });
    }
  }

  Future<List<QuestionSection>> loadQuestionData() async {
    final String jsonStr =
        await rootBundle.loadString('assets/question_data1.json');
    final List<dynamic> jsonData = json.decode(jsonStr);
    return jsonData.map((e) => QuestionSection.fromJson(e)).toList();
  }

  List<int> get visibleSectionIndexes {
    List<int> result = [];
    for (int i = 0; i < _question.length; i++) {
      final item = _question[i];

      if (item.showIf != null) {
        bool shouldShow = true;
        item.showIf!.forEach((key, allowedValues) {
          final currentValue = formAnswers[key]?.toString();
          if (!allowedValues.contains(currentValue)) {
            shouldShow = false;
          }
        });

        if (!shouldShow) continue;
      }
      result.add(i);
    }
    return result.take(visibleSectionCount).toList();
  }

  void printPrettyJson(Map<String, dynamic> data) {
    final logger = Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 0,
        lineLength: 99999999, // supaya tidak wrap
        colors: false,
        printEmojis: false,
      ),
    );

    final compactJson = jsonEncode(data);
    logger.i(compactJson);
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

  void _sendAplikasiToAPI() {
    // final formService = FormProcessingServiceAPI();
    // final Map<String, dynamic> finalForm =
    //     formService.processFormToAPI(formAnswers);

    // const encoder = JsonEncoder.withIndent('  ');
    // String prettyprint = encoder.convert(formAnswers);
    // print("--- ISI FINALFORM ---");
    // print(prettyprint);
    // print("---------------------");

    // Cukup panggil event. Biarkan BlocListener yang menangani sisanya.
    context.read<SurveyBloc>().add(
          SendSurveyData(
            uniqueId: '${widget.order.application_id}', // <-- PASS ID DARI SINI
            formAnswers: formAnswers,
          ),
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

  void _saveAplikasiToHive() {
    try {
      final formService = FormProcessingService();

      final Map<String, dynamic> finalForm =
          formService.processFormToNestedMap(formAnswers);

      finalForm.addAll({'status': 'DRAFT'});

      final box = Hive.box<AplikasiSurvey>('survey_apps');
      final aplikasi = AplikasiSurvey.fromJson(finalForm);
      // final uniqueId = 'app_${DateTime.now().millisecondsSinceEpoch}';
      final uniqueId = '${widget.order.application_id}';
      box.put(uniqueId, aplikasi);

      // print('Data survey berhasil disimpan ke Hive dengan key: $uniqueId.');

      // --- LOGIKA BARU UNTUK UPDATE ORDER ---
      // 2. Buka box tempat OrderModel disimpan
      // final orderBox = Hive.box<OrderModel>('orders');
      // order.isActived = false;
      // orderBox.put(order.id, order);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('✅ Aplikasi berhasil disimpan secara lokal!')),
      );

      Navigator.pushNamedAndRemoveUntil(context, '/list-survey', (_) => false);
      // print(
      //     'Data berhasil disimpan ke Hive dengan key: $uniqueId. Jumlah data: ${box.length}');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Gagal menyimpan data: $e')),
      );
    }
  }

  void _showInputConfirmDialog() async {
    final bool? isConfirmed = await showLottieConfirmationDialog(
      context: context,
      title: 'Lanjutkan Proses?',
      message:
          'Proses akan disimpan di data lokal. Pastikan semua data sudah benar.',
      lottieAsset: 'assets/animations/success.json', // Ganti dengan path Anda
      confirmButtonColor: successColor,
      confirmButtonText: 'Lanjutkan',
    );

    if (isConfirmed == true) {
      if (!context.mounted) return;
      _saveAplikasiToHive();
    }
  }

// Fungsi untuk menampilkan dialog konfirmasi
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

  // 3. Buat fungsi terpisah agar initState tetap rapi.
  void _initializeFormAnswers() {
    final order = widget.order;

    formAnswers = order.toJson();

// ✅ 1. AMBIL STATE DARI AUTHBLOC
    // `context.read<T>()` digunakan untuk membaca state sekali saja tanpa me-rebuild widget
    final authState = context.read<AuthBloc>().state;

    // ✅ 2. CEK JIKA LOGIN BERHASIL DAN AMBIL USERNAME
    if (authState is AuthSuccess) {
      // Ambil username dari user yang sedang login dan tambahkan ke map
      formAnswers['created_by'] = authState.user.username;
      formAnswers['updated_by'] = authState.user.username;
    } else {
      // Fallback jika karena suatu alasan user tidak ditemukan di state
      formAnswers['created_by'] = 'unknown_user';
      formAnswers['updated_by'] = 'unknown_user';
    }

    formAnswers['nik'] = order.nik;

    // formAnswers = {
    //   'application_id': order.application_id,
    //   'katpemohon': 'PERORANGAN', // Contoh nilai default
    //   'namadealer': order.cabang,
    //   'nik': order.nik,
    //   'statuspernikahan': order.statusperkawinan,
    //   'nama': order.nama,
    //   'namapasangan': order.namapasangan,
    //   'ktppasangan': order.nikpasangan,
    //   'isPenjaminExist': 'Ya',
    // };
  }

  @override
  void initState() {
    super.initState();
    loadQuestionData().then((data) {
      setState(() {
        _question = data;
        openStates = List<bool>.filled(data.length, false);

        // openStates =
        //     List.generate(data.length, (i) => i == 0); // buka yang pertama
      });
    });
    _initializeFormAnswers();
  }

  // @override
  // void dispose() {
  //  for (var section in _question) {
  //   for (var field in section['fields']) {
  //    if (field['controller'] is TextEditingController) {
  //     field['controller'].dispose();
  //    }
  //   }
  //  }
  // }

  @override
  Widget build(BuildContext context) {
    if (_question.isEmpty) {
      return const Center(child: CircularProgressIndicator());
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
          // ✅ TAMPILKAN SNACKBAR JIKA SUKSES
          // if (state is SendSurveySuccess) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     const SnackBar(
          //       content: Text('✅ Data berhasil dikirim ke server!'),
          //       backgroundColor: Colors.green,
          //     ),
          //   );
          //   // Pindah halaman setelah notifikasi muncul
          //   Navigator.pushNamedAndRemoveUntil(
          //       context, '/list-survey', (_) => false);
          // }

          // // ✅ TAMPILKAN SNACKBAR JIKA GAGAL

          if (state is SendingSurvey || state is UploadingFiles) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) =>
                  const Center(child: CircularProgressIndicator()),
            );
          }

          if (state is SendSurveyFailure) {
            Navigator.pop(context);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                // content: Text('❌ Gagal mengirim data: ${state.error}'),
                content: Text(
                    '❌ Gagal mengirim data: Data ini sudah pernah dikirim'),
                backgroundColor: Colors.red.shade300,
              ),
            );

            // context.read<SurveyBloc>().add(
            //       UploadSurveyFiles(
            //         uniqueId: '${widget.order.application_id}',
            //         formAnswers: formAnswers, // Kirim lagi formAnswers
            //       ),
            //     );
          }

          // Langkah 1: Metadata sukses
          if (state is SendSurveySuccess) {
            Navigator.pop(context);

            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                    '✅ Data form berhasil dikirim. Memulai upload file...')));
            // Langkah 2: Langsung picu event upload file
            context.read<SurveyBloc>().add(UploadSurveyFiles(
                  uniqueId: state.uniqueId,
                  formAnswers: formAnswers, // Kirim lagi formAnswers
                ));
          }

          // Hasil akhir dari upload file
          if (state is UploadFilesSuccess) {
            Navigator.pop(context);

            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('🎉 Semua file berhasil diunggah!'),
                backgroundColor: Colors.green));

            Navigator.pushNamedAndRemoveUntil(
                context, '/list-survey', (_) => false);
          }

          if (state is UploadFilesFailed) {
            Navigator.pop(context);

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('❌ Gagal upload file: ${state.error}'),
                backgroundColor: Colors.red));
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('FORM SURVEY'),
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
            children: List.generate(visibleSectionIndexes.length, (index) {
              final actualIndex = visibleSectionIndexes[index];
              final item = _question[actualIndex];

              return AccordionSection(
                // isOpen: index == visibleSectionIndexes.length - 1,
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
                    // onPressed: _showConfirmationDialog,
                    onPressed: _showInputConfirmDialog,
                  ),
                  BuildButton(
                    iconData: Icons.send,
                    title: "Kirim",
                    // isDisabled: true,
                    // onPressed: () {},
                    onPressed: _showInputConfirmDialogToAPI,
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
