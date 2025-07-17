import 'package:flutter/material.dart';
import 'package:gsure/models/survey_app_model.dart';
import 'package:gsure/shared/theme.dart';
import 'package:gsure/ui/pages/contoh_survey_detail_page.dart';
import 'package:gsure/ui/pages/draft_detail_page.dart';
import 'package:gsure/ui/pages/progress_detail_page.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class ProgressSurveyPage extends StatelessWidget {
  const ProgressSurveyPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final String boxName = 'survey_apps';
    final String boxName = 'survey_apps';

    return Scaffold(
      appBar: AppBar(
        title: const Text('PROGRESS SURVEY'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<AplikasiSurvey>(boxName).listenable(),
        builder: (context, Box<AplikasiSurvey> box, _) {
          // --- MODIFIKASI DI SINI ---
          // 1. Filter semua data untuk mendapatkan yang statusnya 'DRAFT'
          final List<AplikasiSurvey> draftSurveys =
              box.values.where((survey) => survey.status != 'APP').toList();
          // final List<AplikasiSurvey> draftSurveys =
          //     box.values.where((survey) => survey.status == 'DONE').toList();

          if (draftSurveys.isEmpty) {
            return Center(
              child: Text(
                'Belum ada data draft survey.',
                style: blackTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: medium,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(
                vertical: 8), // Beri sedikit padding pada list
            itemCount: draftSurveys.length,
            itemBuilder: (context, index) {
              final survey = draftSurveys[index];
              final hiveKey = survey.key;

              // Gantikan widget lama dengan kartu baru yang didesain ulang
              return DraftSurveyCard(survey: survey, hiveKey: hiveKey);
            },
          );

          // return ListView.builder(
          //   padding: const EdgeInsets.all(8),
          //   itemCount: draftSurveys.length,
          //   itemBuilder: (context, index) {
          //     // Ambil item dari list baru
          //     final survey = draftSurveys[index];
          //     // Ambil key langsung dari objek HiveObject
          //     final hiveKey = survey.key;

          //     final appId = hiveKey;
          //     final namaPemohon = survey.dataPemohon?.nama ?? 'Tanpa Nama';
          //     // Status pasti 'DRAFT', tapi bisa juga diambil dari survey.status
          //     final statusSurvey = survey.status ?? 'DRAFT';

          //     return Padding(
          //       padding: const EdgeInsets.only(bottom: 8.0),
          //       child: Material(
          //         elevation: 2,
          //         borderRadius: BorderRadius.circular(5),
          //         child: InkWell(
          //           borderRadius: BorderRadius.circular(5),
          //           child: Container(
          //             padding: const EdgeInsets.all(16),
          //             decoration: BoxDecoration(
          //               color: Colors.white,
          //               borderRadius: BorderRadius.circular(5),
          //             ),
          //             child: Row(
          //               children: [
          //                 CircleAvatar(
          //                   radius: 30,
          //                   backgroundColor: lightBackgorundColor,
          //                   child: const Icon(
          //                     Icons.library_add_check,
          //                     color: Colors.white,
          //                   ),
          //                 ),
          //                 const SizedBox(
          //                   width: 16,
          //                 ),
          //                 Expanded(
          //                   child: Column(
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     children: [
          //                       Text(
          //                         namaPemohon,
          //                         style: const TextStyle(
          //                             fontWeight: FontWeight.bold,
          //                             fontSize: 16),
          //                       ),
          //                       Text('ID: $appId '),
          //                       const SizedBox(height: 6),
          //                       Container(
          //                         padding: const EdgeInsets.symmetric(
          //                             horizontal: 10, vertical: 4),
          //                         decoration: BoxDecoration(
          //                           color: statusSurvey == 'DONE'
          //                               ? Colors.green.shade100
          //                               : Colors.orange.shade100,
          //                           borderRadius: BorderRadius.circular(5),
          //                         ),
          //                         child: Text(
          //                           statusSurvey,
          //                           style: TextStyle(
          //                             fontSize: 12,
          //                             fontWeight: FontWeight.bold,
          //                             color: statusSurvey == 'DONE'
          //                                 ? Colors.green.shade800
          //                                 : Colors.orange.shade800,
          //                           ),
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //                 IconButton(
          //                   padding: EdgeInsets.zero,
          //                   onPressed: () {
          //                     Navigator.push(
          //                       context,
          //                       // MaterialPageRoute(
          //                       //   builder: (_) =>
          //                       //       ProgressDetailPage(surveyKey: hiveKey),
          //                       // ),
          //                       MaterialPageRoute(
          //                         builder: (_) =>
          //                             DraftDetailPage(surveyKey: hiveKey),
          //                       ),
          //                     );
          //                   },
          //                   icon: const Icon(Icons.edit_square),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //     );
          //   },
          // );
        },
      ),
    );
  }
}

class DraftSurveyCard extends StatelessWidget {
  final AplikasiSurvey survey;
  final dynamic hiveKey;

  const DraftSurveyCard({
    super.key,
    required this.survey,
    required this.hiveKey,
  });

  // Fungsi bantuan untuk mendapatkan inisial dari nama
  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    List<String> names = name.split(' ');
    String initials = '';
    int numWords = names.length > 1 ? 2 : 1;
    for (var i = 0; i < numWords; i++) {
      if (names[i].isNotEmpty) {
        initials += names[i][0];
      }
    }
    return initials.toUpperCase();
  }

  // Fungsi bantuan untuk badge status 'DRAFT'
  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: status == "DRAFT"
            ? Color(0xFFFFF3E0)
            : Colors.green.shade100, // Oranye muda
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color:
                status == "DRAFT" ? Color(0xFFE65100) : Colors.green.shade800,
            width: 1),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: status == "DRAFT"
              ? Color(0xFFE65100)
              : Colors.green.shade800, // Oranye tua
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final namaPemohon = survey.dataPemohon?.nama ?? 'Tanpa Nama';
    final appId = hiveKey.toString();

    return Card(
      elevation: 2.5,
      shadowColor: Colors.black.withOpacity(0.3),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => DraftDetailPage(surveyKey: hiveKey)),
            // builder: (_) => ContohDraftDetailPage(surveyKey: hiveKey)),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar dengan Inisial
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.orange.withOpacity(0.1),
                child: Text(
                  _getInitials(namaPemohon),
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Kolom Informasi Utama
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      namaPemohon,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: $appId',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Status Badge
                    _buildStatusBadge(survey.status ?? 'DRAFT'),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Tombol Aksi
              Icon(Icons.edit_note, color: Colors.grey.shade400, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}
