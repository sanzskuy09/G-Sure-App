import 'package:flutter/material.dart';
import 'package:gsure/shared/theme.dart';

class SurveyListPage extends StatelessWidget {
  const SurveyListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SURVEY LIST'),
        automaticallyImplyLeading: false,
      ),
      // body: const Center(child: Text('Belum ada data Survey.')),
      body: ListView(
        children: List.generate(
          2,
          (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                                'Ihsan',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text('NIK: 2020123456789'),
                              Text('Alamat: Jakarta'),
                              const SizedBox(height: 6),
                              _buildStatusBadge('pending'),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/survey-form');
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
          // children: [
          //   Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          //     child: Material(
          //       elevation: 2,
          //       borderRadius: BorderRadius.circular(5),
          //       child: InkWell(
          //         borderRadius: BorderRadius.circular(5),
          //         child: Container(
          //           padding: const EdgeInsets.all(16),
          //           decoration: BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: BorderRadius.circular(5),
          //           ),
          //           child: Row(
          //             children: [
          //               CircleAvatar(
          //                 radius: 30,
          //                 backgroundColor: lightBackgorundColor,
          //                 child: const Icon(
          //                   Icons.library_add_check,
          //                   color: Colors.white,
          //                 ),
          //               ),
          //               const SizedBox(
          //                 width: 16,
          //               ),
          //               Expanded(
          //                 child: Column(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     Text(
          //                       'Ihsan',
          //                       style: const TextStyle(
          //                         fontWeight: FontWeight.bold,
          //                         fontSize: 16,
          //                       ),
          //                     ),
          //                     const SizedBox(height: 4),
          //                     Text('NIK: 2020123456789'),
          //                     Text('Alamat: Jkaarta'),
          //                     const SizedBox(height: 6),
          //                     _buildStatusBadge('selesai'),
          //                   ],
          //                 ),
          //               ),
          //               IconButton(
          //                 onPressed: () {
          //                   Navigator.pushNamed(context, '/survey-form');
          //                 },
          //                 icon: const Icon(Icons.remove_red_eye_rounded),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status.toLowerCase()) {
      case 'selesai':
        bgColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        label = 'Success';
        break;
      case 'pending':
        bgColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        label = 'On Progress';
        break;
      case 'batal':
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
}
