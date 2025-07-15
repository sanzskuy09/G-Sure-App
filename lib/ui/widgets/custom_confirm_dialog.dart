import 'package:flutter/material.dart';

// Fungsi untuk menampilkan dialog konfirmasi yang bisa dipakai ulang
Future<bool?> showCustomConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  required IconData icon,
  required Color iconColor,
  String confirmButtonText = 'Ya',
}) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        icon: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.1),
          radius: 30,
          child: Icon(
            icon,
            size: 30,
            color: iconColor,
          ),
        ),
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: <Widget>[
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
                backgroundColor: iconColor, // Warna tombol sesuai konteks
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                confirmButtonText,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop(true); // Mengembalikan true
              },
            ),
          ),
        ],
      );
    },
  );
}
