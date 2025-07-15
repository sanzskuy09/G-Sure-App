import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';

// Fungsi untuk dialog Lottie
Future<bool?> showLottieConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String lottieAsset, // Path ke file lottie json
  required Color confirmButtonColor,
  bool showButton = true,
  String confirmButtonText = 'Ya',
}) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        // Kita letakkan animasi di atas judul
        contentPadding:
            const EdgeInsets.only(top: 20, bottom: 0, left: 24, right: 24),
        title: Column(
          children: [
            Lottie.asset(
              lottieAsset,
              width: 120,
              height: 120,
              fit: BoxFit.contain,
              repeat: false,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 20.0),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: showButton
            ? <Widget>[
                // Tombol Batal
                SizedBox(
                  width: 100,
                  child: TextButton(
                    child: const Text(
                      'Batal',
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false); // Mengembalikan false
                    },
                  ),
                ),
                const SizedBox(width: 10),
                // Tombol Konfirmasi
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          confirmButtonColor, // Warna tombol sesuai konteks
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      confirmButtonText,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(true); // Mengembalikan true
                    },
                  ),
                ),
              ]
            : null,
      );
    },
  );
}
