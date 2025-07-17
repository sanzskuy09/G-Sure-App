import 'package:flutter/material.dart';
import 'package:gsure/models/question_model.dart';
// import 'package:gsure/ui/pages/form_survey_page.dart';
import 'package:gsure/ui/widgets/form_field_builder.dart';
import 'package:gsure/ui/widgets/nested_accordion.dart';

class SectionFieldContent extends StatefulWidget {
  final QuestionSection item;
  final Map<String, dynamic> formAnswers;
  final VoidCallback? onFieldChanged;
  // final void Function(void Function())? onFieldChanged;

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
  late List<FieldModel> _fields;
  final Map<String, List<FieldModel>> _nestedFieldsCache = {};

  @override
  void initState() {
    // TODO: implement initState
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
                          formAnswers: widget.formAnswers,
                          setState: setState,
                          onValueChanged: (newValue) {
                            setState(() {
                              rtField.value = newValue;
                              widget.formAnswers[rtField.key!] = newValue;
                              widget.onFieldChanged?.call();
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FieldBuilder(
                          field: rwField,
                          index: fIdx + 2,
                          formAnswers: widget.formAnswers,
                          setState: setState,
                          onValueChanged: (newValue) {
                            setState(() {
                              rwField.value = newValue;
                              widget.formAnswers[rwField.key!] = newValue;
                              widget.onFieldChanged?.call();
                            });
                          },
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

          // Default rendering untuk field lain
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: FieldBuilder(
                  field: field,
                  index: fIdx + 1,
                  formAnswers: widget.formAnswers,
                  setState: setState,
                  onValueChanged: (newValue) {
                    setState(() {
                      field.value = newValue;
                      widget.formAnswers[field.key!] = newValue;
                      widget.onFieldChanged?.call();
                    });
                  },
                ),
              ),
              if (field.section != null && field.value != null)
                ...field.section!
                    .where((sub) =>
                        (sub['show'] as List).contains(field.value.toString()))
                    .expand((sub) {
                  // Buat key unik untuk setiap sub-section
                  final cacheKey = "${field.key}_${sub['title']}";

                  // Ambil dari cache, atau buat baru jika belum ada
                  final subFields =
                      _nestedFieldsCache.putIfAbsent(cacheKey, () {
                    // Kode ini hanya akan berjalan SEKALI untuk setiap sub-section
                    return (sub['fields'] as List)
                        .map((f) => FieldModel.fromJson(f))
                        .toList();
                  });

                  // final subFields = (sub['fields'] as List)
                  //     .map((f) => FieldModel.fromJson(f))
                  //     .toList();
                  return [
                    const SizedBox(height: 8),
                    MyNestedAccordion(
                      title: sub['title'],
                      fields: subFields,
                      // V-- KIRIM DATA & CALLBACK DARI PARENT --V
                      formAnswers: widget.formAnswers,
                      onFieldChanged: widget.onFieldChanged,
                    ),
                  ];
                }),
            ],
          );
        }),

        // ✅ Langkah 4: Perbaiki logika "Tambah Dokumen"
        if (widget.item.title == "Foto & Dokumen Pekerjaan / Usaha" ||
            widget.item.title == "Foto & Dokumen Simulasi Perhitungan" ||
            widget.item.title == "Foto & Dokumen Tambahan")
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                String keyPrefix;

                // Tentukan awalan key berdasarkan judul section
                if (widget.item.title.contains("Pekerjaan")) {
                  keyPrefix = 'dokpekerjaan';
                } else if (widget.item.title.contains("Simulasi")) {
                  keyPrefix = 'doksimulasi';
                } else {
                  // Asumsikan sisanya adalah "Tambahan"
                  keyPrefix = 'doktambahan';
                }

                // Buat key yang unik, contohnya dengan timestamp
                final uniqueKey =
                    '${keyPrefix}_${DateTime.now().millisecondsSinceEpoch}';

                final count =
                    _fields.where((f) => f.type == "cameraAndUpload").length;

                // ✅ PENTING: Sertakan `key: uniqueKey` saat membuat FieldModel baru
                _fields.add(FieldModel(
                  key: uniqueKey,
                  type: "cameraAndUpload",
                  label: "Foto & Dokumen ${count + 1}",
                ));
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
