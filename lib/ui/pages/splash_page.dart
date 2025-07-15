import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gsure/shared/theme.dart';
// import 'package:mobile_apps/ui/pages/login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Animasi selama 1 detik
    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward(); // Mulai animasi

    // Navigasi ke login setelah 3 detik
    Timer(Duration(seconds: 3), () {
      // Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
      Navigator.pushNamedAndRemoveUntil(context, '/main', (_) => false);
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // penting untuk hindari memory leak
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ganti dengan whiteColor jika punya
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animasi logo
            FadeTransition(
              opacity: _opacityAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/ic_logo.png'),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            CircularProgressIndicator(color: primaryColor), // Spinner
          ],
        ),
      ),
    );
  }
}
