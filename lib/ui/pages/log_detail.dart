import 'dart:convert';
// import 'package:flutter/foundation.dart';

import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gsure/models/question_model.dart';
import 'package:gsure/shared/theme.dart';
import 'package:gsure/ui/widgets/file_field.dart';
import 'package:gsure/utils/number_formated.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:gsure/shared/question_list.dart';

class LogDetailPage extends StatefulWidget {
  const LogDetailPage({super.key});

  @override
  State<LogDetailPage> createState() => _LogDetailPageState();
}

class _LogDetailPageState extends State<LogDetailPage> {
  // late List<Map<String, dynamic>> _question = questionData;
  List<QuestionSection> _question = [];

  int openIndex = 0;
  DateTime? selectedDate;
  int visibleSectionCount = 1; // hanya tampilkan satu section di awal

  Future<List<QuestionSection>> loadQuestionData() async {
    final String jsonStr =
        await rootBundle.loadString('assets/question_data.json');
    final List<dynamic> jsonData = json.decode(jsonStr);
    return jsonData.map((e) => QuestionSection.fromJson(e)).toList();
  }

  @override
  void initState() {
    super.initState();
    // _question = questionData; // gunakan data dari file terpisah
    loadQuestionData().then((data) {
      setState(() {
        _question = data;
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
        title: Text(
          'Log Detail',
        ),
      ),
      // body: AccordionPage(),
      body: Accordion(
        headerBackgroundColor: secondaryColor,
        headerBorderColor: secondaryColor,
        headerBorderColorOpened: Colors.transparent,
        // headerBorderWidth: 1,
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
        children: List.generate(_question.length, (index) {
          final item = _question[index];

          return AccordionSection(
            isOpen: false,
            contentVerticalPadding: 10,
            leftIcon: const Icon(
              // Icons.text_fields_rounded,
              Icons.question_answer_outlined,
              color: Colors.white,
            ),
            header: Text(
              item.title,
              style:
                  whiteTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
            ),
            content: Column(
              children: List.generate(item.fields.length, (fIdx) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child:
                      buildFieldBuilder(item.fields[fIdx], context, fIdx + 1),
                );
              }),
            ),
          );
        }),
      ),
    );
  }

  Widget buildFieldBuilder(FieldModel field, BuildContext context, int index) {
    if (field.controller.text.isEmpty) {
      field.controller.text = 'deskripsi detail form';
    }
    // Reusable label + field wrapper
    Widget labeledField({required String label, required Widget child}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$index. ',
                style: greyTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: medium,
                ),
              ),
              Flexible(
                // <<<<< Tambahkan ini
                child: Text(
                  label,
                  style: greyTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: medium,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  maxLines: 2,
                ),
              ),
            ],
          ),

          // const SizedBox(height: 4),
          child,
        ],
      );
    }

    InputDecoration baseDecoration({
      Widget? suffixIcon,
      double leftPadding = 14, // default
      double rightPadding = 14, // default
      double topPadding = 4, // default
      double bottomPadding = 4, // default
    }) {
      return InputDecoration(
        border: const UnderlineInputBorder(),
        isDense: true,
        contentPadding: EdgeInsets.only(
          left: leftPadding,
          top: topPadding,
          right: rightPadding,
          bottom: bottomPadding,
        ),
        suffixIcon: suffixIcon,
      );
    }

    switch (field.type) {
      case 'text':
      case 'email':
      case 'dropdown':
      case 'date':
      case 'file':
      case 'password':
        return labeledField(
          label: field.label,
          child: TextField(
            // enabled: false,
            readOnly: true,
            controller: field.controller,
            obscureText: field.type == 'password',
            style: blackTextStyle.copyWith(fontSize: 16, fontWeight: medium),
            decoration: baseDecoration(),
          ),
        );

      case 'number':
        return labeledField(
          label: field.label,
          child: TextField(
            enabled: false,
            controller: field.controller,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              NumberFormated(),
            ],
            style: blackTextStyle.copyWith(fontSize: 16, fontWeight: medium),
            decoration: baseDecoration(),
          ),
        );

      case 'date1':
        return labeledField(
          label: field.label,
          child: GestureDetector(
            onTap: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                field.value = picked;
                field.controller.text = DateFormat('yyyy-MM-dd').format(picked);
              }
            },
            child: AbsorbPointer(
              child: TextField(
                enabled: false,
                controller: field.controller,
                decoration: baseDecoration(
                  suffixIcon: const Icon(Icons.date_range),
                  topPadding: 0,
                  bottomPadding: 0,
                ),
                style:
                    blackTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
                textAlignVertical:
                    TextAlignVertical.center, // ⬅️ Tambahan penting!
              ),
            ),
          ),
        );

      case 'dropdown1':
        return labeledField(
          label: field.label,
          child: DropdownButtonFormField2<String>(
            decoration: baseDecoration(
              leftPadding: 0,
            ),
            value: (field.value == null || field.value!.isEmpty)
                ? 'Laki-laki'
                : field.value,
            dropdownStyleData: DropdownStyleData(
              padding: EdgeInsets.zero,
              offset: Offset(0, 0),
            ),
            buttonStyleData: const ButtonStyleData(
              padding: EdgeInsets.symmetric(horizontal: 0),
            ),
            menuItemStyleData: const MenuItemStyleData(
              padding: EdgeInsets.symmetric(horizontal: 2),
            ),
            items: field.options!
                .map(
                  (option) => DropdownMenuItem(
                    value: option,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 14),
                      child: Text(
                        option,
                        style: blackTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: semiBold,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: (val) {
              field.value = val;
            },
          ),
        );

      case 'file1':
        return FileFieldWidget(
          enabled: false,
          index: index,
          label: field.label,
          controller: field.controller,
          value: field.value, // penting agar tetap muncul saat rebuild
          onFilePicked: (val) {
            field.value = val; // Simpan ke parent state
          },
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
