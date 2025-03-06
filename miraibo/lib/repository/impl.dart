import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'package:miraibo/middleware/relational/database.dart';
import 'package:miraibo/middleware/key_value.dart';
import 'package:miraibo/repository/core.dart';
import 'package:miraibo/repository/external.dart';
import 'package:miraibo/core-model/entity/category.dart' as model;
import 'package:miraibo/core-model/entity/currency.dart' as model;
import 'package:miraibo/core-model/entity/receipt_log.dart' as model;
import 'package:miraibo/core-model/entity/plan.dart' as model;
import 'package:miraibo/core-model/entity/estimation_scheme.dart' as model;
import 'package:miraibo/core-model/entity/monitor_scheme.dart' as model;
import 'package:miraibo/core-model/value/collection/category_collection.dart';
import 'package:miraibo/core-model/value/period.dart';
import 'package:miraibo/core-model/value/date.dart';
import 'package:miraibo/core-model/value/price.dart';
import 'package:miraibo/core-model/value/schedule.dart' as model;

void bind() {
  CategoryRepository.instance = CategoryRepositoryImpl();
  CurrencyRepository.instance = CurrencyRepositoryImpl();
  ReceiptLogRepository.instance = ReceiptLogRepositoryImpl();
  PlanRepository.instance = PlanRepositoryImpl();
  EstimationSchemeRepository.instance = EstimationSchemeRepositoryImpl();
  MonitorSchemeRepository.instance = MonitorSchemeRepositoryImpl();
  ErrorMessenger.instance = ErrorMessengerImpl();
  ExternalEnvironmentInterface.instance = ExternalEnvironmentInterfaceImpl();
}

class CategoryRepositoryImpl implements CategoryRepository {
  static final database = AppDatabase();

  @override
  Stream<List<model.Category>> watchAll() {
    return database.categories.select().watch().map((rows) {
      return rows.map((row) {
        return model.Category(
          id: row.id,
          name: row.name,
        );
      }).toList();
    });
  }

  @override
  Future<List<model.Category>> getAll() async {
    final response = await database.categories.select().get();
    return response.map((row) {
      return model.Category(
        id: row.id,
        name: row.name,
      );
    }).toList();
  }

  @override
  Future<model.Category?> find(String name) async {
    final query = database.categories.select();
    query.where((row) => row.name.equals(name));
    final response = await query.getSingleOrNull();
    if (response == null) return null;
    return model.Category(
      id: response.id,
      name: response.name,
    );
  }

  @override
  Future<void> insertAll(Iterable<model.Category> categories) async {
    await database.categories.insertAll(
        categories.map((modelCategory) => Category(
              id: modelCategory.id,
              name: modelCategory.name,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            )),
        mode: InsertMode.insertOrRollback);
  }

  @override
  Future<void> insert(model.Category category) async {
    await database.categories.insert().insert(
        Category(
          id: category.id,
          name: category.name,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        mode: InsertMode.insertOrRollback);
  }

  @override
  Future<void> update(model.Category category) async {
    final statement = database.categories.update()
      ..where((row) => row.id.equals(category.id));
    await statement.write(CategoriesCompanion(
      name: Value(category.name),
      updatedAt: Value(DateTime.now()),
    ));
  }

  @override
  Future<void> delete(model.Category category) async {
    final command = database.categories.delete();
    command.where((row) => row.id.equals(category.id));
    await command.go();
  }
}

class CurrencyRepositoryImpl implements CurrencyRepository {
  static final database = AppDatabase();
  static final keyValueStore = KeyValueStore();

  @override
  Stream<List<model.Currency>> watchAll() {
    return database.currencies.select().watch().map((rows) {
      return rows.map((row) {
        return model.Currency(
          id: row.id,
          symbol: row.symbol,
          ratio: row.ratio,
        );
      }).toList();
    });
  }

  @override
  Future<List<model.Currency>> getAll() async {
    return (await database.currencies.select().get()).map((row) {
      return model.Currency(
        id: row.id,
        symbol: row.symbol,
        ratio: row.ratio,
      );
    }).toList();
  }

  @override
  Future<model.Currency?> find(String symbol, double ratio) async {
    final query = database.currencies.select();
    query.where((row) => row.symbol.equals(symbol) & row.ratio.equals(ratio));
    final response = await query.getSingleOrNull();
    if (response == null) return null;
    return model.Currency(
      id: response.id,
      symbol: response.symbol,
      ratio: response.ratio,
    );
  }

  @override
  Future<model.Currency?> getDefault() async {
    final currencyId = await keyValueStore.getDefaultCurrencyId();
    if (currencyId == null) return null;
    final query = database.currencies.select()
      ..where((row) => row.id.equals(currencyId));
    final response = await query.getSingleOrNull();
    if (response == null) return null;
    return model.Currency(
      id: response.id,
      symbol: response.symbol,
      ratio: response.ratio,
    );
  }

