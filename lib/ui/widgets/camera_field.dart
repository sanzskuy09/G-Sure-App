import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gsure/models/photo_data_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gsure/shared/theme.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class CameraFieldForm extends StatefulWidget {
  final int index;
  final String label;
  final String? fieldKey;
  final dynamic value; // Ini akan menerima Map dari formAnswers
  final Function(dynamic, DateTime, Position?) onFilePicked;

  const CameraFieldForm({
    super.key,
    required this.index,
    required this.label,
    this.fieldKey,
    required this.value,
    required this.onFilePicked,
  });

  @override
  State<CameraFieldForm> createState() => _CameraFieldFormState();
}

class _CameraFieldFormState extends State<CameraFieldForm> {
  late final TextEditingController _displayController;

  // State lokal untuk menyimpan data yang sudah diproses
  dynamic _fileData; // Bisa berupa String path atau Uint8List
  DateTime? _dateTime;
  Position? _photoPosition;

  bool _isMockLocation = false;
  bool _isFileFromPicker = false;

  bool get isImage {
    final name = _displayController.text.toLowerCase();
    return name.endsWith('.jpg') ||
        name.endsWith('.jpeg') ||
        name.endsWith('.png');
  }

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller lokal
    _displayController = TextEditingController();

    // 3. Logika utama: Proses 'widget.value' saat pertama kali widget dibuat
    _processInitialValue();
    _checkFakeGPS();
  }

  Future<File> _copyFileToAppDir(File sourceFile, String newFileName) async {
    // Dapatkan direktori dokumen aplikasi yang permanen
    final appDir = await getApplicationDocumentsDirectory();

    // Buat path tujuan yang baru
    final newPath = p.join(appDir.path, newFileName);

    // Salin file dari sumber (cache) ke tujuan baru
    return await sourceFile.copy(newPath);
  }

  Future<void> _checkFakeGPS() async {
    try {
      // 1. Cek apakah service lokasi aktif
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("⚠ Lokasi tidak aktif di perangkat")),
        );
        return;
      }

      // 2. Cek dan minta permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("⚠ Akses lokasi ditolak")),
          );
          return;
        }
      }

      // 3. Ambil posisi terkini
      final pos = await Geolocator.getCurrentPosition();

      if (!mounted) return; // ⛑️ Cegah update state setelah dispose

      setState(() {
        _isMockLocation = pos.isMocked;
      });

      if (_isMockLocation) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("⚠ Fake GPS terdeteksi, kamera tidak diizinkan")),
        );
      }
    } catch (e) {
      if (!mounted) return; // ✅ penting
      setState(() {
        _isMockLocation = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("⚠ Tidak bisa akses lokasi, kamera tidak diizinkan")),
      );
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _processInitialValue() {
    // Prioritas 1: Cek jika value adalah Map (dari form yang baru diisi)
    if (widget.value is Map) {
      final initialData = widget.value as Map;
      final file = initialData['file'];

      // if (file != null) {
      //   if (file is File) {
      //     _fileData = file.path;
      //     _displayController.text = file.path.split('/').last;
      //   } else if (file is String) {
      //     _fileData = file;
      //     _displayController.text = file.split('/').last;
      //   }
      // }
      if (file != null) {
        // Dapatkan path baik dari objek File maupun String
        final String path = (file is File) ? file.path : file.toString();

        // ✅ LOGIKA BARU UNTUK NAMA FILE (SAMA SEPERTI DI FUNGSI PICKER)
        final extension = path.split('.').last;
        final newFileName = '${widget.fieldKey ?? 'file'}.$extension';

        _fileData = path;
        _displayController.text = newFileName; // <-- GUNAKAN NAMA BARU
      }

      _dateTime = initialData['timestamp'];
      final lat = initialData['latitude'] as double?;
      final lon = initialData['longitude'] as double?;
      if (lat != null && lon != null) {
        _photoPosition = Position(
            latitude: lat,
            longitude: lon,
            timestamp: DateTime.now(),
            accuracy: 0,
            altitude: 0,
            altitudeAccuracy: 0,
            heading: 0,
            headingAccuracy: 0,
            speed: 0,
            speedAccuracy: 0);
      }
    }
    // ✅ TAMBAHKAN BLOK INI
    // Prioritas 2: Cek jika value adalah objek PhotoData (dari data Hive/draft)
    else if (widget.value is PhotoData) {
      final photoData = widget.value as PhotoData;
      final path = photoData.path;

      if (path != null) {
        // Set state lokal sama seperti di _pickFile
        final extension = path.split('.').last;
        final newFileName = '${widget.fieldKey ?? 'file'}.$extension';

        _fileData = path;
        _displayController.text = newFileName; // <-- GUNAKAN NAMA BARU
        _dateTime = photoData.timestamp;

        // Buat ulang objek Position dari data yang ada
        if (photoData.latitude != null && photoData.longitude != null) {
          _photoPosition = Position(
              latitude: photoData.latitude!,
              longitude: photoData.longitude!,
              timestamp: DateTime.now(),
              accuracy: 0,
              altitude: 0,
              altitudeAccuracy: 0,
              heading: 0,
              headingAccuracy: 0,
              speed: 0,
              speedAccuracy: 0);
        }
      }
    }
    // Fallback jika value adalah tipe lain tapi tidak null (misal: String langsung)
    else if (widget.value != null) {
      _fileData = widget.value.toString();
      _displayController.text = _fileData.toString().split('/').last;
    }
  }

  @override
  void dispose() {
    // 4. Jangan lupa dispose controller lokal
    _displayController.dispose();
    super.dispose();
  }

  void _captureImage() async {
    // _isFilePicked = false;
    if (_isMockLocation) return;

    _showLoadingDialog(); // ⏳ Tampilkan loading SEBELUM buka kamera

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 60,
    );

    if (pickedFile == null) {
      if (mounted) Navigator.of(context).pop(); // tutup loading jika batal
      return;
    }

    final now = DateTime.now();

    Position? currentPosition;
    try {
      currentPosition = await Geolocator.getLastKnownPosition();
      currentPosition ??= await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        timeLimit: const Duration(seconds: 5),
      );
    } catch (e) {
      currentPosition = null;
    }

    // final fileData = kIsWeb ? await pickedFile.readAsBytes() : pickedFile.path;
    final capturedFile = File(pickedFile.path);
    // ✅ LOGIKA BARU UNTUK MENYALIN DAN MENGGANTI NAMA FILE
    // 1. Buat nama file baru yang diinginkan
    final timestamp = now.millisecondsSinceEpoch;
    final newFileName = '${widget.fieldKey ?? 'camera_image'}_$timestamp.jpg';

    // 2. Salin file ke direktori aplikasi dengan nama baru
    final newFile = await _copyFileToAppDir(capturedFile, newFileName);

    if (!mounted) return;

    // 3. Gunakan file baru untuk state dan callback
    setState(() {
      _fileData = newFile.path; // <-- Gunakan path dari file baru
      _dateTime = now;
      _photoPosition = currentPosition;
      _displayController.text =
          newFileName; // <-- Teks display juga pakai nama baru
    });

    widget.onFilePicked(newFile, now, currentPosition);

    if (mounted) Navigator.of(context).pop(); // ✅ Tutup loading
  }

  // create google maps URL from field
  void _openMap(double latitude, double longitude) async {
    final url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');

    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      print("❌ Tidak bisa buka URL: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget? preview;

    if (_fileData != null) {
      preview = Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // [MODIFIKASI] Tambahkan pengecekan isImage di sini
            if (isImage)
              // Jika file adalah gambar, tampilkan seperti biasa
              kIsWeb
                  ? Image.memory(
                      _fileData as Uint8List,
                      height: 160,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      File(_fileData),
                      height: 160,
                      fit: BoxFit.cover,
                    )
            else
              // ✅ Jika file adalah PDF, tampilkan preview khusus PDF
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.picture_as_pdf_rounded,
                        color: Colors.red.shade700, size: 36),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _displayController.text,
                        style: const TextStyle(
                            fontSize: 14, overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ],
                ),
              ),

            // Tampilkan metadata hanya jika file berasal dari kamera (bukan dari picker)
            if (!_isFileFromPicker)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    _dateTime != null
                        ? 'Waktu Photo : ${DateFormat('dd MMM yyyy – HH:mm').format(_dateTime!)}'
                        : '-',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  if (_photoPosition != null)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            'Lokasi : ${_photoPosition!.latitude.toStringAsFixed(6)}, ${_photoPosition!.longitude.toStringAsFixed(6)}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => _openMap(
                            _photoPosition!.latitude,
                            _photoPosition!.longitude,
                          ),
                          icon: const Icon(Icons.map, size: 14),
                          label: const Text(
                            "Lihat Maps",
                            style: TextStyle(fontSize: 12),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.only(
                                left: 4), // rapatkan ke kiri
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ],
                    ),
                ],
              )
            else
              const SizedBox.shrink(),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.index}. ',
              style: greyTextStyle.copyWith(
                fontSize: 14,
                fontWeight: semiBold,
              ),
            ),
            Flexible(
              // <<<<< Tambahkan ini
              child: Text(
                widget.label,
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
        Stack(
          alignment: Alignment.centerRight,
          children: [
            TextField(
              // textCapitalization: TextCapitalization.characters,
              enabled: false,
              controller: _displayController,
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Take a photo...',
                border: const UnderlineInputBorder(),
                contentPadding: const EdgeInsets.only(
                  left: 12,
                  right: 100,
                  top: 14,
                  bottom: 14,
                ),
              ),
              style: const TextStyle(overflow: TextOverflow.ellipsis),
            ),
            Positioned(
              right: 4,
              child: Row(
                mainAxisSize: MainAxisSize.min, // Agar tombol-tombol merapat
                children: [
                  // Tombol Kamera (yang sudah ada)
                  IconButton(
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    constraints:
                        const BoxConstraints(minWidth: 32, minHeight: 32),
                    icon: const Icon(Icons.camera_alt_rounded),
                    onPressed: _fileData == null && !_isMockLocation
                        ? _captureImage
                        : null,
                  ),
                ],
              ),
            )
          ],
        ),

        if (preview != null) preview,
        // if (preview != null) Text('Preview'),
        // if (_dateTime != null) Text('Waktu poto : ${_dateTime.toString()}'),
        // if (_photoPosition != null)
        //   Text(
        //     'Lokasi: Lat ${_photoPosition!.latitude}, Lon ${_photoPosition!.longitude}',
        //   ),
      ],
    );
  }
}
