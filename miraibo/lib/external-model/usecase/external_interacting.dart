import 'package:logger/logger.dart';
import 'package:miraibo/external-model/service/error_handling_service.dart';
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
  try {
    final error = await ReceiptLogCSVService.importCSVFromFile(path);
    return error == null;
  } on Exception catch (e) {
    ErrorHandlingService.logException(e);
    return false;
  }
}

/// {@template overwriteDataWith}
/// remove all receipt logs and import receipt logs from the file at [path].
/// {@endtemplate}
Future<bool> overwriteDataWith(String path) async {
  try {
    await ReceiptLogCollection.deleteAll();
    final error = await ReceiptLogCSVService.importCSVFromFile(path);
    return error == null;
  } on Exception catch (e) {
    ErrorHandlingService.logException(e);
    return false;
  }
}

/// {@template backupDataTo}
/// backup all app data to the file at [path].
/// {@endtemplate}
Future<bool> backupDataTo(String path) async {
  final error = await BackupService.dump(path);
  return error == null;
}

/// {@template restoreDataFrom}
/// reset whole database and restore all app data from the file at [path].
/// {@endtemplate}
Future<bool> restoreDataFrom(String path) async {
  try {
    final error = await BackupService.load(path);
    return error == null;
  } on Exception catch (e) {
    ErrorHandlingService.logException(e);
    return false;
  }
}