  @override
  Future<void> setDefault(model.Currency currency) {
    return keyValueStore.setDefaultCurrencyId(currency.id);
  }

  @override
  Future<void> insert(model.Currency currency) {
    return database.currencies.insert().insert(
        Currency(
          id: currency.id,
          symbol: currency.symbol,
          ratio: currency.ratio,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        mode: InsertMode.insertOrRollback);
  }

  @override
  Future<void> update(model.Currency currency) {
    final statement = database.currencies.update()
      ..where((row) => row.id.equals(currency.id));
    return statement.write(CurrenciesCompanion(
      symbol: Value(currency.symbol),
      ratio: Value(currency.ratio),
      updatedAt: Value(DateTime.now()),
    ));
  }

  @override
  Future<void> delete(model.Currency currency) async {
    final command = database.currencies.delete();
    command.where((row) => row.id.equals(currency.id));
    await command.go();
  }
}

class ReceiptLogRepositoryImpl implements ReceiptLogRepository {
  static final database = AppDatabase();

  JoinedSelectStatement<HasResultSet, dynamic> _join(
      SimpleSelectStatement<ReceiptLogs, ReceiptLog> query) {
    return query.join(
      [
        innerJoin(
          database.categories,
          database.categories.id.equalsExp(database.receiptLogs.categoryId),
        ),
        innerJoin(
          database.currencies,
          database.currencies.id.equalsExp(database.receiptLogs.currencyId),
        ),
      ],
    );
  }

  model.ReceiptLog _parse(TypedResult row) {
    final receiptLog = row.readTable(database.receiptLogs);
    final category = row.readTable(database.categories);
    final currency = row.readTable(database.currencies);

    return model.ReceiptLog(
      id: receiptLog.id,
      date: Date.fromDateTime(receiptLog.date),
      category: model.Category(
        id: category.id,
        name: category.name,
      ),
      description: receiptLog.description,
      price: Price(
          amount: receiptLog.amount,
          currency: model.Currency(
            id: currency.id,
            symbol: currency.symbol,
            ratio: currency.ratio,
          )),
      confirmed: receiptLog.confirmed,
    );
  }

  @override
  Stream<List<model.ReceiptLog>> watchRows(int skip, int limit) {
    final query = database.receiptLogs.select();
    query.limit(limit, offset: skip);
    final jointQuery = _join(query);
    return jointQuery.watch().map((rows) {
      return rows.map(_parse).toList();
    });
  }

  @override
  Future<List<model.ReceiptLog>> getRows(int skip, int limit) async {
    final query = database.receiptLogs.select();
    query.limit(limit, offset: skip);
    final jointQuery = _join(query);
    final response = await jointQuery.get();
    return response.map(_parse).toList();
  }

  Stream<model.ReceiptLog> _queryToStream(
      SimpleSelectStatement<ReceiptLogs, ReceiptLog> query) async* {
    final jointQuery = _join(query);
    for (final row in await jointQuery.get()) {
      yield _parse(row);
    }
  }

  @override
  Stream<model.ReceiptLog> get(Period period, CategoryCollection categories,
      {bool? confirmed}) {
    final query = database.receiptLogs.select();
    if (!period.isStartless) {
      query.where(
          (row) => row.date.isBiggerOrEqualValue(period.begins.toDateTime()));
    }
    if (!period.isEndless) {
      query.where(
          (row) => row.date.isSmallerOrEqualValue(period.ends.toDateTime()));
    }
    if (!categories.containsAll) {
      query.where((row) => row.categoryId.isIn(categories.ids()));
    }
    if (confirmed != null) {
      query.where((row) => row.confirmed.equals(confirmed));
    }
    return _queryToStream(query);
  }

  @override
  Future<void> insert(model.ReceiptLog receiptLog) async {
    await database.receiptLogs.insert().insert(
        ReceiptLog(
          id: receiptLog.id,
          date: receiptLog.date.toDateTime(),
          categoryId: receiptLog.category.id,
          description: receiptLog.description,
          amount: receiptLog.price.amount,
          currencyId: receiptLog.price.currency.id,
          confirmed: receiptLog.confirmed,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        mode: InsertMode.insertOrRollback);
  }

  @override
  Future<void> update(model.ReceiptLog receiptLog) async {
    final statement = database.receiptLogs.update()
      ..where((row) => row.id.equals(receiptLog.id));
    await statement.write(ReceiptLogsCompanion(
      date: Value(receiptLog.date.toDateTime()),
      categoryId: Value(receiptLog.category.id),
      description: Value(receiptLog.description),
      amount: Value(receiptLog.price.amount),
      currencyId: Value(receiptLog.price.currency.id),
      confirmed: Value(receiptLog.confirmed),
      updatedAt: Value(DateTime.now()),
    ));
  }

  @override
  Future<void> delete(model.ReceiptLog receiptLog) async {
    final command = database.receiptLogs.delete();
    command.where((row) => row.id.equals(receiptLog.id));
    await command.go();
  }

  @override
  Future<void> replaceCategory(
      model.Category oldCategory, model.Category newCategory) async {
    final command = database.receiptLogs.update()
      ..where((row) => row.categoryId.equals(oldCategory.id));
    await command.write(ReceiptLogsCompanion(
      categoryId: Value(newCategory.id),
    ));
  }

  @override
  Stream<model.ReceiptLog> savedIn(model.Currency currency) {
    final query = database.receiptLogs.select()
      ..where((row) => row.currencyId.equals(currency.id));
    return _queryToStream(query);
  }
}

class PlanRepositoryImpl implements PlanRepository {
  static final database = AppDatabase();

