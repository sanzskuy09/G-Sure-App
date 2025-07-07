import 'package:flutter/material.dart';
import 'package:gsure/models/survey_app_model.dart';
import 'package:gsure/shared/theme.dart';
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
              if (box.values.isEmpty) {
                return Center(
                  child: Text(
                    'Belum ada data survey yang disimpan.',
                    style: blackTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: medium,
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: box.length,
                itemBuilder: (context, index) {
                  final survey = box.getAt(index);

                  // Mengambil data spesifik dengan null safety
                  final idSurvey = survey?.id ?? 'tidka ada id survey';
                  final kodeDealer =
                      survey?.dataDealer?.kddealer ?? 'Kode Empty';
                  final namadealer =
                      survey?.dataDealer?.namadealer ?? 'Nama tidak tersedia';
                  final tipeKendaraan =
                      survey?.dataKendaraan?.typekendaraan ?? '';
                  final analisacmo = survey?.analisacmo ?? '';

                  final hiveKey = box.keyAt(index);

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        child: Text(
                          namadealer.isNotEmpty
                              ? namadealer[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800),
                        ),
                      ),
                      title: Text(
                        namadealer,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('$hiveKey'),
                      trailing:
                          const Icon(Icons.chevron_right, color: Colors.grey),
                      onTap: () {
                        print('Tapped on survey with key: $survey');
                        print('Tapped on survey with key: $hiveKey');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ProgressDetailPage(surveyKey: hiveKey),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }));
  }
}
