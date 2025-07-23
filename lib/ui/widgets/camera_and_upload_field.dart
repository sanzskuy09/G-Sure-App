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
import 'package:flutter_image_compress/flutter_image_compress.dart';

class CameraAndUploadFieldForm extends StatefulWidget {
  final int index;
  final String? fieldKey;
  final String label;
  final dynamic value; // Ini akan menerima Map dari formAnswers
  final Function(dynamic, DateTime, Position?) onFilePicked;

  const CameraAndUploadFieldForm({
    super.key,
    required this.index,
    required this.label,
    this.fieldKey,
    required this.value,
    required this.onFilePicked,
  });

  @override
  State<CameraAndUploadFieldForm> createState() =>
      _CameraAndUploadFieldFormState();
}

class _CameraAndUploadFieldFormState extends State<CameraAndUploadFieldForm> {
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

  void _showImageDialog(BuildContext context, dynamic fileData) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Hero(
                // Match the tag from the preview
                tag: 'imagePreview_${widget.fieldKey ?? widget.index}',
                child: InteractiveViewer(
                  panEnabled: true,
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: kIsWeb
                      ? Image.memory(fileData as Uint8List)
                      : Image.file(File(fileData as String)),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded,
                      color: Colors.white, size: 30),
                  tooltip: 'Close',
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<File> _copyFileToAppDir(File sourceFile, String newFileName) async {
    final appDir = await getApplicationDocumentsDirectory();
    final newPath = p.join(appDir.path, newFileName);
    return await sourceFile.copy(newPath);
  }

  Future<File?> _compressImage(File file, {int targetSizeInMB = 1}) async {
    final int targetSizeInBytes = targetSizeInMB * 1024 * 1024;
    final initialSize = await file.length();

    // Jika ukuran file sudah di bawah target, langsung kembalikan file asli
    if (initialSize <= targetSizeInBytes) {
      print(
          'Ukuran file asli (${(initialSize / 1024).toStringAsFixed(2)} KB) sudah di bawah target.');
      return file;
    }

    // Siapkan path untuk file hasil kompresi
    final tempDir = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final targetPath = p.join(tempDir.path, '${timestamp}_compressed.jpg');

    int quality = 85; // Mulai dengan kualitas 85%

    // Kompres file
    XFile? compressedXFile = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: quality,
    );

    if (compressedXFile == null) {
      print('Kompresi gagal.');
      return null; // Gagal kompresi
    }

    // Cek ukuran hasil kompresi, jika masih terlalu besar, kurangi kualitas
    // (Looping sederhana untuk menurunkan kualitas jika perlu)
    int compressedSize = await compressedXFile.length();
    while (compressedSize > targetSizeInBytes && quality > 10) {
      quality -= 5; // Kurangi kualitas
      compressedXFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: quality,
      );
      if (compressedXFile == null) break;
      compressedSize = await compressedXFile.length();
    }

    print(
        'Kompresi selesai. Ukuran: ${(initialSize / 1024).toStringAsFixed(2)} KB -> ${(compressedSize / 1024).toStringAsFixed(2)} KB');

    return File(compressedXFile!.path);
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

  // void _processInitialValue() {
  //   // Jika value dari parent adalah Map (sesuai desain kita)
  //   if (widget.value != null && widget.value is Map) {
  //     final initialData = widget.value as Map;
  //     final file = initialData['file'];

  //     if (file != null) {
  //       if (file is File) {
  //         _fileData = file.path;
  //         _displayController.text = file.path.split('/').last;
  //       } else if (file is String) {
  //         _fileData = file;
  //         _displayController.text = file.split('/').last;
  //       }
  //     }

  //     _dateTime = initialData['timestamp'];
  //     final lat = initialData['latitude'] as double?;
  //     final lon = initialData['longitude'] as double?;
  //     if (lat != null && lon != null) {
  //       _photoPosition = Position(
  //           latitude: lat,
  //           longitude: lon,
  //           timestamp: DateTime.now(),
  //           accuracy: 0,
  //           altitude: 0,
  //           altitudeAccuracy: 0,
  //           heading: 0,
  //           headingAccuracy: 0,
  //           speed: 0,
  //           speedAccuracy: 0);
  //     }
  //   }
  //   // Fallback jika value hanya String
  //   else if (widget.value != null) {
  //     _fileData = widget.value;
  //     _displayController.text = widget.value.toString().split('/').last;

