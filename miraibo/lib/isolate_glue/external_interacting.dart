import 'package:flutter/foundation.dart' show compute;
import 'package:miraibo/external-model/usecase/external_interacting.dart'
    as usecase;
import 'package:miraibo/repository/impl.dart' as repository;

Future<void> __exportDataTo(String path) async {
  repository.bind();
  await usecase.exportDataTo(path);
}

/// {@macro exportDataTo}
Future<void> exportDataTo(String path) {
  return usecase.backupDataTo(path);
  // return compute(__exportDataTo, path);
}

Future<void> __importDataFrom(String path) async {
  repository.bind();
  await usecase.importDataFrom(path);
}

/// {@macro importDataFrom}
Future<void> importDataFrom(String path) {
  return usecase.restoreDataFrom(path);
  // return compute(__importDataFrom, path);
}

Future<void> __overwriteDataWith(String path) async {
  repository.bind();
  await usecase.overwriteDataWith(path);
}

/// {@macro overwriteDataWith}
Future<void> overwriteDataWith(String path) {
  return usecase.restoreDataFrom(path);
  // return compute(__overwriteDataWith, path);
}

Future<void> __backupDataTo(String path) async {
  repository.bind();
  await usecase.backupDataTo(path);
}

/// {@macro backupDataTo}
Future<void> backupDataTo(String path) {
  return usecase.backupDataTo(path);
  // return compute(__backupDataTo, path);
}

Future<void> __restoreDataFrom(String path) async {
  repository.bind();
  await usecase.restoreDataFrom(path);
}

/// {@macro restoreDataFrom}
Future<void> restoreDataFrom(String path) {
  return usecase.restoreDataFrom(path);
  // return compute(__restoreDataFrom, path);
}
