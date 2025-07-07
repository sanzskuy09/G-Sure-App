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
  List<bool> openStates = [];
  bool showSecondButton = false;
  int openIndex = 0;
  DateTime? selectedDate;
  int visibleSectionCount = 1; // hanya tampilkan satu section di awal

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
    loadQuestionData().then((data) {
      setState(() {
        _question = data;
        openStates =
            List.generate(data.length, (i) => i == 0); // buka yang pertama
      });
    });
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

    return Scaffold(
      appBar: AppBar(
        title: Text('FORM SURVEY ASSET ${widget.order.id}'),
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

          return AccordionSection(
            isOpen: index == visibleSectionIndexes.length - 1,
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
                onPressed: _showConfirmationDialog,
              ),
              BuildButton(
                iconData: Icons.send,
                title: "Kirim",
                isDisabled: true,
                onPressed: () {},
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
