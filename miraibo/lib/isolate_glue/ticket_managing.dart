import 'package:flutter/foundation.dart' show compute;
import 'package:miraibo/core-model/usecase/usecase.dart' as usecase;
import 'package:miraibo/dto/dto.dart';
import 'package:miraibo/shared/enumeration.dart';
import 'package:miraibo/repository/impl.dart' as repository;

// <for ReceiptLog>

// <createReceiptLog>
Future<int> __createReceiptLog((Date, int, int, int, String, bool) param) {
  repository.bind();
  return usecase.createReceiptLog(
      originDate: param.$1,
      amount: param.$2,
      currencyId: param.$3,
      categoryId: param.$4,
      description: param.$5,
      confirmed: param.$6);
}

/// {@macro createReceiptLog}
Future<int> createReceiptLog({
  required Date originDate,
  required int amount,
  required int currencyId,
  required int categoryId,
  required String description,
  required bool confirmed,
}) {
  return usecase.createReceiptLog(
      originDate: originDate,
      amount: amount,
      currencyId: currencyId,
      categoryId: categoryId,
      description: description,
      confirmed: confirmed);
  // return compute(__createReceiptLog,
  //     (originDate, amount, currencyId, categoryId, description, confirmed));
}
// </createReceiptLog>

// <editReceiptLog>
Future<void> __editReceiptLog((int, Date, int, int, int, String, bool) param) {
  repository.bind();
  return usecase.editReceiptLog(
    id: param.$1,
    originDate: param.$2,
    amount: param.$3,
    currencyId: param.$4,
    categoryId: param.$5,
    description: param.$6,
    confirmed: param.$7,
  );
}

Future<void> editReceiptLog({
  required int id,
  required Date originDate,
  required int amount, // price
  required int currencyId, // price
  required int categoryId, // category
  required String description, // description
  required bool confirmed, // confirmed
}) {
  return usecase.editReceiptLog(
    id: id,
    originDate: originDate,
    amount: amount,
    currencyId: currencyId,
    categoryId: categoryId,
    description: description,
    confirmed: confirmed,
  );
  // return compute(__editReceiptLog,
  //     (id, originDate, amount, currencyId, categoryId, description, confirmed));
}
// </editReceiptLog>

// <deleteReceiptLog>
Future<void> __deleteReceiptLog(int id) {
  repository.bind();
  return usecase.deleteReceiptLog(id);
}

Future<void> deleteReceiptLog(int id) {
  return usecase.deleteReceiptLog(id);
  // return compute(__deleteReceiptLog, id);
}
// </deleteReceiptLog>

// </for ReceiptLog>
// <for Plan>

// <createPlan>
Future<int> __createPlan((Schedule, int, int, int, String) param) {
  repository.bind();
  return usecase.createPlan(param.$1, param.$2, param.$3, param.$4, param.$5);
}

/// {@macro createPlan}
Future<int> createPlan({
  required Schedule schedule,
  required int amount, // price
  required int currencyId, // price
  required int categoryId, // category
  required String description, // description
}) async {
  return usecase.createPlan(
      schedule, amount, currencyId, categoryId, description);
  // return compute(
  //     __createPlan, (schedule, amount, currencyId, categoryId, description));
}
// </createPlan>

// <editPlan>
Future<void> __editPlan((int, Schedule, int, int, int, String) param) async {
  repository.bind();
  return usecase.editPlan(
      param.$1, param.$2, param.$3, param.$4, param.$5, param.$6);
}

Future<void> editPlan({
  required int id,
  required Schedule schedule,
  required int amount, // price
  required int currencyId, // price
  required int categoryId, // category
  required String description, // description
}) async {
  return usecase.editPlan(
      id, schedule, amount, currencyId, categoryId, description);
  // return compute(
  //     __editPlan, (id, schedule, amount, currencyId, categoryId, description));
}
// </editPlan>

// <deletePlan>
Future<void> __deletePlan(int id) {
  repository.bind();
  return usecase.deletePlan(id);
}

Future<void> deletePlan(int id) {
  return usecase.deletePlan(id);
  // return compute(__deletePlan, id);
}
// </deletePlan>

// </for Plan>
// <for EstimationScheme>

Future<int> __createEstimationScheme(
    (
      OpenPeriod,
      int,
      EstimationDisplayOption,
      int,
    ) param) {
  repository.bind();
  return usecase.createEstimationScheme(param.$1, param.$2, param.$3, param.$4);
}

/// {@macro createEstimationScheme}
Future<int> createEstimationScheme({
  required OpenPeriod period,
  required int categoryId,
  required EstimationDisplayOption displayOption,
  required int currencyId,
}) async {
  return usecase.createEstimationScheme(
      period, categoryId, displayOption, currencyId);
  // return compute(__createEstimationScheme,
  //     (period, categoryId, displayOption, currencyId));
}

Future<void> __editEstimationScheme(
    (int, OpenPeriod, int, EstimationDisplayOption, int) param) {
  repository.bind();
  return usecase.editEstimationScheme(
      param.$1, param.$2, param.$3, param.$4, param.$5);
}

Future<void> editEstimationScheme({
  required int id,
  required OpenPeriod period,
  required EstimationDisplayOption displayOption,
  required int categoryId,
  required int currencyId,
}) async {
  return usecase.editEstimationScheme(
      id, period, categoryId, displayOption, currencyId);
  // return compute(__editEstimationScheme,
  //     (id, period, categoryIds, displayOption, currencyId));
}

Future<void> __deleteEstimationScheme(int id) {
  repository.bind();
  return usecase.deleteEstimationScheme(id);
}

Future<void> deleteEstimationScheme(int id) async {
  return usecase.deleteEstimationScheme(id);
  // return compute(__deleteEstimationScheme, id);
}

// </for EstimationScheme>
// <for MonitorScheme>

Future<int> __createMonitorScheme(
    (OpenPeriod, List<int>, MonitorDisplayOption, int) param) {
  repository.bind();
  return usecase.createMonitorScheme(param.$1, param.$2, param.$3, param.$4);
}

/// {@macro createMonitorScheme}
Future<int> createMonitorScheme(
  OpenPeriod period,
  List<int> categoryIds,
  MonitorDisplayOption displayOption,
  int currencyId,
) async {
  return usecase.createMonitorScheme(
      period, categoryIds, displayOption, currencyId);
  // return compute(
  //     __createMonitorScheme, (period, categoryIds, displayOption, currencyId));
}

Future<void> __editMonitorScheme(
    (int, OpenPeriod, List<int>, MonitorDisplayOption, int) param) {
  repository.bind();
  return usecase.editMonitorScheme(
      param.$1, param.$2, param.$3, param.$4, param.$5);
}

Future<void> editMonitorScheme(
  int id,
  OpenPeriod period,
  List<int> categoryIds,
  MonitorDisplayOption displayOption,
  int currencyId,
) async {
  return usecase.editMonitorScheme(
      id, period, categoryIds, displayOption, currencyId);
  // return compute(__editMonitorScheme,
  //     (id, period, categoryIds, displayOption, currencyId));
}

Future<void> __deleteMonitorScheme(int id) {
  repository.bind();
  return usecase.deleteMonitorScheme(id);
}

Future<void> deleteMonitorScheme(int id) async {
  return usecase.deleteMonitorScheme(id);
  // return compute(__deleteMonitorScheme, id);
}

// </for MonitorScheme>
