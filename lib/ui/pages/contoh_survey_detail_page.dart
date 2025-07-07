import 'dart:convert';
import 'dart:io';

import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gsure/models/question_model.dart';
import 'package:gsure/models/survey_data.dart';
import 'package:gsure/shared/theme.dart';
import 'package:gsure/ui/widgets/question_section.dart';

class SurveyDetailPage extends StatefulWidget {
  final SurveyData survey;

  const SurveyDetailPage({super.key, required this.survey});

  @override
  State<SurveyDetailPage> createState() => _SurveyDetailPageState();
}

class _SurveyDetailPageState extends State<SurveyDetailPage> {
  List<QuestionSection> _questionSections = [];
  final Map<String, TextEditingController> _controllers =
      {}; // <-- TAMBAHKAN INI
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAndPopulateForm();
  }

  Future<void> _loadAndPopulateForm() async {
    // 1. Muat struktur JSON
    try {
      final String jsonStr =
          await rootBundle.loadString('assets/survey_form.json');
      final List<dynamic> jsonData = json.decode(jsonStr);

      // 2. Buat List<QuestionSection> dari JSON
      List<QuestionSection> sections =
          jsonData.map((e) => QuestionSection.fromJson(e)).toList();

      // 3. Isi (Populate) data dari Hive ke dalam struktur tersebut
      for (var section in sections) {
        for (var field in section.fields) {
          // Ambil nilai dari Hive object

          print('ini print value nya apaa');
          print(field.key);
          print(widget.survey.kddealer);
          dynamic fieldValue;
          // Gunakan switch untuk memetakan data dari SurveyData ke FieldModel
          switch (field.key) {
            case 'kddealer':
              field.value = widget.survey.kddealer;
              break;
            case 'statuspernikahan':
              field.value = widget.survey.statuspernikahan;
              break;
            case 'pekerjaan':
              field.value = widget.survey.pekerjaan;
              break;
            case 'nama':
              field.value = widget.survey.nama;
              break;
            case 'hargakendaraan':
              field.value = widget.survey.hargakendaraan;
              break;
            case 'rt':
              field.value = widget.survey.rt;
              break;
            case 'rw':
              field.value = widget.survey.rw;
              break;
            case 'kodepos':
              field.value = widget.survey.kodepos;
              break;
            case 'odometer':
              field.value = widget.survey.odometer;
              break;
            case 'namapasangan':
              field.value = widget.survey.namapasangan;
              break;
            case 'isPenjamin':
              field.value = widget.survey.isPenjamin;
              break;
            case 'telppenjamin':
              field.value = widget.survey.telppenjamin;
              break;
            // ... Lanjutkan untuk semua field lainnya ...

            // Untuk file, kita buat ulang Map-nya
            case 'fotounitdepan':
              if (widget.survey.fotounitdepanPath != null) {
                field.value = {'file': File(widget.survey.fotounitdepanPath!)};
              }
              break;
            case 'fotostnk':
              if (widget.survey.fotostnkPath != null) {
                field.value = {'file': File(widget.survey.fotostnkPath!)};
              }
              break;
          }

          // Isi properti .value (PENTING untuk dropdown, radio, dll. dalam mode read-only)
          // field.value = fieldValue;
          fieldValue = field.value;

          // print('ini print value nya apaa');
          // print(fieldValue);

          // ✅ LOGIKA BARU: Buat dan isi controller untuk field teks
          if (field.type == 'text' ||
              field.type == 'number' ||
              field.type == 'numberDecimal' ||
              field.type == 'date' /*dll.*/) {
            // Buat controller baru
            final controller = TextEditingController();

            // Isi teks controller dengan nilai yang tersimpan
            if (fieldValue != null) {
              controller.text = fieldValue.toString();
            }

            // Simpan controller ke dalam map
            _controllers[field.key!] = controller;
          }
        }
      }

      setState(() {
        _questionSections = sections;
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      // JIKA TERJADI ERROR, BLOK INI AKAN DIJALANKAN
      print("❌ TERJADI ERROR SAAT MEMUAT DETAIL SURVEY: $e");
      print(stackTrace); // Tampilkan detail error di debug console

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data detail: $e')),
        );
      }
    } finally {
      // BLOK INI AKAN SELALU DIJALANKAN, BAIK SUKSES MAUPUN GAGAL
      // Pastikan loading selalu berhenti
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // Loop dan dispose semua controller yang sudah kita buat
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Survey: ${widget.survey.nama ?? "Tanpa Nama"}'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Accordion(
              // Gunakan UI accordion yang sama persis
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
              children: List.generate(
                _questionSections.length,
                (index) {
                  final item = _questionSections[index];
                  return AccordionSection(
                    isOpen: true, // Biarkan semua terbuka
                    contentVerticalPadding: 10,
                    leftIcon: const Icon(
                      Icons.question_answer_outlined,
                      color: Colors.white,
                    ),
                    header: Text(
                      item.title,
                      style: whiteTextStyle.copyWith(
                          fontSize: 16, fontWeight: semiBold),
                    ),
                    content: SectionFieldContent(
                      item: item,
                      // Karena read-only, kita bisa kirim data dummy/kosong
                      formAnswers: {},
                      // controllers: _controllers,
                      // onUpdateAnswer: (key, value) {}, // Callback kosong
                    ),
                  );
                },
              ),
            ),

      // body: Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: ListView(
      //     children: [
      //       // Contoh menampilkan data teks
      //       Text('Pekerjaan: ${widget.survey.pekerjaan ?? "-"}',
      //           style: const TextStyle(fontSize: 18)),
      //       const SizedBox(height: 20),
      //       Text('Nama: ${widget.survey.nama ?? "-"}',
      //           style: const TextStyle(fontSize: 18)),
      //       const SizedBox(height: 20),

      //       // Cara menampilkan gambar dari path
      //       const Text('Foto STNK:',
      //           style: TextStyle(fontWeight: FontWeight.bold)),
      //       const SizedBox(height: 8),

      //       // Cek jika path-nya ada dan tidak kosong
      //       (widget.survey.fotostnkPath != null &&
      //               widget.survey.fotostnkPath!.isNotEmpty)
      //           ? Image.file(
      //               File(widget.survey
      //                   .fotostnkPath!), // 1. Buat object File dari String path
      //               fit: BoxFit.cover,
      //               // 2. Tampilkan error jika file tidak ditemukan (misal: cache terhapus)
      //               errorBuilder: (context, error, stackTrace) {
      //                 return const Center(
      //                   child: Text(
      //                     'Gagal memuat gambar.\nFile mungkin telah dihapus dari cache.',
      //                     textAlign: TextAlign.center,
      //                   ),
      //                 );
      //               },
      //             )
      //           : const Center(
      //               child: Text(
      //                   'Tidak ada gambar'), // Tampilan jika tidak ada gambar
      //             ),

      //       const SizedBox(height: 20),

      //       // Contoh untuk gambar kedua
      //       const Text('Foto Unit Depan:',
      //           style: TextStyle(fontWeight: FontWeight.bold)),
      //       const SizedBox(height: 8),

      //       (widget.survey.fotounitdepanPath != null &&
      //               widget.survey.fotounitdepanPath!.isNotEmpty)
      //           ? Image.file(File(widget.survey.fotounitdepanPath!))
      //           : const Center(child: Text('Tidak ada gambar')),
      //     ],
      //   ),
      // ),
    );
  }
}
