import 'package:flutter/foundation.dart' show compute;
import 'package:miraibo/external-model/usecase/external_interacting.dart'
    as usecase;
import 'package:miraibo/repository/impl.dart' as repository;

Future<void> __exportDataTo(String path) {
  repository.bind();
  return compute(usecase.exportDataTo, path);
}

/// {@macro exportDataTo}
Future<void> exportDataTo(String path) {
  return compute(__exportDataTo, path);
}

Future<void> __importDataFrom(String path) {
  repository.bind();
  return compute(usecase.importDataFrom, path);
}

/// {@macro importDataFrom}
Future<void> importDataFrom(String path) {
  return compute(__importDataFrom, path);
}

Future<void> __overwriteDataWith(String path) {
  repository.bind();
  return compute(usecase.overwriteDataWith, path);
}

/// {@macro overwriteDataWith}
Future<void> overwriteDataWith(String path) {
  return compute(__overwriteDataWith, path);
}

Future<void> __backupDataTo(String path) {
  repository.bind();
  return compute(usecase.backupDataTo, path);
}

/// {@macro backupDataTo}
Future<void> backupDataTo(String path) {
  return compute(__backupDataTo, path);
}

Future<void> __restoreDataFrom(String path) {
  repository.bind();
  return compute(usecase.restoreDataFrom, path);
}

/// {@macro restoreDataFrom}
Future<void> restoreDataFrom(String path) {
  return compute(__restoreDataFrom, path);
}
