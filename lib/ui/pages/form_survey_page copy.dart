import 'dart:convert';
import 'dart:io';

import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gsure/blocs/form/form_bloc.dart';
import 'package:gsure/models/order_model.dart';
import 'package:gsure/models/question_model.dart';
import 'package:gsure/models/survey_data.dart';
import 'package:gsure/shared/theme.dart';
import 'package:gsure/ui/widgets/buttons.dart';
import 'package:gsure/ui/widgets/form_field_builder.dart';
import 'package:gsure/ui/widgets/question_section.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';

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

// map untuk controlle
  final Map<String, TextEditingController> _controllers = {};

  bool _isLoading = false; // Untuk menampilkan loading indicator
  String _loadingMessage = "Mengirim data...";

  List<bool> openStates = [];
  bool showSecondButton = false;
  int openIndex = 0;
  DateTime? selectedDate;
  int visibleSectionCount = 1; // hanya tampilkan satu section di awal

  List<int> _calculateAllPossibleVisibleIndexes() {
    List<int> result = [];

    for (int i = 0; i < _question.length; i++) {
      final item = _question[i];
      if (item.showIf != null) {
        bool shouldShow = true;
        item.showIf!.forEach((key, allowedValues) {
          final currentValue = formAnswers[key]?.toString();

          // TAMBAHKAN INI UNTUK DEBUGGING
          // print('Checking visibility for: "${item.title}"');
          // print('--> Condition key: "$key"');
          // print('--> Current value in formAnswers: "$currentValue"');
          // print('--> Allowed values: $allowedValues');
          // print('--> Does it contain? ${allowedValues.contains(currentValue)}');
          // AKHIR DARI KODE DEBUGGING

          if (!allowedValues.contains(currentValue)) {
            shouldShow = false;
          }
        });
        if (!shouldShow) {
          print('Result: "${item.title}" will be HIDDEN.\n'); // Tambahan
          continue;
        }
      }
      print('Result: Item at index $i will be SHOWN.\n'); // Tambahan
      result.add(i);
    }
    return result;
  }

  List<int> get visibleSectionIndexes {
    final allIndexes = _calculateAllPossibleVisibleIndexes();
    return allIndexes.take(visibleSectionCount).toList();
  }

  void _showNextSection() {
    final nextCount = visibleSectionCount + 1;
    final allPossibleVisibleIndexes = _calculateAllPossibleVisibleIndexes();
    if (nextCount <= allPossibleVisibleIndexes.length) {
      setState(() {
        visibleSectionCount = nextCount;
        final newVisibleIndexes =
            allPossibleVisibleIndexes.take(visibleSectionCount).toList();

        if (newVisibleIndexes.isNotEmpty) {
          final lastVisibleIndex = newVisibleIndexes.last;
          for (int i = 0; i < openStates.length; i++) {
            openStates[i] = false;
          }
          openStates[lastVisibleIndex] = true;
        }
      });
    }
  }

  // Tambahkan fungsi ini di dalam _FormSurveyPageState
  void _showConfirmationDialog() {
    // 1. Lakukan pemisahan data di sini
    final Map<String, dynamic> jsonData = {};
    final Map<String, Map<String, dynamic>> fileData = {};

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
    final String jsonString = encoder.convert(jsonData);
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
                Navigator.of(context).pop(); // Tutup dialog
                _submitSurvey(jsonData,
                    fileData); // Panggil fungsi submit dengan data yang sudah dipisah
              },
            ),
          ],
        );
      },
    );
  }

  // Ubah signature fungsi ini
  Future<void> _submitSurvey(
    Map<String, dynamic> jsonData,
    Map<String, Map<String, dynamic>> fileData,
  ) async {
    setState(() {
      _isLoading = true;
      _loadingMessage = "Mengirim data survey...";
    });
  }

  void _saveSurveyToHive() {
    try {
      final box = Hive.box<SurveyData>('surveys');
      final surveyData = SurveyData.fromFormAnswers(formAnswers);
      box.add(surveyData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Data berhasil disimpan secara lokal!')),
      );
      print(
          'Data berhasil disimpan ke Hive. Jumlah data sekarang: ${box.length}');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Gagal menyimpan data: $e')),
      );
    }
  }

  void _updateAnswer(String fieldLabel, dynamic value) {
    context.read<FormBloc>().add(UpdateFormValue(fieldLabel, value));
  }

  void _showAnswersDialog() {
    // Pengaturan untuk membuat JSON lebih mudah dibaca (indentasi)
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    final String contentString = encoder.convert(formAnswers);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Hasil Simpan Form"),
          content: SingleChildScrollView(
            // Penting agar tidak error jika data panjang
            child: Text(contentString),
          ),
          actions: [
            TextButton(
              child: const Text("Tutup"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<List<QuestionSection>> loadQuestionData() async {
    final String jsonStr =
        await rootBundle.loadString('assets/question_data1.json');
    // final String jsonStr =
    //     await rootBundle.loadString('assets/survey_form.json');
    final List<dynamic> jsonData = json.decode(jsonStr);
    return jsonData.map((e) => QuestionSection.fromJson(e)).toList();
  }

  @override
  void initState() {
    super.initState();
    // Panggil fungsi untuk memuat data dan menginisialisasi form
    _loadAndInitializeForm();
  }

// 1. Fungsi utama yang menggabungkan pemuatan data dan inisialisasi
  Future<void> _loadAndInitializeForm() async {
    // Muat data dari JSON
    final sections = await loadQuestionData();

    // Setelah data siap, panggil fungsi untuk membuat semua controller
    _initializeAllControllers(sections);

    // Terakhir, update state untuk membangun UI
    setState(() {
      _question = sections;
      openStates = List.generate(sections.length, (i) => i == 0);
    });
  }

// 2. Fungsi untuk menginisialisasi SEMUA controller, termasuk yang nested
  void _initializeAllControllers(List<QuestionSection> sections) {
    for (var section in sections) {
      // Panggil helper rekursif untuk memproses semua field di section ini
      _processFields(section.fields);
    }
  }

// 3. Helper rekursif yang bisa "menyelam" ke dalam nested fields
  void _processFields(List<FieldModel> fields) {
    for (var field in fields) {
      // A. Buat controller untuk tipe field yang relevan
      if (field.type == 'text' ||
          field.type == 'email' ||
          field.type == 'password' ||
          field.type == 'textNoSpace' ||
          field.type == 'number' ||
          field.type == 'numberDecimal' ||
          field.type == 'date' ||
          field.type == 'textarea') {
        // Mungkin Anda punya tipe ini juga

        // Hindari membuat ulang jika sudah ada
        if (!_controllers.containsKey(field.key)) {
          final controller = TextEditingController();
          if (field.type != 'date') {
            controller.addListener(() {
              formAnswers[field.key!] = controller.text;
            });
          }
          _controllers[field.key!] = controller;
        }
      }

      // B. Jika field ini punya section bersarang, panggil fungsi ini lagi (rekursi)
      if (field.section != null && field.section!.isNotEmpty) {
        for (var subSection in field.section!) {
          // Asumsi subSection adalah Map dan punya 'fields'
          final List<dynamic> subFieldsData = subSection['fields'] ?? [];
          final List<FieldModel> subFields =
              subFieldsData.map((f) => FieldModel.fromJson(f)).toList();
          _processFields(subFields); // <- PANGGILAN REKURSIF
        }
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_question.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('FORM SURVEY ${widget.order.id}'),
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
        headerPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
        sectionClosingHapticFeedback: SectionHapticFeedback.light,
        children: List.generate(visibleSectionIndexes.length, (index) {
          final actualIndex = visibleSectionIndexes[index];
          final item = _question[actualIndex];

          print('index: $index, actualIndex: $actualIndex');

          return AccordionSection(
            isOpen: openStates[actualIndex],
            onOpenSection: () {
              setState(() {
                for (int i = 0; i < openStates.length; i++) {
                  openStates[i] = false;
                }
                openStates[actualIndex] = true;
              });
            },
            onCloseSection: () {
              setState(() {
                openStates[actualIndex] = false;
              });
            },
            contentVerticalPadding: 10,
            leftIcon: const Icon(
              Icons.question_answer_outlined,
              color: Colors.white,
            ),
            header: Text(
              item.title,
              style:
                  whiteTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
            ),
            content: SectionFieldContent(
              item: item,
              formAnswers: formAnswers,
              // controllers: _controllers,
              // onFieldChanged: () {
              //   setState(() {});
              // },
              // onUpdateAnswer: _updateAnswer,
              // onUpdateAnswer: (key, value) {
              //   context.read<FormBloc>().add(UpdateFormValue(key!, value));
              // },
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
                // onPressed: _showAnswersDialog,
                // onPressed: _saveSurveyToHive,
                onPressed: () {},
              ),
              BuildButton(
                iconData: Icons.send,
                title: "Kirim",
                isDisabled: _isLoading,
                onPressed: _showConfirmationDialog,
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
    );
  }
}

class MyNestedAccordion extends StatelessWidget //__
{
  final String title;
  final List<FieldModel> fields;
  final Map<String, TextEditingController> controllers;
  final Map<String, dynamic> formAnswers;
  final void Function(String, dynamic) onUpdateAnswer;

  const MyNestedAccordion({
    super.key,
    required this.title,
    required this.fields,
    required this.controllers,
    required this.formAnswers,
    required this.onUpdateAnswer,
  });

  @override
  Widget build(context) //__
  {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor, width: 2), // 🟥 Border merah
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🔺 Header Merah
          Container(
            decoration: BoxDecoration(
              color: primaryColor,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.maps_home_work, color: whiteColor),
                SizedBox(width: 12),
                Text(
                  title,
                  style: whiteTextStyle.copyWith(
                      fontSize: 16, fontWeight: semiBold),
                ),
              ],
            ),
          ),
          // ⬜ Konten Form Putih
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Data Field
                ...fields.map(
                  (sf) => Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 6.0, horizontal: 0),
                    child:
                        // FieldBuilder(field: sf, index: fields.indexOf(sf) + 1),
                        FieldBuilder(
                      field: sf,
                      index: fields.indexOf(sf) + 1,
                      // V-- TERUSKAN DATA & CALLBACK KE FIELD BUILDER --V
                      // controller: controllers[sf.key],
                      // value: formAnswers[sf.key],
                      // onUpdateAnswer: onUpdateAnswer,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
