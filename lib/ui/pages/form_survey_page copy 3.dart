import 'dart:convert';

import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gsure/models/question_model.dart';
import 'package:gsure/shared/theme.dart';
import 'package:gsure/ui/widgets/buttons.dart';
import 'package:gsure/ui/widgets/form_field_builder.dart';

class FormSurveyPage extends StatefulWidget {
  const FormSurveyPage({super.key});

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

    // if (formAnswers["Apakah Ada Penjamin ?"] == null) {
    //   return;
    // }

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
      if (item.title == "Data Penjamin") {
        final answer = formAnswers["Apakah Ada Penjamin ?"];
        if (answer != "Ya") continue; // skip jika bukan "Ya"
      }
      result.add(i);
    }
    return result.take(visibleSectionCount).toList();
  }

  @override
  void initState() {
    super.initState();
    // _question = questionData; // gunakan data dari file terpisah
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
  //   for (var section in _question) {
  //     for (var field in section['fields']) {
  //       if (field['controller'] is TextEditingController) {
  //         field['controller'].dispose();
  //       }
  //     }
  //   }
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    if (_question.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('FORM SURVEY'),
      ),
      // body: AccordionPage(),
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
              style:
                  whiteTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
            ),
            content: Column(
              children: [
                ...List.generate(item.fields.length, (fIdx) {
                  final field = item.fields[fIdx];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        // child: buildFieldBuilder(field, context, fIdx + 1),
                        child: FieldBuilder(
                          field: field,
                          index: fIdx + 1,
                          setState: setState,
                          formAnswers: formAnswers,
                        ),
                      ),

                      // ✅ Tampilkan sub-section jika field punya "section"
                      if (field.section != null && field.value != null)
                        ...field.section!
                            .where((sub) => (sub['show'] as List)
                                .contains(field.value.toString()))
                            .expand((sub) {
                          final subFields = (sub['fields'] as List)
                              .map((f) => FieldModel.fromJson(f))
                              .toList();

                          return [
                            const SizedBox(height: 8),
                            MyNestedAccordion(
                              title: sub['title'],
                              fields: subFields,
                            ),
                          ];
                        }),
                    ],
                  );
                }),

                // tambahkan tombol "Tambah Dokumen"
                if (item.title == "Foto & Dokumen Pekerjaan / Usaha" ||
                    item.title == "Foto & Dokumen Simulasi Perhitungan" ||
                    item.title == "Foto & Dokumen Tambahan")
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        final cameraFieldCount = item.fields
                            .where((f) => f.type == "cameraAndUpload")
                            .length;

                        setState(() {
                          item.fields.add(FieldModel(
                            type: "cameraAndUpload",
                            label: "Foto & Dokumen ${cameraFieldCount + 1}",
                          ));
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.add, size: 16),
                          SizedBox(width: 4),
                          Text("Tambah Dokumen"),
                        ],
                      ),
                    ),
                  ),
              ],
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
                onPressed: () {},
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

class MyNestedAccordion extends StatelessWidget //__
{
  final String title;
  final List<FieldModel> fields;

  const MyNestedAccordion({
    super.key,
    required this.title,
    required this.fields,
  });

  @override
  Widget build(context) //__
  {
    return Accordion(
      paddingListTop: 0,
      paddingListBottom: 0,
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
      children: [
        AccordionSection(
          isOpen: true,
          contentVerticalPadding: 10,
          leftIcon: const Icon(
            Icons.question_answer_outlined,
            color: Colors.white,
          ),
          header: Text(
            title,
            style: whiteTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Data Field
              ...fields.map(
                (sf) => Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6.0, horizontal: 0),
                  // child: buildFieldBuilder(sf, context, fields.indexOf(sf) + 1),
                  child: FieldBuilder(field: sf, index: fields.indexOf(sf) + 1),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
