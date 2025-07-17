import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gsure/blocs/auth/auth_bloc.dart';
import 'package:gsure/models/survey_app_model.dart';
import 'package:gsure/shared/theme.dart';
import 'package:gsure/ui/widgets/task_list.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    /// Scroll ke atas saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(0); // atau .animateTo() untuk animasi
    });
    context.read<AuthBloc>().add(AuthCheckStatus());
  }

  String capitalizeEachWord(String text) {
    return text
        .split(' ')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
            : '')
        .join(' ');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            buildCustomAppBar(),
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                children: [
                  // headerSection(),
                  profileSection(),
                  sisaTaskSection(),
                  taskSection(),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCustomAppBar() {
    return Container(
      // color: whiteColor,
      margin: const EdgeInsets.only(top: 20, bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Kiri: Judul
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'G-SURE',
                style: primaryTextStyle.copyWith(
                  fontSize: 24,
                  fontWeight: bold,
                ),
              ),
            ],
          ),

          // Kanan: Icon search + notifikasi
          Row(
            children: [
              Icon(
                Icons.search,
                color: primaryColor,
                size: 28,
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.notifications,
                color: primaryColor,
                size: 28,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget profileSection() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthSuccess) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 30),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: whiteColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: lightBackgorundColor, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  capitalizeEachWord(state.user.name ?? 'Nama Tidak Tersedia'),
                  style: primaryTextStyle.copyWith(
                    fontSize: 20,
                    fontWeight: semiBold,
                  ),
                ),
                const SizedBox(height: 20),
                // WIDGET EXPANDED SUDAH DIHAPUS DARI SINI
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: lightBackgorundColor,
                      ),
                      child: Icon(Icons.person, color: blackColor, size: 40),
                    ),
                    const SizedBox(width: 20),
                    // Gunakan Expanded di sini untuk mengisi sisa ruang di dalam Row
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CONSUMER FINANCE',
                            style: blackTextStyle.copyWith(
                                fontSize: 16, fontWeight: semiBold),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            'Credit Marketing Officer',
                            softWrap: true,
                            overflow:
                                TextOverflow.visible, // ✅ biar tidak dipotong
                            style: greyTextStyle.copyWith(
                                fontSize: 12, fontWeight: light),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            'JAKARTA',
                            style: blackTextStyle.copyWith(
                                fontSize: 16, fontWeight: semiBold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 30),
          child: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget profileSection1() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 30),
      // height: ,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: whiteColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: lightBackgorundColor, width: 1),
        // boxShadow: [
        //   BoxShadow(
        //     color: lightBackgorundColor,
        //     blurRadius: 10,
        //     offset: Offset(0, 10),
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Salman AF',
            style: primaryTextStyle.copyWith(
              fontSize: 20,
              fontWeight: semiBold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: lightBackgorundColor,
                ),
                child: Icon(Icons.person, color: blackColor, size: 40),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CONSUMER FINANCE',
                      style: blackTextStyle.copyWith(
                          fontSize: 16, fontWeight: semiBold),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      'Credit Marketing Officer',
                      softWrap: true,
                      overflow: TextOverflow.visible, // ✅ biar tidak dipotong
                      style: greyTextStyle.copyWith(
                          fontSize: 12, fontWeight: light),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      'BOGOR',
                      style: blackTextStyle.copyWith(
                          fontSize: 16, fontWeight: semiBold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget sisaTaskSection() {
    final String boxName = 'survey_apps';
    // Asumsi model Anda adalah AplikasiSurvey, sesuaikan jika berbeda
    final Box<AplikasiSurvey> box = Hive.box<AplikasiSurvey>(boxName);

    return ValueListenableBuilder(
      valueListenable: box.listenable(),
      builder: (context, Box<AplikasiSurvey> box, _) {
        // ✅ TERAPKAN FILTER DAN HITUNG JUMLAHNYA DI SINI
        final int sisaTaskCount =
            box.values.where((survey) => survey.status != 'DONE').length;

        return Container(
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: secondaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sisa Task',
                style:
                    whiteTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(color: whiteColor, width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
                child: Center(
                  child: Text(
                    // ✅ GUNAKAN HASIL HITUNGAN DI SINI
                    sisaTaskCount.toString(),
                    style: whiteTextStyle.copyWith(fontWeight: semiBold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget taskSection() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Task',
            style: blackTextStyle.copyWith(fontSize: 16, fontWeight: semiBold),
          ),
          const SizedBox(
            height: 16,
          ),
          TaskListComponent(title: 'Task Gagal Diterima'),
          TaskListComponent(title: 'Task Berhasil Diterima'),
          TaskListComponent(title: 'Task Tidak Terkirim'),
          TaskListComponent(title: 'Task Selesai'),
        ],
      ),
    );
  }
}
