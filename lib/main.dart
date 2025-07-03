import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gsure/blocs/survey/survey_bloc.dart';
import 'package:gsure/models/order_model.dart';
import 'package:gsure/models/survey_data.dart';
import 'package:gsure/services/survey_service.dart';
import 'package:gsure/shared/theme.dart';
import 'package:gsure/ui/pages/contoh_survey_list_page.dart';
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
import 'package:flutter_bloc/flutter_bloc.dart';

late List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is ready

  // WAJIB: Inisialisasi kamera sebelum runApp
  cameras = await availableCameras();

  await initializeDateFormatting('id_ID', null); // ⬅️ initialize for 'id_ID'
  Intl.defaultLocale = 'id_ID';

  // WAJIB: Inisialisasi Hive
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.registerAdapter(OrderModelAdapter());
  Hive.registerAdapter(SurveyDataAdapter());

  await Hive.openBox<OrderModel>('orders');
  await Hive.openBox<SurveyData>('surveys');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // BlocProvider<AuthBloc>(
        //   create: (context) => AuthBloc(),
        // ),
        BlocProvider<SurveyBloc>(
          create: (context) => SurveyBloc(SurveyService()),
        ),
      ],
      child: MaterialApp(
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
          // '/survey-form': (context) => const FormSurveyPage(),
          '/daftar-order': (context) => const MainPage(selectedIndex: 1),
          // '/settings': (context) => const SettingsPage(),
          // '/progress': (context) => const ProgressPage(),
          // detail setting pages
          '/profile': (context) => const ProfilePage(),
          '/list-sruvey': (context) => const ContohSurveyListPage(),
          '/about': (context) => const AboutPage(),
          '/log': (context) => const LogPage(),
          '/log-detail': (context) => const LogDetailPage(),
          // '/promo': (context) => const PromoPage(),
        },
      ),
    );
  }
}
