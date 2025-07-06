import 'package:flutter/material.dart';
import 'package:gsure/models/question_model.dart';
import 'package:gsure/ui/pages/form_survey_page.dart';
import 'package:gsure/ui/widgets/form_field_builder.dart';

class SectionFieldContent extends StatefulWidget {
  final QuestionSection item;
  final Map<String, dynamic> formAnswers;
  final VoidCallback? onFieldChanged;
  final Map<String, TextEditingController> controllers;
  final void Function(String, dynamic) onUpdateAnswer; // <-- TERIMA DI SINI
  // final void Function(void Function())? onFieldChanged;

  const SectionFieldContent({
    super.key,
    required this.item,
    required this.formAnswers,
    required this.controllers,
    this.onFieldChanged,
    required this.onUpdateAnswer,
  });

  @override
  State<SectionFieldContent> createState() => _SectionFieldContentState();
}

class _SectionFieldContentState extends State<SectionFieldContent> {
  late List<FieldModel> _fields;

  @override
  void initState() {
    super.initState();
    _fields = List<FieldModel>.from(widget.item.fields);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ✅ Langkah 2: Gunakan state lokal `_fields` untuk membangun UI
        ...List.generate(_fields.length, (fIdx) {
          final field = _fields[fIdx];

          // Gabungkan RT dan RW dalam satu Row
          if (field.label == "RT" &&
              fIdx + 1 < _fields.length &&
              _fields[fIdx + 1].label == "RW") {
            final rtField = field;
            final rwField = _fields[fIdx + 1];

            // Lewatkan RW di iterasi selanjutnya
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: FieldBuilder(
                          field: rtField,
                          index: fIdx + 1,
                          controller: widget
                              .controllers[rtField.key], // Untuk field teks
                          value: widget
                              .formAnswers[rtField.key], // Untuk field non-teks
                          onUpdateAnswer:
                              widget.onUpdateAnswer, // ✅ Callback tunggal
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FieldBuilder(
                          field: rwField,
                          index: fIdx + 1,
                          controller: widget
                              .controllers[rwField.key], // Untuk field teks
                          value: widget
                              .formAnswers[rwField.key], // Untuk field non-teks
                          onUpdateAnswer:
                              widget.onUpdateAnswer, // ✅ Callback tunggal
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          // Lewatkan RW karena sudah digabung di RT
          if (field.label == "RW" &&
              fIdx > 0 &&
              _fields[fIdx - 1].label == "RT") {
            return const SizedBox.shrink(); // kosongkan
          }

          final currentValue = widget.formAnswers[field.key];

          // Default rendering untuk field lain
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: FieldBuilder(
                  field: field,
                  index: fIdx + 1,
                  controller: widget.controllers[field.key], // Untuk field teks
                  value: widget.formAnswers[field.key], // Untuk field non-teks
                  onUpdateAnswer: widget.onUpdateAnswer, // ✅ Callback tunggal
                ),
              ),

              // Ambil nilai saat ini dari formAnswers
              if (field.section != null && currentValue != null)
                ...field.section!
                    .where((sub) =>
                        (sub['show'] as List).contains(currentValue.toString()))
                    .expand((sub) {
                  final subFields = (sub['fields'] as List)
                      .map((f) => FieldModel.fromJson(f))
                      .toList();
                  return [
                    const SizedBox(height: 8),
                    MyNestedAccordion(
                      title: sub['title'],
                      fields: subFields,
                      // V-- KIRIM DATA & CALLBACK DARI PARENT --V
                      controllers: widget.controllers,
                      formAnswers: widget.formAnswers,
                      onUpdateAnswer: widget.onUpdateAnswer,
                    ),
                  ];
                }),
            ],
          );
        }),

        if (widget.item.title == "Foto & Dokumen Pekerjaan / Usaha" ||
            widget.item.title == "Foto & Dokumen Simulasi Perhitungan" ||
            widget.item.title == "Foto & Dokumen Tambahan")
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // Panggil setState untuk menambahkan field baru ke state lokal
                setState(() {
                  final count =
                      _fields.where((f) => f.type == "cameraAndUpload").length;

                  _fields.add(
                    FieldModel(
                      type: "cameraAndUpload",
                      label: "Foto & Dokumen ${count + 1}",
                      key: "dokumen${count + 1}",
                    ),
                  );
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
