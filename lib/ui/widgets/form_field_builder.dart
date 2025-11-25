import 'dart:convert';
import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gsure/models/photo_data_model.dart';
import 'package:gsure/models/question_model.dart';
import 'package:gsure/shared/theme.dart';
import 'package:gsure/ui/pages/face_verification_page.dart';
import 'package:gsure/ui/widgets/camera_and_upload_field.dart';
import 'package:gsure/ui/widgets/camera_and_upload_tambahan_field.dart';
import 'package:gsure/ui/widgets/camera_field.dart';
import 'package:gsure/ui/widgets/file_field.dart';
import 'package:gsure/utils/number_formated.dart';
import 'package:intl/intl.dart';

class FieldBuilder extends StatelessWidget {
  final FieldModel field;
  final int index;
  final void Function(void Function())? setState;
  // final void Function(void Function())? onChanged;
  final ValueChanged<dynamic>? onValueChanged;
  final Map<String, dynamic>? formAnswers;

  const FieldBuilder({
    super.key,
    required this.field,
    required this.index,
    this.setState,
    // this.onChanged,
    this.formAnswers,
    this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ TAMBAHKAN BLOK INI
    // Ambil nilai terbaru dari `formAnswers`
    final dynamic storedValue = formAnswers?[field.key];
    field.value = storedValue;

    // Sinkronisasi nilai untuk TextField via controller.
    // Cek `if` untuk mencegah cursor melompat saat sedang mengetik.
    if (storedValue != null &&
        field.controller.text != storedValue.toString()) {
      field.controller.text = storedValue.toString();
    }

    // Helper method untuk dekorasi input
    InputDecoration baseDecoration({
      Widget? suffixIcon,
      double leftPadding = 14,
      double rightPadding = 14,
      double topPadding = 4,
      double bottomPadding = 4,
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

    // Helper method untuk membungkus field dengan label
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
                  fontWeight: semiBold,
                ),
              ),
              Flexible(
                child: Text(
                  label,
                  style: greyTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: semiBold,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          child,
        ],
      );
    }

    Widget _buildScoreIndicator({
      required String label,
      required IconData icon,
      required double score,
      required Color color,
    }) {
      // Ubah skor (misal: 0.322) menjadi persentase (misal: "32.2%")
      final String percentage = (score).toStringAsFixed(1);

      return Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label dan Ikon
            Row(
              children: [
                Icon(icon, size: 16, color: Colors.grey[700]),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: greyTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: semiBold, // Asumsi 'semiBold' ada
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Progress Bar dan Teks Persentase
            Row(
              children: [
                Expanded(
                  // ClipRRect agar progress bar memiliki sudut bulat
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: score, // Nilai 0.0 - 1.0
                      minHeight: 10,
                      backgroundColor: color.withOpacity(0.2),
                      color: color,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Teks Persen
                Text(
                  '$percentage%',
                  style: blackTextStyle.copyWith(
                    // Asumsi 'blackTextStyle' ada
                    fontSize: 14,
                    fontWeight: semiBold,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget buildVerificationButton(BuildContext context) {
      final dynamic storedValue = formAnswers?[field.key];
      final String? status = formAnswers?['status'];
      final double? livenessScore =
          (formAnswers?['scoreliveness'] as num?)?.toDouble();
      final double? manipulationScore =
          (formAnswers?['scoremanipulation'] as num?)?.toDouble();

      // --- ✅ LOGIKA BARU UNTUK TEKS TOMBOL ---
      String buttonText;

      // Cek 1: Apakah ini DRAFT (skor ada TAPI status BUKAN 'DONE')?
      if ((livenessScore != null || manipulationScore != null) &&
          status != 'DONE') {
        buttonText = 'Retake Verifikasi Wajah';
      }
      // Cek 2: Apakah status lokal 'Ditolak'?
      else if (storedValue == 'Ditolak') {
        buttonText = 'Coba Verifikasi Ulang';
      }
      // Cek 3: Lainnya (Tampilan awal)
      else {
        buttonText = 'Verifikasi Wajah';
      }
      // --- AKHIR LOGIKA BARU ---

      return ElevatedButton.icon(
        onPressed: () async {
          // --- ✅ BLOK VALIDASI BARU ---
          // 1. Ambil nilai 'nohp' dari formAnswers
          final String? nohp =
              formAnswers?['nohp']; // Pastikan key 'nohp' sudah benar
          // Pastikan key 'nohp' sudah benar (object)

          // 2. Cek jika null atau kosong
          if (nohp == null || nohp.isEmpty) {
            // 3. Tampilkan SnackBar alert jika kosong
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Nomor HP wajib diisi sebelum verifikasi!'),
                backgroundColor:
                    Colors.red[700], // Beri warna merah untuk error
              ),
            );
            return; // <-- Hentikan eksekusi, jangan pindah halaman
          }
          // --- AKHIR BLOK VALIDASI ---

          // 2. Pindah halaman DAN TUNGGU HINGGA KEMBALI
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              // ✅ KIRIM formAnswers KE HALAMAN BERIKUTNYA
              builder: (context) => FaceVerificationPage(
                // Teruskan data form yang ada saat ini
                formAnswers: formAnswers,
              ),
            ),
          );

          print('result ===>');
          print(result);

          // 3. Cek jika ada hasil ('Diterima' / 'Ditolak')
          if (result != null && result is Map<String, dynamic>) {
            // Panggil setState untuk update UI
            setState?.call(() {
              // 1. Simpan status utama ('Diterima' / 'Ditolak')
              formAnswers?[field.key!] = result['status'];
              formAnswers?['scoreliveness'] = result['liveness'];
              formAnswers?['scoremanipulation'] = result['manipulation'];
              formAnswers?['dob'] = result['dob'];
              formAnswers?['${field.key}_message'] = result['message'];
              formAnswers?['selfiePhoto_base64'] = result['base64Image'];
            });
          }
        },
        icon: const Icon(Icons.face, size: 20),
        // label: Text(
        //   // Beri label berbeda jika mengulang
        //   storedValue == 'Ditolak'
        //       ? 'Coba Verifikasi Ulang'
        //       : 'Verifikasi Wajah',
        // ),
        label: Text(buttonText),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          backgroundColor: primaryColor, // Asumsi 'primaryColor' ada
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5,
        ),
      );
    }

    switch (field.type) {
      case 'text':
      case 'email':
      case 'password':
        return labeledField(
          label: field.label,
          child: TextField(
            textCapitalization: TextCapitalization.characters,
            controller: field.controller,
            obscureText: field.type == 'password',
            style: blackTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
            decoration: baseDecoration(),
            onChanged: (value) => formAnswers?[field.key!] = value,
          ),
        );

      // case 'button':
      //   return labeledField(
      //     label: field.label,
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         const SizedBox(height: 8), // ✅ Jarak antara label & button
      //         ElevatedButton.icon(
      //           onPressed: () {
      //             Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                 builder: (context) => const FaceVerificationPage(),
      //               ),
      //             );
      //           },
      //           icon: const Icon(Icons.face, size: 20),
      //           label: const Text('Verifikasi Wajah'),
      //           style: ElevatedButton.styleFrom(
      //             padding:
      //                 const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      //             textStyle: const TextStyle(
      //                 fontSize: 16, fontWeight: FontWeight.bold),
      //             backgroundColor: primaryColor,
      //             foregroundColor: Colors.white,
      //             shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(10),
      //             ),
      //             elevation: 5,
      //           ),
      //         ),
      //       ],
      //     ),
      //   );

      case 'button':
        Widget buttonChild;

        // 1. Ambil semua nilai
        final String? status = formAnswers?['status'];
        final dynamic storedValue = formAnswers?[field.key];
        final double? livenessScore =
            (formAnswers?['scoreliveness'] as num?)?.toDouble();
        final double? manipulationScore =
            (formAnswers?['scoremanipulation'] as num?)?.toDouble();
        final dynamic errorMessage = formAnswers?['${field.key}_message'];

        // ✅ Ambil string Base64 dari formAnswers
        final String? selfieBase64 = formAnswers?['selfiePhoto_base64'];

        Widget buildSuccessView() {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (selfieBase64 != null && selfieBase64.isNotEmpty) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                        8.0), // Rounded corners untuk foto
                    child: Image.memory(
                      base64Decode(selfieBase64),
                      width: 100,
                      height: 125, // ✅ HAPUS BARIS INI!
                      fit: BoxFit.fill, // Agar foto tidak pecah
                    ),
                  ),
                  const SizedBox(height: 16), // Jarak antara foto dan skor
                ],
                Row(
                  children: [
                    // if (selfieBase64 != null && selfieBase64.isNotEmpty)
                    //   ClipRRect(
                    //     borderRadius: BorderRadius.circular(
                    //         8.0), // Rounded corners untuk foto
                    //     child: Image.memory(
                    //       base64Decode(selfieBase64),
                    //       width: 60,
                    //       height: 80, // ✅ HAPUS BARIS INI!
                    //       fit: BoxFit.fill, // Agar foto tidak pecah
                    //     ),
                    //   ),
                    // const SizedBox(width: 8),
                    Icon(Icons.check_circle, color: Colors.green[700]),
                    const SizedBox(width: 8),
                    Text(
                      'Verifikasi Diterima',
                      style: blackTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: semiBold,
                      ),
                    ),
                  ],
                ),
                if (livenessScore != null)
                  _buildScoreIndicator(
                    label: 'Liveness',
                    icon: Icons.tag_faces_rounded,
                    score: livenessScore,
                    color: Colors.blue[600]!,
                  ),
                if (manipulationScore != null)
                  _buildScoreIndicator(
                    label: 'Image Manipulation',
                    icon: Icons.security_rounded,
                    score: manipulationScore,
                    color: Colors.red[600]!,
                  ),
              ],
            ),
          );
        }

        // --- 2. LOGIKA BARU DENGAN STATUS 'DONE' ---

        // 🎯 CHECK 1: Apakah status survey 'DONE'?
        if (status == 'DONE') {
          // Tampilkan skor saja, TANPA button. Ini final.
          buttonChild = buildSuccessView();
        }
        // 🎯 CHECK 2: Apakah status lokal 'Ditolak'?
        else if (storedValue == 'Ditolak') {
          // Tampilkan Gagal + Tombol Coba Lagi
          buttonChild = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red[700]),
                    const SizedBox(width: 8),
                    Text(
                      'Verifikasi Ditolak',
                      style: blackTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: semiBold,
                      ),
                    ),
                  ],
                ),
              ),
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Alasan: $errorMessage',
                    style: greyTextStyle.copyWith(
                        fontSize: 14, color: Colors.red[700]),
                  ),
                ),
              buildVerificationButton(context), // Tombol coba lagi
            ],
          );
        }
        // 🎯 CHECK 3: Apakah skor ada (tapi status BELUM 'DONE')?
        else if (livenessScore != null || manipulationScore != null) {
          // Tampilkan Skor + Tombol Coba Lagi (untuk retake)
          buttonChild = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSuccessView(), // Tampilkan skor yang tersimpan
              const SizedBox(height: 12), // Jarak
              buildVerificationButton(context) // Tombol untuk retake
            ],
          );
        }
        // 🎯 CHECK 4: Tampilan Awal (Belum ada skor, tidak ditolak)
        else {
          // Tampilkan tombol "Verifikasi Wajah"
          buttonChild = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              buildVerificationButton(context),
            ],
          );
        }

        return labeledField(
          label: field.label,
          child: buttonChild,
        );

      case 'textNoSpace':
        return labeledField(
          label: field.label,
          child: TextField(
            textCapitalization: TextCapitalization.characters,
            controller: field.controller,
            style: blackTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
            decoration: baseDecoration(),
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'\s')), // Tolak spasi
            ],
            onChanged: (value) => formAnswers?[field.key!] = value,
          ),
        );

      case 'textarea':
        return labeledField(
          label: field.label,
          child: TextField(
            textCapitalization: TextCapitalization
                .sentences, // Capitalizes the first letter of each sentence
            controller: field.controller,
            style: blackTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
            decoration: baseDecoration(),
            keyboardType: TextInputType
                .multiline, // Ini mengaktifkan tombol 'Enter' pada keyboard
            maxLines:
                null, // Ini memungkinkan field untuk tumbuh secara dinamis
            onChanged: (value) => formAnswers?[field.key!] = value,
          ),
        );

      case 'numberDecimal':
        return labeledField(
          label: field.label,
          child: TextField(
            textCapitalization: TextCapitalization.characters,
            controller: field.controller,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              NumberFormated(),
            ],
            style: blackTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
            decoration: baseDecoration(),
            onChanged: (value) => formAnswers?[field.key!] = value,
          ),
        );

      case 'number':
        return labeledField(
          label: field.label,
          child: TextField(
            textCapitalization: TextCapitalization.characters,
            controller: field.controller,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            style: blackTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
            decoration: baseDecoration(),
            onChanged: (value) => formAnswers?[field.key!] = value,
          ),
        );

      case 'date':
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
                textCapitalization: TextCapitalization.characters,
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
                onChanged: (value) => formAnswers?[field.key!] = value,
              ),
            ),
          ),
        );

      case 'radio':
        return labeledField(
          label: field.label,
          child: StatefulBuilder(
            builder: (context, setInnerState) {
              return Wrap(
                spacing: 16, // jarak antar radio item
                runSpacing: 8,
                children: field.options!.map<Widget>((option) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<String>(
                        value: option,
                        groupValue: field.value,
                        onChanged: (val) {
                          setInnerState(() {
                            field.value = val;
                            field.controller.text = val!;
                            formAnswers?[field.key!] = val;
                          });
                          // PENTING: update UI utama
                          // setState?.call(() {});
                          onValueChanged?.call(val);
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      Text(
                        option,
                        style: blackTextStyle.copyWith(fontSize: 14),
                      ),
                    ],
                  );
                }).toList(),
              );
            },
          ),
        );

      case 'dropdown':
        return labeledField(
          label: field.label,
          child: DropdownButtonFormField2<String>(
            decoration: baseDecoration(
              leftPadding: 0,
            ),
            value: field.value,
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
              formAnswers?[field.key!] = val;
            },
          ),
        );

      case 'dropdownWithAction':
        return labeledField(
          label: field.label,
          child: DropdownButtonFormField2<String>(
            decoration: baseDecoration(
              leftPadding: 0,
            ),
            value: field.value,
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
              formAnswers?[field.key!] = val;
              onValueChanged?.call(val);
            },
          ),
        );

      case 'dropdownWithSection':
        return labeledField(
          label: field.label,
          child: DropdownButtonFormField2<String>(
            decoration: baseDecoration(
              leftPadding: 0,
            ),
            value: field.value,
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
              formAnswers?[field.key!] = val;
              // onChanged?.call(() {});
              setState
                  ?.call(() {}); // 🟢 trigger rebuild agar sub-section muncul
              // onValueChanged?.call(val);
            },
          ),
        );

      case 'cameraAndUpload':
        return CameraAndUploadFieldForm(
          index: index,
          label: field.label,
          fieldKey: field.key,
          value: field.value,
          onFilePicked: (val, ts, pos) {
            // 1. Update state lokal field (ini sudah benar)
            field.value = val;
            field.timestamp = ts;
            field.latitude = pos?.latitude;
            field.longitude = pos?.longitude;

            // 2. ✅ TAMBAHKAN INI: Simpan Map lengkap ke formAnswers
            formAnswers?[field.key!] = {
              'file': val,
              'timestamp': ts,
              'latitude': pos?.latitude,
              'longitude': pos?.longitude,
            };

            // 3. Panggil onValueChanged agar parent tahu ada perubahan
            onValueChanged?.call(formAnswers?[field.key!]);
          },
        );

      case 'cameraAndUploadTambahan':
        return CameraAndUploadTambahanFieldForm(
          index: index,
          label: field.label,
          fieldKey: field.key,
          value: field.value,
          onFilePicked: (val, ts, pos) {
            // 1. Update state lokal field (ini sudah benar)
            field.value = val;
            field.timestamp = ts;
            field.latitude = pos?.latitude;
            field.longitude = pos?.longitude;

            // 2. ✅ TAMBAHKAN INI: Simpan Map lengkap ke formAnswers
            formAnswers?[field.key!] = {
              'file': val,
              'timestamp': ts,
              'latitude': pos?.latitude,
              'longitude': pos?.longitude,
            };

            // 3. Panggil onValueChanged agar parent tahu ada perubahan
            onValueChanged?.call(formAnswers?[field.key!]);
          },
        );

      case 'fileUpload':
        return FileFieldWidget(
          enabled: field.value != null ? false : true,
          index: index,
          label: field.label,
          controller: field.controller,
          value: field.value, // penting agar tetap muncul saat rebuild
          onFilePicked: (val) {
            field.value = val; // Simpan ke parent state
          },
        );
      case 'file':
        return CameraFieldForm(
          index: index,
          label: field.label,
          fieldKey: field.key,
          value: field.value, // penting agar tetap muncul saat rebuild
          onFilePicked: (val, ts, pos) {
            // 1. Update state lokal field (ini sudah benar)
            field.value = val;
            field.timestamp = ts;
            field.latitude = pos?.latitude;
            field.longitude = pos?.longitude;

            // 2. ✅ TAMBAHKAN INI: Simpan Map lengkap ke formAnswers
            formAnswers?[field.key!] = {
              'file': val,
              'timestamp': ts,
              'latitude': pos?.latitude,
              'longitude': pos?.longitude,
            };

            // 3. Panggil onValueChanged agar parent tahu ada perubahan
            onValueChanged?.call(formAnswers?[field.key!]);
          },
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