  Stream<model.Plan> _queryToStream(
      SimpleSelectStatement<OneshotPlans, OneshotPlan> oneshotPlanQuery,
      SimpleSelectStatement<IntervalPlans, IntervalPlan> intervalPlanQuery,
      SimpleSelectStatement<WeeklyPlans, WeeklyPlan> weeklyPlanQuery,
      SimpleSelectStatement<MonthlyPlans, MonthlyPlan> monthlyPlanQuery,
      SimpleSelectStatement<AnnualPlans, AnnualPlan> annualPlanQuery) async* {
    final oneshotPlanJointQuery = oneshotPlanQuery.join(
      [
        innerJoin(
          database.categories,
          database.categories.id.equalsExp(database.oneshotPlans.categoryId),
        ),
        innerJoin(
          database.currencies,
          database.currencies.id.equalsExp(database.oneshotPlans.currencyId),
        ),
      ],
    );
    final intervalPlanJointQuery = intervalPlanQuery.join(
      [
        innerJoin(
          database.categories,
          database.categories.id.equalsExp(database.intervalPlans.categoryId),
        ),
        innerJoin(
          database.currencies,
          database.currencies.id.equalsExp(database.intervalPlans.currencyId),
        ),
      ],
    );
    final weeklyPlanJointQuery = weeklyPlanQuery.join(
      [
        innerJoin(
          database.categories,
          database.categories.id.equalsExp(database.weeklyPlans.categoryId),
        ),
        innerJoin(
          database.currencies,
          database.currencies.id.equalsExp(database.weeklyPlans.currencyId),
        ),
      ],
    );
    final monthlyPlanJointQuery = monthlyPlanQuery.join(
      [
        innerJoin(
          database.categories,
          database.categories.id.equalsExp(database.monthlyPlans.categoryId),
        ),
        innerJoin(
          database.currencies,
          database.currencies.id.equalsExp(database.monthlyPlans.currencyId),
        ),
      ],
    );
    final annualPlanJointQuery = annualPlanQuery.join(
      [
        innerJoin(
          database.categories,
          database.categories.id.equalsExp(database.annualPlans.categoryId),
        ),
        innerJoin(
          database.currencies,
          database.currencies.id.equalsExp(database.annualPlans.currencyId),
        ),
      ],
    );

    for (final row in await oneshotPlanJointQuery.get()) {
      final plan = row.readTable(database.oneshotPlans);
      final category = row.readTable(database.categories);
      final currency = row.readTable(database.currencies);
      yield model.Plan(
          id: plan.id,
          category: model.Category(
            id: category.id,
            name: category.name,
          ),
          description: plan.description,
          price: Price(
              amount: plan.amount,
              currency: model.Currency(
                id: currency.id,
                symbol: currency.symbol,
                ratio: currency.ratio,
              )),
          schedule: model.OneshotSchedule(date: Date.fromDateTime(plan.date)));
    }

    for (final row in await intervalPlanJointQuery.get()) {
      final plan = row.readTable(database.intervalPlans);
      final category = row.readTable(database.categories);
      final currency = row.readTable(database.currencies);
      yield model.Plan(
          id: plan.id,
          category: model.Category(
            id: category.id,
            name: category.name,
          ),
          description: plan.description,
          price: Price(
              amount: plan.amount,
              currency: model.Currency(
                id: currency.id,
                symbol: currency.symbol,
                ratio: currency.ratio,
              )),
          schedule: model.IntervalSchedule(
              originDate: Date.fromDateTime(plan.origin),
              period: Period(
                  begins: Date.fromDateTime(plan.periodBegins),
                  ends: Date.fromDateTime(plan.periodEnds)),
              interval: plan.interval));
    }

    for (final row in await weeklyPlanJointQuery.get()) {
      final plan = row.readTable(database.weeklyPlans);
      final category = row.readTable(database.categories);
      final currency = row.readTable(database.currencies);
      yield model.Plan(
          id: plan.id,
          category: model.Category(
            id: category.id,
            name: category.name,
          ),
          description: plan.description,
          price: Price(
              amount: plan.amount,
              currency: model.Currency(
                id: currency.id,
                symbol: currency.symbol,
                ratio: currency.ratio,
              )),
          schedule: model.WeeklySchedule(
              period: Period(
                  begins: Date.fromDateTime(plan.periodBegins),
                  ends: Date.fromDateTime(plan.periodEnds)),
              sunday: plan.sunday,
              monday: plan.monday,
              tuesday: plan.tuesday,
              wednesday: plan.tuesday,
              thursday: plan.tuesday,
              friday: plan.friday,
              saturday: plan.saturday));
    }

    for (final row in await monthlyPlanJointQuery.get()) {
      final plan = row.readTable(database.monthlyPlans);
      final category = row.readTable(database.categories);
      final currency = row.readTable(database.currencies);
      yield model.Plan(
          id: plan.id,
          category: model.Category(
            id: category.id,
            name: category.name,
          ),
          description: plan.description,
          price: Price(
              amount: plan.amount,
              currency: model.Currency(
                id: currency.id,
                symbol: currency.symbol,
                ratio: currency.ratio,
              )),
          schedule: model.MonthlySchedule(
              period: Period(
                  begins: Date.fromDateTime(plan.periodBegins),
                  ends: Date.fromDateTime(plan.periodEnds)),
              offset: plan.offset));
    }

    for (final row in await annualPlanJointQuery.get()) {
      final plan = row.readTable(database.annualPlans);
      final category = row.readTable(database.categories);
      final currency = row.readTable(database.currencies);
      yield model.Plan(
          id: plan.id,
          category: model.Category(
            id: category.id,
            name: category.name,
          ),
          description: plan.description,
          price: Price(
              amount: plan.amount,
              currency: model.Currency(
                id: currency.id,
                symbol: currency.symbol,
                ratio: currency.ratio,
              )),
          schedule: model.AnnualSchedule(
              period: Period(
                  begins: Date.fromDateTime(plan.periodBegins),
                  ends: Date.fromDateTime(plan.periodEnds)),
              originDate: Date.fromDateTime(plan.origin)));
    }
  }

