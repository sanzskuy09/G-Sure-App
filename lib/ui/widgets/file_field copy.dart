import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gsure/shared/theme.dart';

class FileFieldWidget extends StatelessWidget {
  final int index;
  final String label;
  final TextEditingController controller;
  final dynamic value;
  final Function(dynamic) onFilePicked;

  const FileFieldWidget({
    super.key,
    required this.index,
    required this.label,
    required this.controller,
    required this.value,
    required this.onFilePicked,
  });

  bool get isImage {
    final name = controller.text.toLowerCase();
    return name.endsWith('.jpg') ||
        name.endsWith('.jpeg') ||
        name.endsWith('.png');
  }

  @override
  Widget build(BuildContext context) {
    Widget? preview;

    if (value != null && isImage) {
      print("Preview akan ditampilkan");
      preview = Padding(
        padding: const EdgeInsets.only(top: 12),
        child: kIsWeb
            ? Image.memory(value as Uint8List, height: 160, fit: BoxFit.cover)
            : Image.file(File(value), height: 160, fit: BoxFit.cover),
      );
    }

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
              // <<<<< Tambahkan ini
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
        Stack(
          alignment: Alignment.centerRight,
          children: [
            TextField(
              controller: controller,
              readOnly: true,
              maxLines: 1,
              textAlignVertical: TextAlignVertical.center,
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
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
                    withData: true,
                  );
                  if (result != null && result.files.isNotEmpty) {
                    final file = result.files.first;

                    print('Picked file: ${file.name}');
                    print('Is web: $kIsWeb');
                    controller.text = file.name;
                    onFilePicked(kIsWeb ? file.bytes : file.path);
                  }
                },
              ),
            ),
          ],
        ),
        if (preview != null) preview,
      ],
    );
  }
}
