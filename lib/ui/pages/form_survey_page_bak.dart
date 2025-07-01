import 'dart:convert';

import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gsure/models/question_model.dart';
import 'package:gsure/shared/theme.dart';
import 'package:gsure/ui/widgets/buttons.dart';
import 'package:gsure/ui/widgets/form_field_builder.dart';
import 'package:gsure/ui/widgets/question_section.dart';

class FormSurveyPageBak extends StatefulWidget {
  const FormSurveyPageBak({super.key});

  @override
  State<FormSurveyPageBak> createState() => _FormSurveyPageBakState();
}

class _FormSurveyPageBakState extends State<FormSurveyPageBak> {
  // late List<Map<String, dynamic>> _question = questionData;
  Map<String, dynamic> formAnswers = {};
  List<QuestionSection> _question = [];
  int visibleCount = 1; // Awalnya hanya section pertama
  // List<bool> openStates = [];
  // int openIndex = 0;
  // DateTime? selectedDate;
  // int visibleSectionCount = 1; // hanya tampilkan satu section di awal

  Future<List<QuestionSection>> loadQuestionData() async {
    final String jsonStr =
        await rootBundle.loadString('assets/question_data1.json');
    final List<dynamic> jsonData = json.decode(jsonStr);
    return jsonData.map((e) => QuestionSection.fromJson(e)).toList();
  }

  // MODIFIKASI: Getter ini sekarang menjadi satu-satunya penentu section yang terlihat.
  // List<int> get visibleSectionIndexes {
  //   List<int> result = [];

  //   for (int i = 0; i < _question.length; i++) {
  //     final item = _question[i];

  //     // Cek apakah section ini adalah section pertama, selalu tampilkan.
  //     if (i == 0) {
  //       result.add(i);
  //       continue;
  //     }

  //     // Cek kondisi showIf (jika ada)
  //     if (item.showIf != null) {
  //       bool shouldShow = true;
  //       item.showIf!.forEach((key, allowedValues) {
  //         final currentValue = formAnswers[key]?.toString();
  //         if (!allowedValues.contains(currentValue)) {
  //           shouldShow = false;
  //         }
  //       });

  //       if (shouldShow) {
  //         result.add(i);
  //       }
  //     } else {
  //       // result.add(i);
  //       // break;
  //     }
  //   }
  //   return result;
  // }

  List<int> get visibleSectionIndexes {
    List<int> result = [];

    for (int i = 0; i < _question.length; i++) {
      final item = _question[i];

      if (i == 0) {
        result.add(i);
        continue;
      }

      if (item.showIf != null) {
        bool shouldShow = true;
        item.showIf!.forEach((key, allowedValues) {
          final currentValue = formAnswers[key]?.toString();
          if (!allowedValues.contains(currentValue)) {
            shouldShow = false;
          }
        });

        if (shouldShow) {
          result.add(i);
        }
      }
    }

    // Batasi hasil dengan visibleCount
    return result.take(visibleCount).toList();
  }

  void _showNextSection() {
    setState(() {
      visibleCount += 1;
    });
  }

  @override
  void initState() {
    super.initState();
    loadQuestionData().then((data) {
      setState(() {
        _question = data;
        // openStates tidak lagi dibutuhkan karena kita mengontrolnya langsung di properti `isOpen`.
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

    // Hitung ulang index yang terlihat setiap kali build dipanggil
    final visibleIndexes = visibleSectionIndexes;

    return Scaffold(
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
        headerPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
        sectionClosingHapticFeedback: SectionHapticFeedback.light,
        // MODIFIKASI: Gunakan list `visibleIndexes` yang sudah dihitung
        children: List.generate(visibleIndexes.length, (index) {
          final actualIndex = visibleIndexes[index];
          final item = _question[actualIndex];

          return AccordionSection(
            isOpen: index == visibleIndexes.length - 1,
            contentVerticalPadding: 10,
            leftIcon: const Icon(
              Icons.youtube_searched_for_outlined,
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
              onFieldChanged: () {
                // INI KUNCINYA! Setiap ada perubahan, panggil setState.
                // Ini akan memicu `build` dan menghitung ulang `visibleSectionIndexes`
                // dengan nilai `formAnswers` yang terbaru.
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
                color: lightBackgorundColor,
                width: 1.0,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BuildButton(
                iconData: Icons.save_as,
                title: "Simpan",
                onPressed: () {
                  // Implementasi logika simpan
                  print(formAnswers);
                },
              ),
              BuildButton(
                iconData: Icons.send,
                title: "Kirim",
                // Anda bisa menambahkan logika validasi di sini
                // Contoh: isDisabled: !isFormComplete(),
                onPressed: () {
                  // Implementasi logika kirim
                },
              ),
              BuildButton(
                iconData: Icons.arrow_forward_ios,
                title: "Berikutnya",
                isDisabled: visibleSectionIndexes.length >= _question.length,
                onPressed: _showNextSection,
              )
              // HAPUS: Tombol "Berikutnya" tidak lagi relevan untuk menampilkan section.
              // Anda bisa menggantinya dengan tombol lain jika perlu, misal "Validasi".
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
                        FieldBuilder(field: sf, index: fields.indexOf(sf) + 1),
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
