import 'package:flutter/material.dart';
import 'package:gsure/shared/theme.dart';
import 'package:gsure/ui/pages/not_found_page.dart';

class LogPage extends StatelessWidget {
  const LogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log'),
      ),
      // body: Center(child: Image.asset('assets/ic_empty.png')),
      body: ListView(
        children: List.generate(2, (index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(5),
              child: InkWell(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        // atau Flexible
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                'Form Survey CF',
                                style: whiteTextStyle.copyWith(
                                  fontSize: 10,
                                  fontWeight: semiBold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'SVY2509676JHHSD',
                              style: secondaryTextStyle.copyWith(
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'MUSYAFFA NUR IHSANUDDIN ',
                              style: blackTextStyle.copyWith(
                                fontSize: 16,
                                fontWeight: semiBold,
                              ),
                              overflow: TextOverflow.visible,
                              softWrap: true,
                              maxLines: 2,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '25/10/2022 10:00',
                              style: greyTextStyle.copyWith(
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.pushNamed(context, '/log-detail');
                        },
                        icon: const Icon(Icons.remove_red_eye_rounded),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