  @override
  Stream<model.Plan> get(Period period, CategoryCollection categories) {
    final oneshotPlanQuery = database.oneshotPlans.select();
    final intervalPlanQuery = database.intervalPlans.select();
    final weeklyPlanQuery = database.weeklyPlans.select();
    final monthlyPlanQuery = database.monthlyPlans.select();
    final annualPlanQuery = database.annualPlans.select();
    if (!period.isStartless) {
      oneshotPlanQuery.where(
          (row) => row.date.isBiggerOrEqualValue(period.begins.toDateTime()));
      intervalPlanQuery.where((row) =>
          row.periodEnds.isBiggerOrEqualValue(period.begins.toDateTime()));
      weeklyPlanQuery.where((row) =>
          row.periodEnds.isBiggerOrEqualValue(period.begins.toDateTime()));
      monthlyPlanQuery.where((row) =>
          row.periodEnds.isBiggerOrEqualValue(period.begins.toDateTime()));
      annualPlanQuery.where((row) =>
          row.periodEnds.isBiggerOrEqualValue(period.begins.toDateTime()));
    }
    if (!period.isEndless) {
      oneshotPlanQuery.where(
          (row) => row.date.isSmallerOrEqualValue(period.ends.toDateTime()));
      intervalPlanQuery.where((row) =>
          row.periodBegins.isSmallerOrEqualValue(period.ends.toDateTime()));
      weeklyPlanQuery.where((row) =>
          row.periodBegins.isSmallerOrEqualValue(period.ends.toDateTime()));
      monthlyPlanQuery.where((row) =>
          row.periodBegins.isSmallerOrEqualValue(period.ends.toDateTime()));
      annualPlanQuery.where((row) =>
          row.periodBegins.isSmallerOrEqualValue(period.ends.toDateTime()));
    }
    if (!categories.containsAll) {
      oneshotPlanQuery.where((row) => row.categoryId.isIn(categories.ids()));
      intervalPlanQuery.where((row) => row.categoryId.isIn(categories.ids()));
      weeklyPlanQuery.where((row) => row.categoryId.isIn(categories.ids()));
      monthlyPlanQuery.where((row) => row.categoryId.isIn(categories.ids()));
      annualPlanQuery.where((row) => row.categoryId.isIn(categories.ids()));
    }
    return _queryToStream(oneshotPlanQuery, intervalPlanQuery, weeklyPlanQuery,
        monthlyPlanQuery, annualPlanQuery);
  }

