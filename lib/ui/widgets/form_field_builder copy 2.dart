import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final TextEditingController? controller; // Dari parent state
  final dynamic value; // Dari formAnswers
  final void Function(String, dynamic) onUpdateAnswer; // Callback tunggal
  final bool isReadOnly;

  const FieldBuilder({
    super.key,
    required this.field,
    required this.index,
    required this.onUpdateAnswer,
    this.controller,
    this.value,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
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
            controller: controller, // ✅ GUNAKAN CONTROLLER DARI SINI
            obscureText: field.type == 'password',
            style: blackTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
            decoration: baseDecoration(),
            onChanged: (value) => onUpdateAnswer(field.key!, value),
          ),
        );

      case 'textNoSpace':
      case 'numberDecimal':
      case 'number':
        return labeledField(
          label: field.label,
          child: TextField(
            keyboardType:
                field.type.startsWith('number') ? TextInputType.number : null,
            controller: controller,
            inputFormatters: [
              if (field.type == 'textNoSpace')
                FilteringTextInputFormatter.deny(RegExp(r'\s')),
              if (field.type == 'number' || field.type == 'numberDecimal')
                FilteringTextInputFormatter.digitsOnly,
              if (field.type == 'numberDecimal')
                NumberFormated(), // Asumsi ini adalah formatter Anda
            ],
            style: blackTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
            decoration: baseDecoration(),
            onChanged: (value) => onUpdateAnswer(field.key!, value),
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
                onUpdateAnswer(field.key!, picked);
              }
            },
            child: AbsorbPointer(
              child: TextField(
                controller: controller, // ✅ Gunakan controller dari parent
                decoration: baseDecoration(
                  suffixIcon: const Icon(Icons.date_range),
                  topPadding: 0,
                  bottomPadding: 0,
                ),
                style: blackTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: semiBold,
                ),
                textAlignVertical: TextAlignVertical.center,
              ),
            ),
          ),
        );

      case 'radio':
        return labeledField(
          label: field.label,
          child: Wrap(
            children: field.options!.map<Widget>((option) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio<String>(
                    value: option,
                    groupValue: value, // ✅ Ambil nilai dari parent
                    onChanged: (val) {
                      // ✅ Update nilai di parent
                      onUpdateAnswer(field.key!, val);
                    },
                  ),
                  Text(option),
                ],
              );
            }).toList(),
          ),
        );

      case 'dropdown':
        // berlaku juga untuk 'dropdownWithAction' dan 'dropdownWithSection'
        return labeledField(
          label: field.label,
          child: DropdownButtonFormField2<String>(
            decoration: baseDecoration(
              leftPadding: 0,
            ),
            value: value, // ✅ Ambil nilai dari parent
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
              // ✅ Update nilai di parent
              onUpdateAnswer(field.key!, val);
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
            value: value, // ✅ Ambil nilai dari parent
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
              // ✅ Update nilai di parent
              onUpdateAnswer(field.key!, val);
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
            value: value, // ✅ Ambil nilai dari parent
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
              // ✅ Update nilai di parent
              onUpdateAnswer(field.key!, val);
            },
          ),
        );

      // case 'cameraAndUpload':
      //   return CameraAndUploadFieldForm(
      //     index: index,
      //     label: field.label,
      //     value: value, // Cukup berikan 'value' yang bisa berupa Map
      //     onFilePicked: (file, timestamp, position) {
      //       // Logika ini sudah benar, teruskan Map ke atas
      //       final fileData = {
      //         'file': file,
      //         'timestamp': timestamp,
      //         'latitude': position?.latitude,
      //         'longitude': position?.longitude,
      //       };
      //       onUpdateAnswer(field.key!, fileData);
      //     },
      //   );

      // // case 'cameraAndUpload':
      // //   return CameraAndUploadFieldForm(
      // //     index: index,
      // //     label: field.label,
      // //     controller: field.controller,
      // //     value: field.value, // penting agar tetap muncul saat rebuild
      // //     onFilePicked: (val, ts, pos) {
      // //       field.value = val; // Simpan ke parent state
      // //       field.timestamp = ts; // Simpan ke parent state
      // //       field.latitude = pos?.latitude;
      // //       field.longitude = pos?.longitude;
      // //     },
      // //     timestamp: field.timestamp,
      // //     latitude: field.latitude,
      // //     longitude: field.longitude,
      // //   );

      // case 'camera':
      // case 'file':
      //   return CameraFieldForm(
      //     index: index,
      //     label: field.label,
      //     value: value, // Cukup berikan 'value' yang bisa berupa Map
      //     onFilePicked: (file, timestamp, position) {
      //       // Logika ini sudah benar, teruskan Map ke atas
      //       final fileData = {
      //         'file': file,
      //         'timestamp': timestamp,
      //         'latitude': position?.latitude,
      //         'longitude': position?.longitude,
      //       };
      //       onUpdateAnswer(field.key!, fileData);
      //     },
      //   );

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

      default:
        return const SizedBox.shrink();
    }
  }
}
