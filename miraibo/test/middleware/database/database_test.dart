import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miraibo/middleware/relational/database.dart';
import 'package:miraibo/middleware/id_provider.dart';
import 'package:logger/logger.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import '../../test_materials/fake_path_provider.dart';

void main() {
  final logger = Logger();
  final idProvider = IdProvider();
  final FakePathProviderPlatform fakePathProvider = FakePathProviderPlatform();
  setUpAll(() {
    PathProviderPlatform.instance = fakePathProvider;
  });
  test('categories', () async {
    final AppDatabase database = AppDatabase();

    await database.categories.insertAll([
      for (final categoryName in [
        'Food',
        'Gas',
        'Water',
        'Electricity',
        'Transportation',
        'Education Fee',
        'Education Materials',
        'Medication',
        'Amusement',
        'Furniture',
        'Necessities',
        'Other Expense',
        'Scholarship',
        'Payment',
        'Other Income',
        'Adjustment',
      ])
        CategoriesCompanion(
          id: Value(idProvider.get()),
          name: Value(categoryName),
          createdAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        )
    ]);

    logger.i(await database.categories.select().get());
  });
  test('currencies', () async {
    final AppDatabase database = AppDatabase();
    await database.currencies.insertAll([
      for (final (String symbol, double ratio) in [
        ('JPY', 150),
        ('JPY (elec)', 150),
        ('USD', 1),
        ('EUR', 0.96),
        ('STOCK', 180)
      ])
        CurrenciesCompanion(
          id: Value(idProvider.get()),
          symbol: Value(symbol),
          ratio: Value(ratio),
          createdAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        )
    ]);

    logger.i(await database.currencies.select().get());
  });
  test('receipt logs', () async {
    final AppDatabase database = AppDatabase();
    final now = DateTime.now();
    final foodCategory = await (database.categories.select()
          ..where((r) => r.name.equals('Food')))
        .getSingle();
    final adjustmentCategory = await (database.categories.select()
          ..where((r) => r.name.equals('Adjustment')))
        .getSingle();
    final currency = await (database.currencies.select()..limit(1)).getSingle();
    await database.receiptLogs.insertAll([
      for (final (String description, double amount, DateTime date) in [
        ('Lunch', 1000, now),
        ('Dinner', 2000, now),
        ('Breakfast', 500, now),
        ('Snack', 300, now),
        ('Drink', 200, now),
      ])
        ReceiptLogsCompanion(
          id: Value(idProvider.get()),
          amount: Value(amount),
          date: Value(date),
          description: Value(description),
          categoryId: Value(foodCategory.id),
          currencyId: Value(currency.id),
          confirmed: Value(true),
          createdAt: Value(now),
          updatedAt: Value(now),
        )
    ]);
    await database.receiptLogs.insertAll([
      for (final (String description, double amount, DateTime date) in [
        ('AdjustA', 1000, now),
        ('AdjustB', 2000, now),
        ('AdjustC', 500, now),
      ])
        ReceiptLogsCompanion(
          id: Value(idProvider.get()),
          amount: Value(amount),
          date: Value(date),
          description: Value(description),
          categoryId: Value(adjustmentCategory.id),
          currencyId: Value(currency.id),
          confirmed: Value(false),
          createdAt: Value(now),
          updatedAt: Value(now),
        )
    ]);
  });
  tearDownAll(() {
    fakePathProvider.tearDown();
  });
}
