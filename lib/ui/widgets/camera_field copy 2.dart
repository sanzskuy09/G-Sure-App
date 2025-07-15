import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gsure/shared/theme.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class CameraFieldForm extends StatefulWidget {
  final int index;
  final String label;
  final dynamic value; // Menerima Map dari state utama
  final Function(dynamic, DateTime, Position?) onFilePicked;

  const CameraFieldForm({
    super.key,
    required this.index,
    required this.label,
    required this.value,
    required this.onFilePicked,
  });
  @override
  State<CameraFieldForm> createState() => _CameraFieldFormState();
}

class _CameraFieldFormState extends State<CameraFieldForm> {
  // 2. Controller LOKAL, hanya untuk tampilan di widget ini.
  late final TextEditingController _displayController;

  // State lokal untuk data yang sudah diproses
  dynamic _fileDataForPreview;
  DateTime? _dateTime;
  Position? _photoPosition;
  bool _isMockLocation = false;

  bool get isImage {
    final name = _displayController.text.toLowerCase();
    return name.endsWith('.jpg') ||
        name.endsWith('.jpeg') ||
        name.endsWith('.png');
  }

  @override
  void initState() {
    super.initState();
    _displayController = TextEditingController();
    _processInitialValue();
    _checkFakeGPS();
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

  // 3. Logika untuk memproses 'value' dari parent saat widget pertama kali dibuat
  void _processInitialValue() {
    if (widget.value != null && widget.value is Map) {
      final initialData = widget.value as Map;
      final file = initialData['file'];

      if (file != null) {
        // Asumsikan 'file' adalah object File, ambil path-nya
        if (file is File) {
          _fileDataForPreview = file.path;
          _displayController.text = file.path.split('/').last;
        } else if (file is String) {
          // Fallback jika ternyata path
          _fileDataForPreview = file;
          _displayController.text = file.split('/').last;
        }
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
    } else if (widget.value != null) {
      // Fallback jika value hanya String
      _fileDataForPreview = widget.value;
      _displayController.text = widget.value.toString().split('/').last;
    }
  }

  @override
  void dispose() {
    _displayController.dispose();
    super.dispose();
  }

  void _captureImage() async {
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
      currentPosition = await Geolocator.getCurrentPosition(
          timeLimit: const Duration(seconds: 5));
    } catch (e) {
      currentPosition = null;
    }

    final capturedFile = File(pickedFile.path); // Buat objek File

    if (!mounted) return;

    setState(() {
      _fileDataForPreview = capturedFile.path;
      _dateTime = now;
      _photoPosition = currentPosition;
      _displayController.text =
          '${widget.label}_${DateFormat('yyyyMMdd_HHmmss').format(now)}.jpg';
    });

    // Kirim OBJEK FILE-nya, bukan path-nya
    widget.onFilePicked(capturedFile, now, currentPosition);

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
    if (_fileDataForPreview != null) {
      preview = Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            kIsWeb
                ? Image.memory(
                    _fileDataForPreview as Uint8List,
                    height: 160,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    File(_fileDataForPreview),
                    height: 160,
                    fit: BoxFit.cover,
                  ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _dateTime != null
                      ? 'Waktu Photo : ${DateFormat('dd MMM yyyy – HH:mm').format(_dateTime!)}'
                      : '-',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4), // Jarak antar baris
                if (_photoPosition != null)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          'Lokasi : ${_photoPosition!.latitude.toStringAsFixed(6)}, ${_photoPosition!.longitude.toStringAsFixed(6)}',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
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
                // if (widget.latitude != null && widget.longitude != null)
                //   Row(
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       Expanded(
                //         child: Text(
                //           'Lokasi : ${widget.latitude!.toStringAsFixed(6)}, ${widget.longitude!.toStringAsFixed(6)}',
                //           style:
                //               const TextStyle(fontSize: 12, color: Colors.grey),
                //           overflow: TextOverflow.ellipsis,
                //         ),
                //       ),
                //       TextButton.icon(
                //         onPressed: () => _openMap(
                //           widget.latitude!,
                //           widget.longitude!,
                //         ),
                //         icon: const Icon(Icons.map, size: 14),
                //         label: const Text(
                //           "Lihat Maps",
                //           style: TextStyle(fontSize: 12),
                //         ),
                //         style: TextButton.styleFrom(
                //           padding: const EdgeInsets.only(
                //               left: 4), // rapatkan ke kiri
                //           minimumSize: Size.zero,
                //           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                //         ),
                //       ),
                //     ],
                //   ),
              ],
            ),
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
                  right: 48,
                  top: 14,
                  bottom: 14,
                ),
              ),
              style: const TextStyle(overflow: TextOverflow.ellipsis),
            ),
            Positioned(
              right: 4,
              child: IconButton(
                icon: const Icon(Icons.camera_alt_rounded),
                // onPressed: widget.enabled == true ? _pickFile : null,
                onPressed: _fileDataForPreview == null && !_isMockLocation
                    ? _captureImage
                    : null,
              ),
            ),
          ],
        ),
        if (preview != null) preview,
      ],
    );
  }
}
