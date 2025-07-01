import 'package:flutter/material.dart';
import 'package:gsure/models/question_model.dart';
import 'package:gsure/ui/pages/form_survey_page.dart';
import 'package:gsure/ui/widgets/form_field_builder.dart';

class SectionFieldContent extends StatefulWidget {
  final QuestionSection item;
  final Map<String, dynamic> formAnswers;
  // final VoidCallback? onFieldChanged;
  final VoidCallback? onFieldChanged;

  const SectionFieldContent({
    super.key,
    required this.item,
    required this.formAnswers,
    this.onFieldChanged,
  });

  @override
  State<SectionFieldContent> createState() => _SectionFieldContentState();
}

class _SectionFieldContentState extends State<SectionFieldContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...List.generate(widget.item.fields.length, (fIdx) {
          final field = widget.item.fields[fIdx];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: FieldBuilder(
                  field: field,
                  index: fIdx + 1,
                  formAnswers: widget.formAnswers,
                  // setState: setState,
                  // onChanged: (val) => setState(() {
                  //   field.value = val;
                  //   widget.formAnswers[field.label] = val;
                  //   widget.onFieldChanged?.call();
                  // }),
                ),
              ),

              // Sub-section dinamis
              if (field.section != null && field.value != null)
                ...field.section!
                    .where((sub) =>
                        (sub['show'] as List).contains(field.value.toString()))
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

        // Tombol tambah dokumen
        if (widget.item.title == "Foto & Dokumen Pekerjaan / Usaha" ||
            widget.item.title == "Foto & Dokumen Simulasi Perhitungan" ||
            widget.item.title == "Foto & Dokumen Tambahan")
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                final count = widget.item.fields
                    .where((f) => f.type == "cameraAndUpload")
                    .length;

                setState(() {
                  widget.item.fields.add(FieldModel(
                    type: "cameraAndUpload",
                    label: "Foto & Dokumen ${count + 1}",
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
    );
  }
}
