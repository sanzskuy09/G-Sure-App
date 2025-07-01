// lib/question_data.dart

import 'package:flutter/material.dart';

final List<Map<String, dynamic>> questionData = [
  {
    'title': 'Informasi Pribadi',
    'fields': [
      {"type": 'text', "label": "Nama", "controller": TextEditingController()},
      {
        'type': 'email',
        "label": "Email",
        "controller": TextEditingController()
      },
      {
        "type": 'password',
        "label": "Password",
        "controller": TextEditingController()
      },
      {
        'type': 'date',
        'label': 'Tanggal Lahir',
        'value': null,
        "controller": TextEditingController()
      },
      {
        'type': 'dropdown',
        'label': 'Jenis kelamin',
        'value': null,
        'options': ['Laki-laki', 'Perempuan']
      }
    ],
  },
  {
    "title": "Alamat",
    "fields": [
      {
        "type": "text",
        "label": "Kota",
        "controller": TextEditingController(),
      },
      {
        "type": "text",
        "label": "Kode Pos",
        "controller": TextEditingController(),
      },
    ]
  },
];
