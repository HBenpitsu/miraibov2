import 'package:flutter/foundation.dart' show compute;
import 'package:miraibo/core-model/usecase/usecase.dart' as usecase;
import 'package:miraibo/dto/dto.dart';
import 'package:miraibo/shared/enumeration.dart';

// <for ReceiptLog>

// <createReceiptLog>
Future<int> __createReceiptLog((Date, int, int, int, String, bool) param) {
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
  return compute(__createReceiptLog,
      (originDate, amount, currencyId, categoryId, description, confirmed));
}
// </createReceiptLog>

// <editReceiptLog>
Future<void> __editReceiptLog((int, Date, int, int, int, String, bool) param) {
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
  return compute(__editReceiptLog,
      (id, originDate, amount, currencyId, categoryId, description, confirmed));
}
// </editReceiptLog>

// <deleteReceiptLog>
Future<void> deleteReceiptLog(int id) {
  return compute(usecase.deleteReceiptLog, id);
}
// </deleteReceiptLog>

// </for ReceiptLog>
// <for Plan>

// <createPlan>
Future<int> __createPlan((Schedule, int, int, int, String) param) {
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
  return compute(
      __createPlan, (schedule, amount, currencyId, categoryId, description));
}
// </createPlan>

// <editPlan>
Future<void> __editPlan((int, Schedule, int, int, int, String) param) async {
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
  return compute(
      __editPlan, (id, schedule, amount, currencyId, categoryId, description));
}
// </editPlan>

// <deletePlan>
Future<void> deletePlan(int id) {
  return compute(usecase.deletePlan, id);
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
  return usecase.createEstimationScheme(param.$1, param.$2, param.$3, param.$4);
}

/// {@macro createEstimationScheme}
Future<int> createEstimationScheme({
  required OpenPeriod period,
  required int categoryId,
  required EstimationDisplayOption displayOption,
  required int currencyId,
}) async {
  return compute(__createEstimationScheme,
      (period, categoryId, displayOption, currencyId));
}

Future<void> __editEstimationScheme(
    (int, OpenPeriod, List<int>, EstimationDisplayOption, int) param) {
  return usecase.editEstimationScheme(
      param.$1, param.$2, param.$3, param.$4, param.$5);
}

Future<void> editEstimationScheme({
  required int id,
  required OpenPeriod period,
  required EstimationDisplayOption displayOption,
  required List<int> categoryIds,
  required int currencyId,
}) async {
  return compute(__editEstimationScheme,
      (id, period, categoryIds, displayOption, currencyId));
}

Future<void> deleteEstimationScheme(int id) async {
  return compute(usecase.deleteEstimationScheme, id);
}

// </for EstimationScheme>
// <for MonitorScheme>

Future<int> __createMonitorScheme(
    (OpenPeriod, List<int>, MonitorDisplayOption, int) param) {
  return usecase.createMonitorScheme(param.$1, param.$2, param.$3, param.$4);
}

/// {@macro createMonitorScheme}
Future<int> createMonitorScheme(
  OpenPeriod period,
  List<int> categoryIds,
  MonitorDisplayOption displayOption,
  int currencyId,
) async {
  return compute(
      __createMonitorScheme, (period, categoryIds, displayOption, currencyId));
}

Future<void> __editMonitorScheme(
    (int, OpenPeriod, List<int>, MonitorDisplayOption, int) param) {
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
  return compute(__editMonitorScheme,
      (id, period, categoryIds, displayOption, currencyId));
}

Future<void> deleteMonitorScheme(int id) async {
  return compute(usecase.deleteMonitorScheme, id);
}

// </for MonitorScheme>
