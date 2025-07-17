import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gsure/models/photo_data_model.dart';
import 'package:gsure/models/question_model.dart';
import 'package:gsure/shared/theme.dart';
import 'package:gsure/ui/widgets/camera_and_upload_field.dart';
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
