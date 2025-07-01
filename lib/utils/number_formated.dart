import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NumberFormated extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat.decimalPattern();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Ambil hanya angka
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (newText.isEmpty) {
      return newValue.copyWith(text: '');
    }

    String formatted = _formatter.format(int.parse(newText));

    // Perhitungan posisi kursor
    int offset =
        formatted.length - (oldValue.text.length - oldValue.selection.start);

    return TextEditingValue(
      text: formatted,
      selection:
          TextSelection.collapsed(offset: offset.clamp(0, formatted.length)),
    );
  }
}
