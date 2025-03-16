import 'package:miraibo/external-model/service/external_data_service.dart';
import 'package:miraibo/core-model/value/collection/receipt_log_collection.dart';

/// {@template exportDataTo}
/// export all receipt logs to the file at [path].
/// {@endtemplate}
Future<bool> exportDataTo(String path) async {
  await ReceiptLogCSVService.exportCSVToFile(path);
  return true;
}

/// {@template importDataFrom}
/// import receipt logs from the file at [path].
/// {@endtemplate}
Future<bool> importDataFrom(String path) async {
  final error = await ReceiptLogCSVService.importCSVFromFile(path);
  return error == null;
}

/// {@template overwriteDataWith}
/// remove all receipt logs and import receipt logs from the file at [path].
/// {@endtemplate}
Future<bool> overwriteDataWith(String path) async {
  await ReceiptLogCollection.deleteAll();
  final error = await ReceiptLogCSVService.importCSVFromFile(path);
  return error == null;
}

/// {@template backupDataTo}
/// backup all app data to the file at [path].
/// {@endtemplate}
Future<bool> backupDataTo(String path) async {
  // TODO: IMPLEMENT THIS
  return false;
  throw UnimplementedError();
}

/// {@template restoreDataFrom}
/// reset whole database and restore all app data from the file at [path].
/// {@endtemplate}
Future<bool> restoreDataFrom(String path) async {
  // TODO: IMPLEMENT THIS
  return false;
  throw UnimplementedError();
}
