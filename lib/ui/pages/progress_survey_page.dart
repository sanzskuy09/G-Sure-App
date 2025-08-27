import 'package:flutter/material.dart';
import 'package:gsure/models/survey_app_model.dart';
import 'package:gsure/shared/theme.dart';
import 'package:gsure/ui/pages/contoh_survey_detail_page.dart';
import 'package:gsure/ui/pages/draft_detail_page.dart';
import 'package:gsure/ui/pages/progress_detail_page.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

class ProgressSurveyPage extends StatefulWidget {
  const ProgressSurveyPage({super.key});

  @override
  State<ProgressSurveyPage> createState() => _ProgressSurveyPageState();
}

class _ProgressSurveyPageState extends State<ProgressSurveyPage> {
  // LANGKAH 2: Tambahkan state untuk mengelola UI dan query pencarian
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    // Listener untuk memperbarui UI saat pengguna mengetik
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    // Jangan lupa dispose controller
    _searchController.dispose();
    super.dispose();
  }

  AppBar _buildAppBar(BuildContext context) {
    if (_isSearching) {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _isSearching = false;
              _searchController.clear();
            });
          },
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Cari berdasarkan nama...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => _searchController.clear(),
          ),
        ],
      );
    } else {
      return AppBar(
        title: const Text('PROGRESS SURVEY'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = true;
              });
            },
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // final String boxName = 'survey_apps';
    final String boxName = 'survey_apps';

    return Scaffold(
      appBar: _buildAppBar(context),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<AplikasiSurvey>(boxName).listenable(),
        builder: (context, Box<AplikasiSurvey> box, _) {
          List<AplikasiSurvey> draftSurveys =
              box.values.where((survey) => survey.status != 'APP').toList();

          if (_searchQuery.isNotEmpty) {
            draftSurveys = draftSurveys.where((order) {
              final orderName = order.dataPemohon!.nama?.toLowerCase() ?? '';
              final query = _searchQuery.toLowerCase();
              return orderName.contains(query);
            }).toList();
          }

          if (draftSurveys.isEmpty) {
            return Center(
              child: Text(
                _searchQuery.isNotEmpty
                    ? 'Nama "$_searchQuery" tidak ditemukan.'
                    : 'Belum ada data draft survey.',
                style: blackTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: medium,
                ),
              ),
            );
          }

          draftSurveys.sort((a, b) {
            final dateA =
                DateTime.tryParse(a.created_date ?? '') ?? DateTime(1900);
            final dateB =
                DateTime.tryParse(b.created_date ?? '') ?? DateTime(1900);
            return dateB.compareTo(dateA); // descending (baru duluan)
          });

          return ListView.builder(
            padding: const EdgeInsets.symmetric(
                vertical: 8), // Beri sedikit padding pada list
            itemCount: draftSurveys.length,
            itemBuilder: (context, index) {
              final survey = draftSurveys[index];
              final hiveKey = survey.key;

              return DraftSurveyCard(survey: survey, hiveKey: hiveKey);
            },
          );
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

    String formatTanggal(String? isoDate) {
      if (isoDate == null) return '-';
      try {
        final date = DateTime.parse(isoDate);
        final formatter = DateFormat("d MMMM yyyy", "id_ID");
        return formatter.format(date);
      } catch (e) {
        return '-';
      }
    }

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
              builder: (_) => DraftDetailPage(surveyKey: hiveKey),
            ),
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
                    Text(
                      'NIK: ${survey.nik ?? '-'}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      'UPDATE: ${formatTanggal(survey.created_date) ?? '-'}',
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
