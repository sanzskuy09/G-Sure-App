import 'package:flutter/material.dart';

class FieldModel {
  final String type;
  final String label;
  final List<String>? options;
  final List<Map<String, dynamic>>? section;
  late TextEditingController controller;
  dynamic value;
  DateTime? timestamp;
  double? latitude;
  double? longitude;

  FieldModel({
    required this.type,
    required this.label,
    this.options,
    this.section,
    this.value,
    this.timestamp,
    this.latitude,
    this.longitude,
  }) {
    controller = TextEditingController();
  }

  factory FieldModel.fromJson(Map<String, dynamic> json) {
    return FieldModel(
      type: json['type'],
      label: json['label'],
      timestamp: json['timestamp'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      options: (json['options'] as List?)?.cast<String>(),
      section: (json['section'] as List?)?.cast<Map<String, dynamic>>(),
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'label': label,
        'timestamp': timestamp,
        'latitude': latitude,
        'longitude': longitude,
        'options': options,
        'section': section,
        'value': value,
      };
}

class QuestionSection {
  final String title;
  final List<FieldModel> fields;
  final Map<String, List<String>>? showIf;

  QuestionSection({
    required this.title,
    required this.fields,
    this.showIf,
  });

  factory QuestionSection.fromJson(Map<String, dynamic> json) {
    return QuestionSection(
      title: json['title'],
      fields:
          (json['fields'] as List).map((f) => FieldModel.fromJson(f)).toList(),
      showIf: (json['showIf'] as Map?)?.map(
        (key, value) => MapEntry(key.toString(), List<String>.from(value)),
      ),
    );
  }
}
