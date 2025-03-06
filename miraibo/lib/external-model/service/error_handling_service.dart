import 'package:miraibo/repository/external.dart';

class ErrorHandlingService {
  static final ErrorMessenger _repository = ErrorMessenger.instance;
  static void logError(Error error) {
    var content =
        "${DateTime.now().toIso8601String()} ERROR: ${error.toString()}\n";
    content += StackTrace.current.toString();
    _repository.writeToErrorLogFile(content);
  }

  static void logException(Exception exception) {
    var content =
        "${DateTime.now().toIso8601String()} EXCEPTION: ${exception.toString()}\n";
    content += StackTrace.current.toString();
    _repository.writeToErrorLogFile(content);
  }

  static void logWarning(String warning) {
    var content = "${DateTime.now().toIso8601String()} WARNING: $warning\n";
    content += StackTrace.current.toString();
    _repository.writeToErrorLogFile(content);
  }
}