  @override
  Future<void> insert(model.Plan plan) {
    switch (plan.schedule) {
      case model.OneshotSchedule schedule:
        return database.oneshotPlans.insert().insert(
            OneshotPlan(
              id: plan.id,
              date: schedule.date.toDateTime(),
              categoryId: plan.category.id,
              description: plan.description,
              amount: plan.price.amount,
              currencyId: plan.price.currency.id,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
            mode: InsertMode.insertOrRollback);
      case model.IntervalSchedule schedule:
        return database.intervalPlans.insert().insert(
            IntervalPlan(
                id: plan.id,
                origin: schedule.originDate.toDateTime(),
                periodBegins: schedule.period.begins.toDateTime(),
                periodEnds: schedule.period.ends.toDateTime(),
                interval: schedule.interval,
                categoryId: plan.category.id,
                description: plan.description,
                amount: plan.price.amount,
                currencyId: plan.price.currency.id,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now()),
            mode: InsertMode.insertOrRollback);
      case model.WeeklySchedule schedule:
        return database.weeklyPlans.insert().insert(
            WeeklyPlan(
                id: plan.id,
                periodBegins: schedule.period.begins.toDateTime(),
                periodEnds: schedule.period.ends.toDateTime(),
                sunday: schedule.sunday,
                monday: schedule.monday,
                tuesday: schedule.tuesday,
                wednesday: schedule.wednesday,
                thursday: schedule.thursday,
                friday: schedule.friday,
                saturday: schedule.saturday,
                categoryId: plan.category.id,
                description: plan.description,
                amount: plan.price.amount,
                currencyId: plan.price.currency.id,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now()),
            mode: InsertMode.insertOrRollback);
      case model.MonthlySchedule schedule:
        return database.monthlyPlans.insert().insert(
            MonthlyPlan(
                id: plan.id,
                amount: plan.price.amount,
                currencyId: plan.price.currency.id,
                description: plan.description,
                categoryId: plan.category.id,
                offset: schedule.offset,
                periodBegins: schedule.period.begins.toDateTime(),
                periodEnds: schedule.period.ends.toDateTime(),
                createdAt: DateTime.now(),
                updatedAt: DateTime.now()),
            mode: InsertMode.insertOrRollback);
      case model.AnnualSchedule schedule:
        return database.annualPlans.insert().insert(
            AnnualPlan(
                id: plan.id,
                amount: plan.price.amount,
                currencyId: plan.price.currency.id,
                description: plan.description,
                categoryId: plan.category.id,
                origin: schedule.originDate.toDateTime(),
                periodBegins: schedule.period.begins.toDateTime(),
                periodEnds: schedule.period.ends.toDateTime(),
                createdAt: DateTime.now(),
                updatedAt: DateTime.now()),
            mode: InsertMode.insertOrRollback);
    }
  }

  @override
  Future<void> update(model.Plan plan) async {
    DateTime createdAt = await database.plans.createdAtOf(plan.id);
    await database.plans.deleteWithId(plan.id);

    switch (plan.schedule) {
      case model.OneshotSchedule schedule:
        await database.oneshotPlans.insert().insert(
            OneshotPlan(
              id: plan.id,
              date: schedule.date.toDateTime(),
              categoryId: plan.category.id,
              description: plan.description,
              amount: plan.price.amount,
              currencyId: plan.price.currency.id,
              createdAt: createdAt,
              updatedAt: DateTime.now(),
            ),
            mode: InsertMode.insertOrRollback);
      case model.IntervalSchedule schedule:
        await database.intervalPlans.insert().insert(
            IntervalPlan(
                id: plan.id,
                origin: schedule.originDate.toDateTime(),
                periodBegins: schedule.period.begins.toDateTime(),
                periodEnds: schedule.period.ends.toDateTime(),
                interval: schedule.interval,
                categoryId: plan.category.id,
                description: plan.description,
                amount: plan.price.amount,
                currencyId: plan.price.currency.id,
                createdAt: createdAt,
                updatedAt: DateTime.now()),
            mode: InsertMode.insertOrRollback);
      case model.WeeklySchedule schedule:
        await database.weeklyPlans.insert().insert(
            WeeklyPlan(
                id: plan.id,
                periodBegins: schedule.period.begins.toDateTime(),
                periodEnds: schedule.period.ends.toDateTime(),
                sunday: schedule.sunday,
                monday: schedule.monday,
                tuesday: schedule.tuesday,
                wednesday: schedule.wednesday,
                thursday: schedule.thursday,
                friday: schedule.friday,
                saturday: schedule.saturday,
                categoryId: plan.category.id,
                description: plan.description,
                amount: plan.price.amount,
                currencyId: plan.price.currency.id,
                createdAt: createdAt,
                updatedAt: DateTime.now()),
            mode: InsertMode.insertOrRollback);
      case model.MonthlySchedule schedule:
        await database.monthlyPlans.insert().insert(
            MonthlyPlan(
                id: plan.id,
                amount: plan.price.amount,
                currencyId: plan.price.currency.id,
                description: plan.description,
                categoryId: plan.category.id,
                offset: schedule.offset,
                periodBegins: schedule.period.begins.toDateTime(),
                periodEnds: schedule.period.ends.toDateTime(),
                createdAt: createdAt,
                updatedAt: DateTime.now()),
            mode: InsertMode.insertOrRollback);
      case model.AnnualSchedule schedule:
        await database.annualPlans.insert().insert(
            AnnualPlan(
                id: plan.id,
                amount: plan.price.amount,
                currencyId: plan.price.currency.id,
                description: plan.description,
                categoryId: plan.category.id,
                origin: schedule.originDate.toDateTime(),
                periodBegins: schedule.period.begins.toDateTime(),
                periodEnds: schedule.period.ends.toDateTime(),
                createdAt: createdAt,
                updatedAt: DateTime.now()),
            mode: InsertMode.insertOrRollback);
    }
  }

  @override
  Future<void> delete(model.Plan plan) {
    return database.plans.deleteWithId(plan.id);
  }

  @override
  Future<void> replaceCategory(
      model.Category oldCategory, model.Category newCategory) async {
    final oneshotPlanCommand = database.oneshotPlans.update()
      ..where((row) => row.categoryId.equals(oldCategory.id));
    final intervalPlanCommand = database.intervalPlans.update()
      ..where((row) => row.categoryId.equals(oldCategory.id));
    final weeklyPlanCommand = database.weeklyPlans.update()
      ..where((row) => row.categoryId.equals(oldCategory.id));
    final monthlyPlanCommand = database.monthlyPlans.update()
      ..where((row) => row.categoryId.equals(oldCategory.id));
    final annualPlanCommand = database.annualPlans.update()
      ..where((row) => row.categoryId.equals(oldCategory.id));
    await database.transaction(() async {
      await oneshotPlanCommand.write(OneshotPlansCompanion(
        categoryId: Value(newCategory.id),
      ));
      await intervalPlanCommand.write(IntervalPlansCompanion(
        categoryId: Value(newCategory.id),
      ));
      await weeklyPlanCommand.write(WeeklyPlansCompanion(
        categoryId: Value(newCategory.id),
      ));
      await monthlyPlanCommand.write(MonthlyPlansCompanion(
        categoryId: Value(newCategory.id),
      ));
      await annualPlanCommand.write(AnnualPlansCompanion(
        categoryId: Value(newCategory.id),
      ));
    });
  }

  @override
  Stream<model.Plan> savedIn(model.Currency currency) {
    final oneshotPlanQuery = database.oneshotPlans.select()
      ..where((row) => row.currencyId.equals(currency.id));
    final intervalPlanQuery = database.intervalPlans.select()
      ..where((row) => row.currencyId.equals(currency.id));
    final weeklyPlanQuery = database.weeklyPlans.select()
      ..where((row) => row.currencyId.equals(currency.id));
    final monthlyPlanQuery = database.monthlyPlans.select()
      ..where((row) => row.currencyId.equals(currency.id));
    final annualPlanQuery = database.annualPlans.select()
      ..where((row) => row.currencyId.equals(currency.id));
    return _queryToStream(oneshotPlanQuery, intervalPlanQuery, weeklyPlanQuery,
        monthlyPlanQuery, annualPlanQuery);
  }
}

class EstimationSchemeRepositoryImpl implements EstimationSchemeRepository {
  static final database = AppDatabase();

