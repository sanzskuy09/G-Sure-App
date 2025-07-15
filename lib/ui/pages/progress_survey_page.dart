import 'package:flutter/material.dart';
import 'package:gsure/models/survey_app_model.dart';
import 'package:gsure/shared/theme.dart';
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
              box.values.where((survey) => survey.status == 'DRAFT').toList();

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
            padding: const EdgeInsets.all(8),
            itemCount: draftSurveys.length,
            itemBuilder: (context, index) {
              // Ambil item dari list baru
              final survey = draftSurveys[index];
              // Ambil key langsung dari objek HiveObject
              final hiveKey = survey.key;

              final appId = hiveKey;
              final namaPemohon = survey.dataPemohon?.nama ?? 'Tanpa Nama';
              // Status pasti 'DRAFT', tapi bisa juga diambil dari survey.status
              final statusSurvey = survey.status ?? 'DRAFT';

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(5),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: lightBackgorundColor,
                            child: const Icon(
                              Icons.library_add_check,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  namaPemohon,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text('ID: $appId '),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: statusSurvey == 'DONE'
                                        ? Colors.green.shade100
                                        : Colors.orange.shade100,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    statusSurvey,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: statusSurvey == 'DONE'
                                          ? Colors.green.shade800
                                          : Colors.orange.shade800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Navigator.push(
                                context,
                                // MaterialPageRoute(
                                //   builder: (_) =>
                                //       ProgressDetailPage(surveyKey: hiveKey),
                                // ),
                                MaterialPageRoute(
                                  builder: (_) =>
                                      DraftDetailPage(surveyKey: hiveKey),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit_square),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
