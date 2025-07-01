import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        title: const Text('SURVEY LIST'),
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
                onPressed: () {
                  context.read<SurveyBloc>().add(GetDataSurveyFromOrder());
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

            // UI ListView Anda yang sudah ada, gunakan `orders` dari hive
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(5),
                    child: InkWell(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) =>
                        //         DetailProgressPage(order: order),
                        //   ),
                        // );
                      },
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
                                    order.nama ?? 'Tanpa Nama',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  const SizedBox(height: 4),
                                  Text('NIK: ${order.nik ?? '-'}'),
                                  Text('Alamat: ${order.alamat ?? '-'}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 6),
                                  _buildStatusBadge(order.statusslik!),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        FormSurveyPage(order: order),
                                  ),
                                );
                              },
                              // icon: const Icon(Icons.remove_red_eye_rounded),
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
      ),
    );
  }

  // return Scaffold(
  //   appBar: AppBar(
  //     title: const Text('SURVEY LIST'),
  //     automaticallyImplyLeading: false,
  //   ),
  //   body: ListView(
  //     children: List.generate(
  //       2,
  //       (index) {
  //         return Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //           child: Material(
  //             elevation: 2,
  //             borderRadius: BorderRadius.circular(5),
  //             child: InkWell(
  //               borderRadius: BorderRadius.circular(5),
  //               child: Container(
  //                 padding: const EdgeInsets.all(16),
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(5),
  //                 ),
  //                 child: Row(
  //                   children: [
  //                     CircleAvatar(
  //                       radius: 30,
  //                       backgroundColor: lightBackgorundColor,
  //                       child: const Icon(
  //                         Icons.library_add_check,
  //                         color: Colors.white,
  //                       ),
  //                     ),
  //                     const SizedBox(
  //                       width: 16,
  //                     ),
  //                     Expanded(
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(
  //                             'Ihsan',
  //                             style: const TextStyle(
  //                               fontWeight: FontWeight.bold,
  //                               fontSize: 16,
  //                             ),
  //                           ),
  //                           const SizedBox(height: 4),
  //                           Text('NIK: 2020123456789'),
  //                           Text('Alamat: Jakarta'),
  //                           const SizedBox(height: 6),
  //                           _buildStatusBadge('pending'),
  //                         ],
  //                       ),
  //                     ),
  //                     IconButton(
  //                       onPressed: () {
  //                         Navigator.pushNamed(context, '/survey-form');
  //                       },
  //                       // icon: const Icon(Icons.remove_red_eye_rounded),
  //                       icon: const Icon(Icons.edit_square),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   ),
  // );
}

Widget _buildStatusBadge(String status) {
  Color bgColor;
  Color textColor;
  String label;

  switch (status) {
    case 'BERSIH':
      bgColor = Colors.green.shade100;
      textColor = Colors.green.shade800;
      label = 'Success';
      break;
    case 'PENDING':
      bgColor = Colors.orange.shade100;
      textColor = Colors.orange.shade800;
      label = 'On Progress';
      break;
    case 'REJECT':
      bgColor = Colors.red.shade100;
      textColor = Colors.red.shade800;
      label = 'Reject';
      break;
    default:
      bgColor = Colors.grey.shade200;
      textColor = Colors.grey.shade800;
      label = 'Unknown';
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(5),
    ),
    child: Text(
      label,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    ),
  );
}
