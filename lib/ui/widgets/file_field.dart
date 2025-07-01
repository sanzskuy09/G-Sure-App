import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gsure/shared/theme.dart';

class FileFieldWidget extends StatefulWidget {
  final bool enabled;
  final int index;
  final String label;
  final TextEditingController controller;
  final dynamic value; // dari field.value (persisted)
  final Function(dynamic) onFilePicked;

  const FileFieldWidget({
    super.key,
    required this.index,
    required this.label,
    required this.controller,
    required this.value,
    required this.onFilePicked,
    this.enabled = true,
  });

  @override
  State<FileFieldWidget> createState() => _FileFieldWidgetState();
}

class _FileFieldWidgetState extends State<FileFieldWidget> {
  dynamic _localValue;
  Position? _photoPosition;
  DateTime? _datetime;

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
  }

  @override
  void didUpdateWidget(FileFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync ulang jika parent mengubah value
    if (widget.value != oldWidget.value) {
      _localValue = widget.value;
    }
  }

  Future<void> _pickFile() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    print('serviceEnabled: $serviceEnabled');

    LocationPermission permission = await Geolocator.checkPermission();
    // if (!serviceEnabled || permission == LocationPermission.denied) {
    //   permission = await Geolocator.requestPermission();
    // }

    Position? position;
    if (serviceEnabled || permission == LocationPermission.whileInUse) {
      position = await Geolocator.getCurrentPosition();
    }

    final now = DateTime.now();

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      final fileData = kIsWeb ? file.bytes : file.path;
      setState(() {
        _localValue = fileData;
        widget.controller.text = file.name;
        _photoPosition = position;
        _datetime = now;
      });
      widget.onFilePicked(fileData); // Kirim balik ke parent
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget? preview;
    if (_localValue != null && isImage) {
      preview = Padding(
        padding: const EdgeInsets.only(top: 12),
        child: kIsWeb
            ? Image.memory(_localValue as Uint8List,
                height: 160, fit: BoxFit.cover)
            : Image.file(File(_localValue), height: 160, fit: BoxFit.cover),
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
                hintText: 'Pilih file...',
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
                icon: const Icon(Icons.attach_file),
                // onPressed: widget.enabled == true ? _pickFile : null,
                onPressed: _localValue == null ? _pickFile : null,
              ),
            ),
          ],
        ),
        if (preview != null) preview,
        if (_datetime != null) Text('Waktu poto : ${_datetime.toString()}'),
        if (_photoPosition != null)
          Text(
            'Lokasi: Lat ${_photoPosition!.latitude}, Lon ${_photoPosition!.longitude}',
          ),
      ],
    );
  }
}
