import 'package:miraibo/core-model/entity/receipt_log.dart';
import 'package:miraibo/core-model/value/collection/category_collection.dart';
import 'package:miraibo/core-model/value/period.dart';
import 'package:miraibo/core-model/entity/plan.dart';
import 'package:miraibo/core-model/entity/monitor_scheme.dart';
import 'package:miraibo/core-model/entity/estimation_scheme.dart';
import 'package:miraibo/core-model/entity/currency.dart';
import 'package:miraibo/core-model/entity/category.dart';

abstract class CategoryRepository {
  static late final CategoryRepository instance;
  Stream<List<Category>> watchAll();
  Future<List<Category>> getAll();
  Future<Category?> find(String name);
  Future<void> update(Category category);
  Future<void> insert(Category category);
  Future<void> insertAll(Iterable<Category> categories);
  Future<void> delete(Category category);
}

abstract class CurrencyRepository {
  static late final CurrencyRepository instance;
  Stream<List<Currency>> watchAll();
  Future<List<Currency>> getAll();
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
  Future<void> replaceCategory(Category oldCategory, Category newCategory);
  Stream<EstimationScheme> savedIn(Currency currency);
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
  Future<void> replaceCategory(Category oldCategory, Category newCategory);
  Stream<MonitorScheme> savedIn(Currency currency);
  Future<void> update(MonitorScheme monitorScheme);
  Future<void> delete(MonitorScheme monitorScheme);
  Future<void> insert(MonitorScheme monitorScheme);
}

abstract class ReceiptLogRepository {
  static late final ReceiptLogRepository instance;
  Stream<ReceiptLog> get(Period period, CategoryCollection categories,
      {bool? confirmed});
  Stream<List<ReceiptLog>> watchRows(int skip, int limit);
  Future<List<ReceiptLog>> getRows(int skip, int limit);
  Future<void> replaceCategory(Category oldCategory, Category newCategory);
  Stream<ReceiptLog> savedIn(Currency currency);
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
  Future<void> replaceCategory(Category oldCategory, Category newCategory);
  Stream<Plan> savedIn(Currency currency);
  Future<void> update(Plan plan);
  Future<void> delete(Plan plan);
  Future<void> insert(Plan plan);
}