  //     print('_fileData');
  //     print(_fileData);
  //     print('===============================');
  //     print('_displayController');
  //     print(_displayController);
  //   }
  // }

  @override
  void dispose() {
    // 4. Jangan lupa dispose controller lokal
    _displayController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      final originalFile = File(result.files.first.path!);
      final now = DateTime.now();

      // ✅ LOGIKA BARU UNTUK NAMA FILE UNIK
      final extension = result.files.first.name.split('.').last;
      final timestamp = now.millisecondsSinceEpoch;
      final newFileName = '${widget.fieldKey ?? 'file'}_$timestamp.$extension';

      // Salin file dengan nama baru
      final newFile = await _copyFileToAppDir(originalFile, newFileName);
      if (!mounted) return;

      // Gunakan file dan nama baru untuk state & callback
      setState(() {
        _fileData = newFile.path;
        _displayController.text = newFileName;
        _isFileFromPicker = true;
        _dateTime = now; // Set waktu saat file dipilih
        _photoPosition = null; // Tidak ada data lokasi
      });

      widget.onFilePicked(newFile, now, null);
    }
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 60,
    );

    if (pickedFile == null) return;

    final originalFile = File(pickedFile.path);
    final now = DateTime.now();

    // ✅ LOGIKA BARU UNTUK NAMA FILE UNIK
    final extension = originalFile.path.split('.').last;
    final timestamp = now.millisecondsSinceEpoch;
    final newFileName = '${widget.fieldKey ?? 'gallery'}_$timestamp.$extension';

    // Salin file dengan nama baru
    final newFile = await _copyFileToAppDir(originalFile, newFileName);
    if (!mounted) return;

    // Gunakan file dan nama baru untuk state & callback
    setState(() {
      _fileData = newFile.path;
      _dateTime = now;
      _photoPosition = null;
      _isFileFromPicker = true;
      _displayController.text = newFileName;
    });

    widget.onFilePicked(newFile, now, null);
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

    final originalFile = File(pickedFile.path);

    // ✅ PANGGIL FUNGSI KOMPRESI DI SINI
    final compressedFile =
        await _compressImage(originalFile, targetSizeInMB: 1);

    // Jika kompresi gagal, hentikan proses
    if (compressedFile == null) {
      if (mounted) Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal memproses gambar.")));
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

    final newFileName =
        '${widget.fieldKey ?? 'camera_image'}_${now.millisecondsSinceEpoch}.jpg';

    // ✅ GUNAKAN FILE HASIL KOMPRESI UNTUK DISALIN
    final newFile = await _copyFileToAppDir(compressedFile, newFileName);

    if (!mounted) return;

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
              GestureDetector(
                onTap: () {
                  if (_fileData != null) {
                    _showImageDialog(context, _fileData);
                  }
                },
                child: Hero(
                  tag: 'imagePreview_${widget.fieldKey ?? widget.index}',
                  child: kIsWeb
                      ? Image.memory(
                          _fileData as Uint8List,
                          height: 160,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(_fileData),
                          height: 160,
                          fit: BoxFit.cover,
                        ),
                ),
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
                hintText: 'Upload or Take a photo...',
                border: const UnderlineInputBorder(),
                contentPadding: const EdgeInsets.only(
                  left: 12,
                  right: 120,
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
                  // [BARU] Tombol untuk membuka Galeri
                  IconButton(
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    constraints:
                        const BoxConstraints(minWidth: 32, minHeight: 32),
                    icon: const Icon(Icons.photo_library_rounded),
                    onPressed: _pickFromGallery,
                    // onPressed: _fileData == null ? _pickFromGallery : null,
                  ),

                  // Tombol Attach File (yang sudah ada)
                  IconButton(
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    constraints:
                        const BoxConstraints(minWidth: 32, minHeight: 32),
                    icon: const Icon(Icons.attach_file),
                    onPressed: _pickFile,
                    // onPressed: _fileData == null ? _pickFile : null,
                  ),

                  // Tombol Kamera (yang sudah ada)
                  IconButton(
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      constraints:
                          const BoxConstraints(minWidth: 32, minHeight: 32),
                      icon: const Icon(Icons.camera_alt_rounded),
                      onPressed: _captureImage
                      // onPressed: _fileData == null && !_isMockLocation
                      //     ? _captureImage
                      //     : null,
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
