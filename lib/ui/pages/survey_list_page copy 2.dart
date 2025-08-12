import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gsure/blocs/auth/auth_bloc.dart';
import 'package:gsure/blocs/form/form_bloc.dart';
import 'package:gsure/blocs/survey/survey_bloc.dart';
import 'package:gsure/models/order_model.dart';
import 'package:gsure/models/survey_app_model.dart';
import 'package:gsure/shared/theme.dart';
import 'package:gsure/ui/pages/form_survey_page.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

class SurveyListPage extends StatelessWidget {
  const SurveyListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Buka kedua box yang dibutuhkan
    final ordersBox = Hive.box<OrderModel>('orders');
    final surveysBox = Hive.box<AplikasiSurvey>('survey_apps');

    return Scaffold(
      appBar: AppBar(
        title: const Text('LIST NEW SURVEY'),
        automaticallyImplyLeading: false,
        actions: [
          // Tambahkan tombol refresh untuk memicu sinkronisasi manual
          BlocBuilder<SurveyBloc, SurveyState>(
            builder: (context, state) {
              // Tampilkan icon loading saat sedang sinkronisasi
              if (state is LoadingListDataFromOrder) {
                return const Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  ),
                );
              }
              return IconButton(
                icon: const Icon(Icons.refresh),
                // onPressed: () {
                //   context.read<SurveyBloc>().add(GetDataSurveyFromOrder());
                // },
                onPressed: () {
                  final authState = context.read<AuthBloc>().state;
                  if (authState is AuthSuccess) {
                    final username = authState.user.username;
                    if (username != null) {
                      context
                          .read<SurveyBloc>()
                          .add(GetDataSurveyFromOrder(username));
                    }
                  }
                  // context.read<OrderBloc>().add(SyncOrdersWithAPI());
                },
              );
            },
          ),
        ],
      ),
      body: BlocListener<SurveyBloc, SurveyState>(
        listener: (context, state) {
          if (state is ListDataFromOrderSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Data berhasil diperbarui.'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is ErrorListDataFromOrder) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Gagal sinkronisasi. Menampilkan data offline.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: ValueListenableBuilder<Box<OrderModel>>(
          valueListenable: ordersBox.listenable(),
          builder: (context, box, _) {
            // 2. Buat "lookup set" dari survei yang sudah ada untuk pengecekan cepat.
            //    Kita gabungkan appId dan nik menjadi satu kunci unik.
            final Set<String> existingSurveyKeys =
                surveysBox.values.map((survey) {
              return '${survey.application_id}-${survey.nik}';
            }).toSet();

            // 3. Filter daftar order.
            //    Hanya tampilkan order yang kuncinya TIDAK ADA di dalam `existingSurveyKeys`.
            final List<OrderModel> filteredOrders = box.values.where((order) {
              final orderKey = '${order.application_id}-${order.nik}';
              return !existingSurveyKeys.contains(orderKey);
            }).toList();

            // 4. Tampilkan UI berdasarkan hasil filter
            if (filteredOrders.isEmpty) {
              return const Center(
                child: Text(
                  'Tidak ada order baru yang tersedia.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                final order = filteredOrders[index];
                // Gantikan widget lama dengan kartu baru yang lebih menarik
                return SurveyOrderCard(order: order);
              },
            );
          },
        ),
      ),
    );
  }
}

// Tambahkan widget ini di bawah class _SurveyListPageState
class SurveyOrderCard extends StatelessWidget {
  final OrderModel order;

  const SurveyOrderCard({super.key, required this.order});

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

  // Fungsi bantuan untuk membuat baris info dengan ikon
  Widget _buildInfoRow(BuildContext context,
      {required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.grey[800], fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi bantuan untuk badge status
  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD), // Biru muda
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1565C0), width: 1),
      ),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(
          color: Color(0xFF1565C0), // Biru tua
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.3),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Aksi saat kartu di-tap
          // Anda bisa pindahkan logika Navigator.push Anda ke sini
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return BlocProvider(
                  create: (context) => FormBloc(), // Asumsi ada FormBloc
                  child: FormSurveyPage(order: order),
                );
              },
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Avatar dengan Inisial
              CircleAvatar(
                radius: 30,
                backgroundColor: primaryColor.withOpacity(0.1),
                child: Text(
                  _getInitials(order.nama ?? ''),
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Kolom Informasi
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Asumsi status 'NEW' ada di model, jika tidak, bisa hardcode
                        _buildStatusBadge('NEW'),
                        const Spacer(),
                        Icon(Icons.edit_note, color: Colors.grey[400]),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      order.nama ?? 'Tanpa Nama',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Divider(color: Colors.grey[400], height: 1),
                    _buildInfoRow(
                      context,
                      icon: Icons.date_range_outlined,
                      text:
                          'ORDER : ${formatTanggal(order.created_date) ?? '-'}',
                    ),
                    _buildInfoRow(context,
                        icon: Icons.person_pin_outlined,
                        text: 'NIK : ${order.nik ?? '-'}'),
                    _buildInfoRow(context,
                        icon: Icons.location_on_outlined,
                        text: order.alamat ?? '-'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget _buildStatusBadge(String status) {
//   Color bgColor;
//   Color textColor;
//   String label;

//   switch (status) {
//     case 'NEW':
//       bgColor = Colors.green.shade100;
//       textColor = Colors.green.shade800;
//       label = 'New';
//       break;
//     case 'BERSIH':
//       bgColor = Colors.green.shade100;
//       textColor = Colors.green.shade800;
//       label = 'Success';
//       break;
//     case 'PENDING':
//       bgColor = Colors.orange.shade100;
//       textColor = Colors.orange.shade800;
//       label = 'On Progress';
//       break;
//     case 'REJECT':
//       bgColor = Colors.red.shade100;
//       textColor = Colors.red.shade800;
//       label = 'Reject';
//       break;
//     default:
//       bgColor = Colors.grey.shade200;
//       textColor = Colors.grey.shade800;
//       label = 'Unknown';
//   }

//   return Container(
//     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//     decoration: BoxDecoration(
//       color: bgColor,
//       borderRadius: BorderRadius.circular(5),
//       border: Border.all(color: const Color(0xFFE65100), width: 1),
//     ),
//     child: Text(
//       label,
//       style: TextStyle(
//         fontSize: 12,
//         fontWeight: FontWeight.bold,
//         color: textColor,
//       ),
//     ),
//   );
// }
