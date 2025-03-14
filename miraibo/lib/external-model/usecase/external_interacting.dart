import 'package:miraibo/external-model/service/external_data_service.dart';
import 'package:miraibo/core-model/value/collection/receipt_log_collection.dart';

/// {@template exportDataTo}
/// export all receipt logs to the file at [path].
/// {@endtemplate}
Future<void> exportDataTo(String path) async {
  await ReceiptLogCSVService.exportCSVToFile(path);
}

/// {@template importDataFrom}
/// import receipt logs from the file at [path].
/// {@endtemplate}
Future<void> importDataFrom(String path) async {
  await ReceiptLogCSVService.importCSVFromFile(path);
}

/// {@template overwriteDataWith}
/// remove all receipt logs and import receipt logs from the file at [path].
/// {@endtemplate}
Future<void> overwriteDataWith(String path) async {
  await ReceiptLogCollection.deleteAll();
  await ReceiptLogCSVService.importCSVFromFile(path);
}

/// {@template backupDataTo}
/// backup all app data to the file at [path].
/// {@endtemplate}
Future<void> backupDataTo(String path) async {
  // TODO: IMPLEMENT THIS
}

/// {@template restoreDataFrom}
/// reset whole database and restore all app data from the file at [path].
/// {@endtemplate}
Future<void> restoreDataFrom(String path) async {
  // TODO: IMPLEMENT THIS
}
