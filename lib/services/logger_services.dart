import 'package:flutter/foundation.dart'; // untuk kDebugMode
import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
      printTime: false,
    ),
  );

  static void d(String message) {
    if (kDebugMode) {
      _logger.d(message);
    }
  }

  static void i(String message) {
    if (kDebugMode) {
      _logger.i(message);
    }
  }

  static void w(String message) {
    if (kDebugMode) {
      _logger.w(message);
    }
  }

  static void e(String message, [error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.e(message, error: error, stackTrace: stackTrace);
    }
  }
}
