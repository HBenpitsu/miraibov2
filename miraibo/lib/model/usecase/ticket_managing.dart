import 'package:miraibo/dto/dto.dart';

// <for ReceiptLog>

/// {@template createReceiptLog}
/// returns the id of the created receipt log
/// {@endtemplate}
Future<int> createReceiptLog(Date originDate, Price price, int categoryId,
    String description, bool confirmed) async {
  throw UnimplementedError();
}

Future<void> editReceiptLog(
    int id,
    Date originDate,
    Price price,
    int categoryId, // category
    String description, // description
    bool confirmed // confirmed
    ) async {
  throw UnimplementedError();
}

Future<void> deleteReceiptLog(int id) async {
  throw UnimplementedError();
}

// </for ReceiptLog>
// <for Plan>

/// {@template createPlan}
/// returns the id of the created plan
/// {@endtemplate}
Future<int> createPlan(
  Schedule schedule,
  Price price,
  int categoryId, // category
  String description, // description
) async {
  throw UnimplementedError();
}

Future<void> editPlan(
  int id,
  Schedule schedule,
  Price price,
  int categoryId, // category
  String description, // description
) async {
  // access to iso-glue
  throw UnimplementedError();
}

Future<void> deletePlan(String id) async {
  throw UnimplementedError();
}

// </for Plan>
// <for EstimationScheme>

/// {@template createEstimationScheme}
/// returns the id of the created estimation scheme
/// {@endtemplate}
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

/// {@template createMonitorScheme}
/// returns the id of the created monitor scheme
/// {@endtemplate}
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