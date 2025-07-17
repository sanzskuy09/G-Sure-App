import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gsure/blocs/auth/auth_bloc.dart';
import 'package:gsure/blocs/form/form_bloc.dart';
import 'package:gsure/blocs/survey/survey_bloc.dart';
import 'package:gsure/models/order_model.dart';
import 'package:gsure/shared/theme.dart';
import 'package:gsure/ui/pages/form_survey_page.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class SurveyListPage extends StatelessWidget {
  const SurveyListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<OrderModel>('orders');

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
        child: ValueListenableBuilder(
          valueListenable: box.listenable(),
          builder: (context, Box<OrderModel> box, _) {
            final orders = box.values.toList(); // Ambil semua data sebagai list

            if (orders.isEmpty) {
              // Jika box kosong, cek state BLoC
              return BlocBuilder<SurveyBloc, SurveyState>(
                builder: (context, state) {
                  // Tampilkan loading besar jika sedang sinkronisasi pertama kali
                  if (state is LoadingListDataFromOrder) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // Tampilkan pesan jika tidak ada data sama sekali
                  return const Center(child: Text('Belum ada data survey.'));
                },
              );
            }

            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                // Gantikan widget lama dengan kartu baru yang lebih menarik
                return SurveyOrderCard(order: order);
              },
            );
            // UI ListView Anda yang sudah ada, gunakan `orders` dari hive
            // return ListView.builder(
            //   itemCount: orders.length,
            //   itemBuilder: (context, index) {
            //     final order = orders[index];
            //     return Padding(
            //       padding:
            //           const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            //       child: Material(
            //         elevation: 2,
            //         borderRadius: BorderRadius.circular(5),
            //         child: InkWell(
            //           onTap: () {
            //             // Navigator.push(
            //             //   context,
            //             //   MaterialPageRoute(
            //             //     builder: (context) =>
            //             //         DetailProgressPage(order: order),
            //             //   ),
            //             // );
            //           },
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
            //                       Row(
            //                         crossAxisAlignment:
            //                             CrossAxisAlignment.start,
            //                         children: [
            //                           _buildStatusBadge('NEW'),
            //                           const SizedBox(width: 8),
            //                           Expanded(
            //                             child: Text(
            //                               order.nama ?? 'Tanpa Nama',
            //                               style: const TextStyle(
            //                                 fontWeight: FontWeight.bold,
            //                                 fontSize: 16,
            //                               ),
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                       const SizedBox(height: 4),
            //                       Text('NIK: ${order.nik ?? '-'}'),
            //                       Text('ID: ${order.application_id ?? '-'}'),
            //                       Text('Alamat: ${order.alamat ?? '-'}',
            //                           maxLines: 1,
            //                           overflow: TextOverflow.ellipsis),
            //                     ],
            //                   ),
            //                 ),
            //                 IconButton(
            //                   onPressed: () {
            //                     // Navigator.push(
            //                     //   context,
            //                     //   MaterialPageRoute(
            //                     //     builder: (context) =>
            //                     //         FormSurveyPage(order: order),
            //                     //   ),
            //                     // );
            //                     Navigator.push(
            //                       context,
            //                       MaterialPageRoute(
            //                         builder: (context) {
            //                           // BENAR: Bungkus halaman Anda dengan BlocProvider di sini
            //                           return BlocProvider(
            //                             create: (context) => FormBloc(),
            //                             child: FormSurveyPage(order: order),
            //                           );
            //                         },
            //                       ),
            //                     );
            //                   },
            //                   // icon: const Icon(Icons.remove_red_eye_rounded),
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
      padding: const EdgeInsets.only(top: 8.0),
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
    return Card(
      elevation: 4,
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
                    _buildInfoRow(context,
                        icon: Icons.person_pin_outlined,
                        text: 'NIK: ${order.nik ?? '-'}'),
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
