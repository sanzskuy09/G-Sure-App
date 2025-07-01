import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gsure/shared/theme.dart';
import 'package:gsure/ui/pages/form_survey_page.dart';
import 'package:gsure/ui/pages/home_page.dart';
import 'package:gsure/ui/pages/log_detail.dart';
import 'package:gsure/ui/pages/login_user_page.dart';
import 'package:gsure/ui/pages/main_page.dart';
import 'package:gsure/ui/pages/settings_pages/about_page.dart';
import 'package:gsure/ui/pages/settings_pages/log_page.dart';
import 'package:gsure/ui/pages/settings_pages/profile_page.dart';
import 'package:gsure/ui/pages/splash_page.dart';
import 'package:gsure/ui/pages/survey_list_page.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';

late List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is ready

  // WAJIB: Inisialisasi kamera sebelum runApp
  cameras = await availableCameras();

  await initializeDateFormatting('id_ID', null); // ⬅️ initialize for 'id_ID'
  Intl.defaultLocale = 'id_ID';

  // WAJIB: Inisialisasi Hive
  // final dir = await getApplicationDocumentsDirectory();
  // Hive.init(dir.path);
  // Hive.registerAdapter(KonsumenModelAdapter());

  // await Hive.openBox<KonsumenModel>('konsumen');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,
          centerTitle: true,
          elevation: 0,
          iconTheme: IconThemeData(color: whiteColor),
          titleTextStyle: whiteTextStyle.copyWith(
            fontSize: 16,
            fontWeight: semiBold,
          ),
        ),
      ),
      routes: {
        '/': (context) => const SplashPage(),
        '/login': (context) => const LoginUserPage(),
        '/main': (context) => const MainPage(),
        '/homepage': (context) => const HomePage(),
        '/survey': (context) => const SurveyListPage(),
        '/survey-form': (context) => const FormSurveyPage(),
        // '/settings': (context) => const SettingsPage(),
        // '/progress': (context) => const ProgressPage(),
        // detail setting pages
        '/profile': (context) => const ProfilePage(),
        '/about': (context) => const AboutPage(),
        '/log': (context) => const LogPage(),
        '/log-detail': (context) => const LogDetailPage(),
        // '/promo': (context) => const PromoPage(),
      },
    );
  }
}
