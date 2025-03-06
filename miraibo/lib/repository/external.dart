abstract class ErrorMessenger {
  static late final ErrorMessenger instance;
  void writeToErrorLogFile(String error);
}

abstract class ExternalEnvironmentInterface {
  static late final ExternalEnvironmentInterface instance;

  /// store given content as a CSV file.
  /// Path includes the file name.
  /// Stream should provide the segment of the content.
  /// Line break is NOT inserted between segments.
  Future<void> generateFile(String path, Stream<String> content);

  /// returns the content of the CSV file as a stream of strings.
  /// Stream provides the content line by line.
  /// Return null when the file does not exist.
  Future<Stream<String>?> loadFile(String path);
}
