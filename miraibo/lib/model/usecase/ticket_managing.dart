import 'package:miraibo/model/usecase/ticket_primitives.dart';
export 'package:miraibo/model/usecase/ticket_primitives.dart';
import 'package:miraibo/model/usecase/general_primitives.dart';
export 'package:miraibo/model/usecase/general_primitives.dart';

// Ticket managing usecase

// <for ReceiptLog>

/// returns the id of the created receipt log
Future<int> createReceiptLog(Date originDate, Price price, int categoryId,
    String description, bool confirmed) async {
  // access to iso-glue
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
  // access to iso-glue
  throw UnimplementedError();
}

Future<void> deleteReceiptLog(int id) async {
  throw UnimplementedError();
}

// </for ReceiptLog>
// <for Plan>

/// returns the id of the created plan
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

/// returns the id of the created estimation scheme
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

/// returns the id of the created monitor scheme
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
// <fetch necessary data>

/// returns the list of all categories (list of pairs of name and id of category)
Future<List<Category>> fetchAllCategories() async {
  throw UnimplementedError();
}

/// returns the list of all currencies (list of pairs of name and id of currency)
Future<List<Currency>> fetchAllCurrencies() async {
  throw UnimplementedError();
}

/// returns the default currency (list of pairs of name and id of currency)
Future<Currency> fetchDefaultCurrency() async {
  throw UnimplementedError();
}

// </fetch necessary data>

// <data classes>

class Category {
  final int id;
  final String name;

  const Category(this.id, this.name);
}

class Currency {
  final int id;
  final String name;
  // there is no need to have ratio of the currency because the price conversion should not be done in the usecase or upper layer.

  const Currency(this.id, this.name);
}

// </data classes>
