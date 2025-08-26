import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gsure/blocs/survey/survey_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';

class LoadingLottiePage extends StatefulWidget {
  const LoadingLottiePage({super.key});

  @override
  State<LoadingLottiePage> createState() => _LoadingLottiePageState();
}

class _LoadingLottiePageState extends State<LoadingLottiePage> {
  bool _isTimerFinished = false;
  bool _isApiCallFinished = false;

  String _loadingMessage = 'Mengirim Data Survey...';

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _isTimerFinished = true;
        });
        _checkAndNavigate();
      }
    });
  }

  void _checkAndNavigate() {
    if (_isTimerFinished && _isApiCallFinished && context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/list-survey', (_) => false);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('🎉 Semua data dan file berhasil dikirim!'),
        backgroundColor: Colors.green,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SurveyBloc, SurveyState>(
      listener: (context, state) {
        if (state is SendSurveySuccess) {
          if (mounted) {
            setState(() {
              _loadingMessage = 'Data terkirim. Mengunggah file...';
            });
          }
        }

        if (state is UploadFilesSuccess) {
          if (mounted) {
            setState(() {
              _isApiCallFinished = true;
            });

            _checkAndNavigate();
          }
        }

        if (state is SendSurveyFailure || state is UploadFilesFailed) {
          if (mounted) {
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animations/loading.json', // Pastikan path ini benar
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 20),
              Text(
                _loadingMessage,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Mohon tunggu sebentar.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
