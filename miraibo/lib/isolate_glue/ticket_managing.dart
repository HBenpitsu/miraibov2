import 'package:flutter/foundation.dart' show compute;
import 'package:miraibo/model/usecase/usecase.dart' as usecase;
import 'package:miraibo/dto/dto.dart';

// <for ReceiptLog>

// <createReceiptLog>
Future<int> __createReceiptLog((Date, Price, int, String, bool) param) {
  return usecase.createReceiptLog(
      param.$1, param.$2, param.$3, param.$4, param.$5);
}

/// {@macro createReceiptLog}
Future<int> createReceiptLog(Date originDate, Price price, int categoryId,
    String description, bool confirmed) {
  return compute(__createReceiptLog,
      (originDate, price, categoryId, description, confirmed));
}
// </createReceiptLog>

// <editReceiptLog>
Future<void> __editReceiptLog((int, Date, Price, int, String, bool) param) {
  return usecase.editReceiptLog(
      param.$1, param.$2, param.$3, param.$4, param.$5, param.$6);
}

Future<void> editReceiptLog(
    int id,
    Date originDate,
    Price price,
    int categoryId, // category
    String description, // description
    bool confirmed // confirmed
    ) {
  return compute(__editReceiptLog,
      (id, originDate, price, categoryId, description, confirmed));
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
Future<int> __createPlan((Schedule, Price, int, String) param) {
  return usecase.createPlan(param.$1, param.$2, param.$3, param.$4);
}

/// {@macro createPlan}
Future<int> createPlan(
  Schedule schedule,
  Price price,
  int categoryId, // category
  String description, // description
) async {
  return compute(__createPlan, (schedule, price, categoryId, description));
}
// </createPlan>

// <editPlan>
Future<void> __editPlan((int, Schedule, Price, int, String) param) async {
  return usecase.editPlan(param.$1, param.$2, param.$3, param.$4, param.$5);
}

Future<void> editPlan(
  int id,
  Schedule schedule,
  Price price,
  int categoryId, // category
  String description, // description
) async {
  return compute(__editPlan, (id, schedule, price, categoryId, description));
}
// </editPlan>

// <deletePlan>
Future<void> deletePlan(String id) {
  return compute(usecase.deletePlan, id);
}
// </deletePlan>

// </for Plan>
// <for EstimationScheme>

/// {@macro createEstimationScheme}
Future<int> createEstimationScheme(
  OpenPeriod period,
  EstimationDisplayConfig displayConfig,
  List<int> categoryIds,
) async {
  throw UnimplementedError();
}

Future<void> editEstimationScheme(
  int id,
  OpenPeriod period,
  EstimationDisplayConfig displayConfig,
  List<int> categoryIds,
) async {
  throw UnimplementedError();
}

Future<void> deleteEstimationScheme(int id) async {
  throw UnimplementedError();
}

// </for EstimationScheme>
// <for MonitorScheme>

/// {@macro createMonitorScheme}
Future<int> createMonitorScheme(
  OpenPeriod period,
  MonitorDisplayConfig displayConfig,
  List<int> categoryIds,
) async {
  throw UnimplementedError();
}

Future<void> editMonitorScheme(
  int id,
  OpenPeriod period,
  MonitorDisplayConfig displayConfig,
  List<int> categoryIds,
) async {
  throw UnimplementedError();
}

Future<void> deleteMonitorScheme(int id) async {
  throw UnimplementedError();
}

// </for MonitorScheme>