  Stream<model.EstimationScheme> _queryToStream(
      SimpleSelectStatement<EstimationSchemes, EstimationScheme> query) async* {
    final jointQuery = query.join([
      innerJoin(
        database.currencies,
        database.estimationSchemes.currencyId.equalsExp(database.currencies.id),
      ),
      innerJoin(
        database.categories,
        database.estimationSchemes.categoryId.equalsExp(database.categories.id),
      )
    ]);
    for (final row in await jointQuery.get()) {
      final scheme = row.readTable(database.estimationSchemes);
      final currency = row.readTable(database.currencies);
      final category = row.readTable(database.categories);
      yield model.EstimationScheme(
        id: scheme.id,
        displayOption: scheme.displayOption,
        period: Period(
            begins: Date.fromDateTime(scheme.periodBegins),
            ends: Date.fromDateTime(scheme.periodEnds)),
        currency: model.Currency(
          id: currency.id,
          symbol: currency.symbol,
          ratio: currency.ratio,
        ),
        category: model.Category(
          id: category.id,
          name: category.name,
        ),
      );
    }
  }

  @override
  Stream<model.EstimationScheme> get(
      Period period, CategoryCollection categories) {
    final query = database.estimationSchemes.select();
    if (!period.isStartless) {
      query.where((row) =>
          row.periodEnds.isBiggerOrEqualValue(period.begins.toDateTime()));
    }
    if (!period.isEndless) {
      query.where((row) =>
          row.periodBegins.isSmallerOrEqualValue(period.ends.toDateTime()));
    }
    if (!categories.containsAll) {
      query.where((row) => row.categoryId.isIn(categories.ids()));
    }
    return _queryToStream(query);
  }

