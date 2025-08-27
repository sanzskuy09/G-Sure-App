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
    super.initState();
    // 1. Salin field statis dari template awal
    _fields = List<FieldModel>.from(widget.item.fields);

    // ✅ LOGIKA BARU UNTUK MEMUAT FIELD DINAMIS DARI DRAFT
    _loadDynamicFieldsFromDraft();
  }

  void _loadDynamicFieldsFromDraft() {
    // 2. Tentukan awalan key yang akan dicari berdasarkan judul section
    String keyPrefix;
    if (widget.item.title.contains("Pekerjaan")) {
      keyPrefix = 'dokpekerjaan';
    } else if (widget.item.title.contains("Simulasi")) {
      keyPrefix = 'doksimulasi';
    } else if (widget.item.title.contains("Tambahan")) {
      keyPrefix = 'doktambahan';
    } else {
      // Jika bukan section dinamis, tidak perlu lanjut
      return;
    }

    // 3. Cari semua key di formAnswers yang cocok dengan pola
    widget.formAnswers.forEach((key, value) {
      if (key.startsWith(keyPrefix)) {
        // Pastikan kita tidak menambahkan field yang sudah ada dari template
        if (!_fields.any((field) => field.key == key)) {
          // 4. Jika ditemukan key dinamis, buat FieldModel baru dan tambahkan ke list
          _fields.add(FieldModel(
            key: key,
            type: 'cameraAndUpload',
            label:
                'Foto & Dokumen ${key.substring(keyPrefix.length)}', // Label bisa dibuat lebih dinamis jika perlu
            value: value, // PENTING: Sertakan value yang sudah ada dari draft
          ));
        }
      }
    });
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
                  // field: field,
                  field: field..value = widget.formAnswers[field.key],
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
        // ✅ PERBAIKAN KECIL: TAMBAHKAN setState AGAR UI LANGSUNG UPDATE
        if (widget.item.title == "Foto & Dokumen Pekerjaan / Usaha" ||
            widget.item.title == "Foto & Dokumen Simulasi Perhitungan" ||
            widget.item.title == "Foto & Dokumen Tambahan")
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                // Panggil setState agar UI langsung me-render field baru
                setState(() {
                  String keyPrefix;
                  if (widget.item.title.contains("Pekerjaan")) {
                    keyPrefix = 'dokpekerjaan';
                  } else if (widget.item.title.contains("Simulasi")) {
                    keyPrefix = 'doksimulasi';
                  } else {
                    keyPrefix = 'doktambahan';
                  }

                  // ✅ HITUNG FIELD YANG SUDAH ADA DENGAN PREFIX YANG SAMA
                  final count = _fields
                      .where((f) => f.key?.startsWith(keyPrefix) ?? false)
                      .length;

                  // ✅ BUAT KEY DAN LABEL BARU SESUAI FORMAT
                  final newKey = '$keyPrefix${count + 1}';
                  final newLabel = 'Foto & Dokumen ${count + 1}';

                  _fields.add(FieldModel(
                    key: newKey, // <-- Gunakan key baru
                    type: "cameraAndUploadTambahan",
                    label: newLabel, // <-- Gunakan label baru
                  ));
                });
              },
              icon: const Icon(Icons.add, size: 16),
              label: const Text("Tambah Dokumen"),
            ),
          ),
      ],
    );
  }
}
