import 'package:flutter/material.dart';
import 'package:gsure/models/survey_data.dart';
import 'package:gsure/ui/pages/contoh_survey_detail_page.dart';
import 'package:hive_flutter/adapters.dart';

class ContohSurveyListPage extends StatelessWidget {
  const ContohSurveyListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Survey Tersimpan"),
      ),
      // Gunakan ValueListenableBuilder untuk "mendengarkan" perubahan pada Hive box
      body: ValueListenableBuilder<Box<SurveyData>>(
        // Target box yang akan didengarkan
        valueListenable: Hive.box<SurveyData>('surveys').listenable(),
        builder: (context, box, _) {
          // Ambil semua data dari box sebagai sebuah List
          final surveys = box.values.toList().cast<SurveyData>();

          // Tampilkan pesan jika tidak ada data
          if (surveys.isEmpty) {
            return const Center(
              child: Text("Belum ada data survey yang disimpan."),
            );
          }

          // Gunakan ListView.builder untuk menampilkan daftar data
          return ListView.builder(
            itemCount: surveys.length,
            itemBuilder: (context, index) {
              // Ambil satu data survey berdasarkan index-nya
              final survey = surveys[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: ListTile(
                  leading: const Icon(Icons.description, color: Colors.blue),
                  title: Text(survey.nama ?? 'Nama tidak diisi'),
                  subtitle: Text(survey.pekerjaan ?? 'Pekerjaan tidak diisi'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Logika untuk navigasi ke halaman detail
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SurveyDetailPage(survey: survey),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
