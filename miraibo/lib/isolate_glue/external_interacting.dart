import 'package:flutter/foundation.dart' show compute;
import 'package:miraibo/core-model/usecase/usecase.dart' as usecase;

/// {@macro exportDataTo}
Future<void> exportDataTo(String path) {
  return compute(usecase.exportDataTo, path);
}

/// {@macro importDataFrom}
Future<void> importDataFrom(String path) {
  return compute(usecase.importDataFrom, path);
}

/// {@macro overwriteDataWith}
Future<void> overwriteDataWith(String path) {
  return compute(usecase.overwriteDataWith, path);
}

/// {@macro backupDataTo}
Future<void> backupDataTo(String path) {
  return compute(usecase.backupDataTo, path);
}

/// {@macro restoreDataFrom}
Future<void> restoreDataFrom(String path) {
  return compute(usecase.restoreDataFrom, path);
}
