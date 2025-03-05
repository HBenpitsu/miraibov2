import 'package:miraibo/model/entity/receipt_log.dart';
import 'package:miraibo/model/value/collection/category_collection.dart';
import 'package:miraibo/model/value/period.dart';
import 'package:miraibo/model/entity/plan.dart';
import 'package:miraibo/model/entity/monitor_scheme.dart';
import 'package:miraibo/model/entity/estimation_scheme.dart';
import 'package:miraibo/model/entity/currency.dart';
import 'package:miraibo/model/entity/category.dart';

abstract class CategoryRepository {
  static late final CategoryRepository instance;
  Stream<List<Category>> allCategories();
  Future<Category?> find(String name);
  Future<void> update(Category category);
  Future<void> insert(Category category);
  Future<void> insertAll(Iterable<Category> categories);
  Future<void> delete(Category category);
}

abstract class CurrencyRepository {
  static late final CurrencyRepository instance;
  Stream<List<Currency>> allCurrencies();
  Future<Currency?> find(String symbol, double ratio);
  Future<Currency?> getDefault();
  Future<void> setDefault(Currency currency);
  Future<void> update(Currency currency);
  Future<void> insert(Currency currency);
  Future<void> delete(Currency currency);
}

abstract class EstimationSchemeRepository {
  static late final EstimationSchemeRepository instance;
  Stream<EstimationScheme> get(
    Period period,
    CategoryCollection categories,
  );
  Future<void> update(EstimationScheme estimationScheme);
  Future<void> delete(EstimationScheme estimationScheme);
  Future<void> insert(EstimationScheme estimationScheme);
}

abstract class MonitorSchemeRepository {
  static late final MonitorSchemeRepository instance;
  Stream<MonitorScheme> get(
    Period period,
    CategoryCollection categories,
  );
  Future<void> update(MonitorScheme monitorScheme);
  Future<void> delete(MonitorScheme monitorScheme);
  Future<void> insert(MonitorScheme monitorScheme);
}

abstract class ReceiptLogRepository {
  static late final ReceiptLogRepository instance;
  Stream<ReceiptLog> get(Period period, CategoryCollection categories,
      {bool? confirmed});
  Stream<List<ReceiptLog>> observeRows(int skip, int limit);
  Future<void> insert(ReceiptLog receiptLog);
  Future<void> update(ReceiptLog receiptLog);
  Future<void> delete(ReceiptLog receiptLog);
}

abstract class PlanRepository {
  static late final PlanRepository instance;
  Stream<Plan> get(
    Period period,
    CategoryCollection categories,
  );
  Future<void> update(Plan plan);
  Future<void> delete(Plan plan);
  Future<void> insert(Plan plan);
}