  @override
  Future<void> insert(model.EstimationScheme estimationScheme) async {
    await database.estimationSchemes.insert().insert(
        EstimationScheme(
          id: estimationScheme.id,
          periodBegins: estimationScheme.period.begins.toDateTime(),
          periodEnds: estimationScheme.period.ends.toDateTime(),
          currencyId: estimationScheme.currency.id,
          categoryId: estimationScheme.category.id,
          displayOption: estimationScheme.displayOption,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        mode: InsertMode.insertOrRollback);
  }

  @override
  Future<void> update(model.EstimationScheme estimationScheme) async {
    final statement = database.estimationSchemes.update()
      ..where((row) => row.id.equals(estimationScheme.id));
    await statement.write(
      EstimationSchemesCompanion(
        periodBegins: Value(estimationScheme.period.begins.toDateTime()),
        periodEnds: Value(estimationScheme.period.ends.toDateTime()),
        currencyId: Value(estimationScheme.currency.id),
        categoryId: Value(estimationScheme.category.id),
        displayOption: Value(estimationScheme.displayOption),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> delete(model.EstimationScheme estimationScheme) async {
    final command = database.estimationSchemes.delete();
    command.where((row) => row.id.equals(estimationScheme.id));
    await command.go();
  }

  @override
  Future<void> replaceCategory(
      model.Category oldCategory, model.Category newCategory) async {
    final command = database.estimationSchemes.update();
    command.where((row) => row.categoryId.equals(oldCategory.id));
    await command.write(EstimationSchemesCompanion(
      categoryId: Value(newCategory.id),
    ));
  }

  @override
  Stream<model.EstimationScheme> savedIn(model.Currency currency) {
    final query = database.estimationSchemes.select()
      ..where((row) => row.currencyId.equals(currency.id));
    return _queryToStream(query);
  }
}

class MonitorSchemeRepositoryImpl implements MonitorSchemeRepository {
  static final database = AppDatabase();

  model.MonitorScheme _parseIntoModel(
    List<model.Category> categoryList,
    MonitorScheme scheme,
    Currency currency,
  ) {
    return model.MonitorScheme(
      id: scheme.id,
      period: Period(
          begins: Date.fromDateTime(scheme.periodBegins),
          ends: Date.fromDateTime(scheme.periodEnds)),
      currency: model.Currency(
        id: currency.id,
        symbol: currency.symbol,
        ratio: currency.ratio,
      ),
      displayOption: scheme.displayOption,
      categories: categoryList.isEmpty
          ? CategoryCollection.phantomAll
          : CategoryCollection(categories: categoryList),
    );
  }

  Stream<model.MonitorScheme> _queryToStream(
      SimpleSelectStatement<MonitorSchemes, MonitorScheme> query) async* {
    final jointQuery = query.join([
      innerJoin(
        database.currencies,
        database.monitorSchemes.currencyId.equalsExp(database.currencies.id),
      ),
      leftOuterJoin(
        database.monitorSchemeCategoryLinkers,
        database.monitorSchemes.id
            .equalsExp(database.monitorSchemeCategoryLinkers.scheme),
      ),
      leftOuterJoin(
        database.categories,
        database.monitorSchemeCategoryLinkers.category
            .equalsExp(database.categories.id),
      ),
    ]);
    List<model.Category> buffer = [];
    MonitorScheme? lastScheme;
    Currency? lastCurrency;
    for (final row in await jointQuery.get()) {
      final scheme = row.readTable(database.monitorSchemes);
      final currency = row.readTable(database.currencies);
      final category = row.readTableOrNull(database.categories);

      if (lastScheme?.id != scheme.id &&
          lastScheme != null &&
          lastCurrency != null) {
        yield _parseIntoModel(buffer, lastScheme, lastCurrency);
        buffer.clear();
      }

      if (category != null) {
        buffer.add(model.Category(
          id: category.id,
          name: category.name,
        ));
      }
      lastScheme = scheme;
      lastCurrency = currency;
    }
    if (lastScheme != null && lastCurrency != null) {
      yield _parseIntoModel(buffer, lastScheme, lastCurrency);
    }
  }

  @override
  Stream<model.MonitorScheme> get(
      Period period, CategoryCollection categories) async* {
    final query = database.monitorSchemes.select();
    if (!period.isStartless) {
      query.where((row) =>
          row.periodEnds.isBiggerOrEqualValue(period.begins.toDateTime()));
    }
    if (!period.isEndless) {
      query.where((row) =>
          row.periodBegins.isSmallerOrEqualValue(period.ends.toDateTime()));
    }
    await for (final monitor in _queryToStream(query)) {
      if (categories.containsAll || monitor.categories.containsAll) {
        yield monitor;
        continue;
      }
      // return it if there is intersection between monitor's categories and given categories
      if (monitor.categories.list
          .any((category) => categories.list.contains(category))) {
        yield monitor;
      }
    }
  }

  @override
  Future<void> replaceCategory(
      model.Category oldCategory, model.Category newCategory) async {
    final command = database.monitorSchemeCategoryLinkers.update();
    command.where((row) => row.category.equals(oldCategory.id));
    await command.write(MonitorSchemeCategoryLinkersCompanion(
      category: Value(newCategory.id),
    ));
  }

  @override
  Stream<model.MonitorScheme> savedIn(model.Currency currency) {
    final query = database.monitorSchemes.select();
    query.where((row) => row.currencyId.equals(currency.id));
    return _queryToStream(query);
  }

  @override
  Future<void> insert(model.MonitorScheme monitorScheme) async {
    final now = DateTime.now();
    await database.monitorSchemes.insert().insert(MonitorScheme(
        id: monitorScheme.id,
        periodBegins: monitorScheme.period.begins.toDateTime(),
        periodEnds: monitorScheme.period.ends.toDateTime(),
        displayOption: monitorScheme.displayOption,
        currencyId: monitorScheme.currency.id,
        createdAt: now,
        updatedAt: now));
    if (monitorScheme.categories.containsAll) return;
    await database.monitorSchemeCategoryLinkers.insertAll([
      for (final category in monitorScheme.categories.list)
        MonitorSchemeCategoryLinker(
          scheme: monitorScheme.id,
          category: category.id,
          createdAt: now,
        ),
    ]);
  }

  @override
  Future<void> update(model.MonitorScheme monitorScheme) async {
    final statement = database.monitorSchemes.update()
      ..where((row) => row.id.equals(monitorScheme.id));
    await statement.write(
      MonitorSchemesCompanion(
        periodBegins: Value(monitorScheme.period.begins.toDateTime()),
        periodEnds: Value(monitorScheme.period.ends.toDateTime()),
        currencyId: Value(monitorScheme.currency.id),
        displayOption: Value(monitorScheme.displayOption),
        updatedAt: Value(DateTime.now()),
      ),
    );
    // reset linker
    final linkerReleaseCommand = database.monitorSchemeCategoryLinkers.delete()
      ..where((row) => row.scheme.equals(monitorScheme.id));
    await linkerReleaseCommand.go();
    if (monitorScheme.categories.containsAll) return;
    final now = DateTime.now();
    await database.monitorSchemeCategoryLinkers.insertAll([
      for (final category in monitorScheme.categories.list)
        MonitorSchemeCategoryLinker(
          scheme: monitorScheme.id,
          category: category.id,
          createdAt: now,
        ),
    ]);
  }

  @override
  Future<void> delete(model.MonitorScheme monitorScheme) async {
    final schemeDeleteCommand = database.monitorSchemes.delete();
    schemeDeleteCommand.where((row) => row.id.equals(monitorScheme.id));
    await schemeDeleteCommand.go();
    final linkerDeleteCommand = database.monitorSchemeCategoryLinkers.delete();
    linkerDeleteCommand.where((row) => row.scheme.equals(monitorScheme.id));
    await linkerDeleteCommand.go();
  }
}

class ErrorMessengerImpl implements ErrorMessenger {
  @override
  void writeToErrorLogFile(String error) async {
    Directory directory;
    if (kIsWeb) {
      throw UnimplementedError('Error logging for Web is not supported');
    } else {
      directory = await getTemporaryDirectory();
    }
    final file = File(join(directory.path, 'miraibo-error.log'));
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
    file.writeAsStringSync('$error\n', mode: FileMode.append);
  }
}

class ExternalEnvironmentInterfaceImpl implements ExternalEnvironmentInterface {
  @override
  Future<void> generateFile(String path, Stream<String> content) async {
    final file = File(path);
    if (await file.exists()) await file.delete();
    await file.create(recursive: true);
    await for (final segment in content) {
      await file.writeAsString(segment, mode: FileMode.append, encoding: utf8);
    }
  }

  @override
  Future<Stream<String>?> loadFile(String path) async {
    final file = File(path);
    if (!await file.exists()) return null;
    return utf8.decoder.bind(file.openRead());
  }
}
