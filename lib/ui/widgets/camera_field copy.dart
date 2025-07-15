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
  final TextEditingController controller;
  final dynamic value;
  final DateTime? timestamp;
  final double? latitude;
  final double? longitude;
  final Function(dynamic, DateTime, Position?) onFilePicked;

  const CameraFieldForm({
    super.key,
    required this.index,
    required this.label,
    required this.controller,
    required this.value,
    required this.onFilePicked,
    this.timestamp,
    this.latitude,
    this.longitude,
  });

  @override
  State<CameraFieldForm> createState() => _CameraFieldFormState();
}

class _CameraFieldFormState extends State<CameraFieldForm> {
  dynamic _localValue;
  bool _isMockLocation = false;
  DateTime? _dateTime;
  Position? _photoPosition;
  double? latitude = 0.0, longitude = 0.0;

  bool get isImage {
    final name = widget.controller.text.toLowerCase();
    return name.endsWith('.jpg') ||
        name.endsWith('.jpeg') ||
        name.endsWith('.png');
  }

  @override
  void initState() {
    super.initState();
    _localValue = widget.value;
    _dateTime = widget.timestamp;
    // latitude = widget.latitude;
    // longitude = widget.longitude;
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
      currentPosition = await Geolocator.getLastKnownPosition();
      currentPosition ??= await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        timeLimit: const Duration(seconds: 5),
      );
    } catch (e) {
      currentPosition = null;
    }

    final fileData = kIsWeb ? await pickedFile.readAsBytes() : pickedFile.path;

    if (!mounted) return;

    setState(() {
      _localValue = fileData;
      _dateTime = now;
      _photoPosition = currentPosition;
      widget.controller.text =
          '${widget.label}_${now.year}${now.month}${now.day}_${now.hour}${now.minute}${now.second}.jpg';
    });

    widget.onFilePicked(fileData, now, currentPosition);

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
    if (_localValue != null) {
      preview = Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            kIsWeb
                ? Image.memory(
                    _localValue as Uint8List,
                    height: 160,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    File(_localValue),
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
                if (widget.latitude != null && widget.longitude != null)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          'Lokasi : ${widget.latitude!.toStringAsFixed(6)}, ${widget.longitude!.toStringAsFixed(6)}',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => _openMap(
                          widget.latitude!,
                          widget.longitude!,
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
              controller: widget.controller,
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
                onPressed: _localValue == null && !_isMockLocation
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
