import 'package:miraibo/model/repository/serial.dart';

class ErrorHandlingService {
  static final ErrorMessenger repository = ErrorMessenger.instance;
  static void logError(Error error) async {
    final content = "${DateTime.now().toIso8601String()}: ${error.toString()}";
    repository.logError(content);
  }
}
