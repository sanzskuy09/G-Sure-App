import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gsure/blocs/survey/survey_bloc.dart';
import 'package:gsure/shared/theme.dart';
import 'package:gsure/ui/pages/home_page.dart';
import 'package:gsure/ui/pages/progress_survey_page.dart';
import 'package:gsure/ui/pages/settings_page.dart';
import 'package:gsure/ui/pages/settings_pages/log_page.dart';
import 'package:gsure/ui/pages/survey_list_page.dart';

class MainPage extends StatefulWidget {
  final int selectedIndex;

  const MainPage({
    super.key,
    this.selectedIndex = 0,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int _selectedIndex = 0;
  bool _isSurveyList = false;

  final List<Widget> _pages = const [
    HomePage(),
    SurveyListPage(),
    ProgressSurveyPage(),
    SettingsPage()
    // LogPage()
  ];

  void _onTabTapped(int index) {
    if (_isSurveyList == false && index == 1) {
      context.read<SurveyBloc>().add(GetDataSurveyFromOrder());

      setState(() {
        _isSurveyList = true;
      });
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomAppBar(
        color: whiteColor,
        elevation: 20,
        // shadowColor: blackColor,
        // surfaceTintColor: blackColor,
        child: SizedBox(
          height: 70, // Atur tinggi sesuai kebutuhan
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(icon: Icons.home, label: 'Home', index: 0),
              _buildNavItem(
                  icon: Icons.travel_explore, label: 'Survey', index: 1),
              _buildNavItem(
                  icon: Icons.library_add_check, label: 'Progress', index: 2),
              _buildNavItem(icon: Icons.settings, label: 'Settings', index: 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      // onTap: () => setState(() => _selectedIndex = index),
      onTap: () => _onTabTapped(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withValues(alpha: 0.1)
              : Colors.transparent,
          // isSelected ? primaryColor.withOpacity(0.1) : Colors.transparent,

          borderRadius: BorderRadius.circular(5),
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? primaryColor : Colors.grey,
              ),
              SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 8,
                  color: isSelected ? primaryColor : Colors.grey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
