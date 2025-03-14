import 'package:miraibo/dto/dto.dart';
import 'package:miraibo/shared/enumeration.dart';
import 'package:miraibo/core-model/value/price.dart' as model;
import 'package:miraibo/core-model/value/schedule.dart' as model;
import 'package:miraibo/core-model/value/date.dart' as model;
import 'package:miraibo/core-model/entity/category.dart' as model;
import 'package:miraibo/core-model/entity/currency.dart' as model;
import 'package:miraibo/core-model/entity/estimation_scheme.dart' as model;
import 'package:miraibo/core-model/value/collection/category_collection.dart'
    as model;
import 'package:miraibo/core-model/entity/monitor_scheme.dart' as model;
import 'package:miraibo/core-model/entity/receipt_log.dart' as model;
import 'package:miraibo/core-model/entity/plan.dart' as model;
import 'package:miraibo/core-model/value/period.dart' as model;
import 'package:miraibo/external-model/service/error_handling_service.dart';

// <for ReceiptLog>

/// {@template createReceiptLog}
/// returns the id of the created receipt log
/// {@endtemplate}
Future<int> createReceiptLog({
  required Date originDate,
  required int amount,
  required int currencyId,
  required int categoryId,
  required String description,
  required bool confirmed,
}) async {
  final currency = await model.Currency.get(currencyId);
  final category = await model.Category.get(categoryId);
  if (category == null) {
    ErrorHandlingService.logException(
        Exception('category not found: $categoryId'));
    return -1;
  }
  if (currency == null) {
    ErrorHandlingService.logException(
        Exception('currency not found: $currencyId'));
    return -1;
  }
  final log = await model.ReceiptLog.create(
    model.Date(originDate.year, originDate.month, originDate.day),
    model.Price(amount: amount.toDouble(), currency: currency),
    description,
    category,
    confirmed,
  );
  return log.id;
}

Future<void> editReceiptLog({
  required int id,
  required Date originDate,
  required int amount, // price
  required int currencyId, // price
  required int categoryId, // category
  required String description, // description
  required bool confirmed, // confirmed
}) async {
  final category = await model.Category.get(categoryId);
  final currency = await model.Currency.get(currencyId);
  final log = await model.ReceiptLog.watch(id).first;
  if (category == null) {
    ErrorHandlingService.logException(
        Exception('category not found: $categoryId'));
    return;
  }
  if (currency == null) {
    ErrorHandlingService.logException(
        Exception('currency not found: $currencyId'));
    return;
  }
  if (log == null) {
    ErrorHandlingService.logException(Exception('log not found'));
    return;
  }
  await log.update(
    date: model.Date(originDate.year, originDate.month, originDate.day),
    price: model.Price(amount: amount.toDouble(), currency: currency),
    description: description,
    category: category,
    confirmed: confirmed,
  );
}

Future<void> deleteReceiptLog(int id) async {
  final log = await model.ReceiptLog.watch(id).first;
  if (log == null) {
    ErrorHandlingService.logException(Exception('log not found'));
    return;
  }
  await log.delete();
}

// </for ReceiptLog>
// <for Plan>

/// {@template createPlan}
/// returns the id of the created plan
/// {@endtemplate}
Future<int> createPlan(
  Schedule schedule,
  int amount, // price
  int currencyId, // price
  int categoryId, // category
  String description, // description
) async {
  final category = await model.Category.get(categoryId);
  final currency = await model.Currency.get(currencyId);
  if (category == null) {
    ErrorHandlingService.logException(
        Exception('category not found: $categoryId'));
    return -1;
  }
  if (currency == null) {
    ErrorHandlingService.logException(
        Exception('currency not found: $currencyId'));
    return -1;
  }
  final model.Schedule modelSchedule = switch (schedule) {
    OneshotSchedule oneshot => model.OneshotSchedule(
        date:
            model.Date(oneshot.date.year, oneshot.date.month, oneshot.date.day),
      ),
    IntervalSchedule interval => model.IntervalSchedule(
        originDate: model.Date(interval.originDate.year,
            interval.originDate.month, interval.originDate.day),
        interval: interval.interval,
        period: model.Period(
          begins: interval.period.begins != null
              ? model.Date(interval.period.begins!.year,
                  interval.period.begins!.month, interval.period.begins!.day)
              : model.Date.earliest,
          ends: interval.period.ends != null
              ? model.Date(interval.period.ends!.year,
                  interval.period.ends!.month, interval.period.ends!.day)
              : model.Date.latest,
        ),
      ),
    WeeklySchedule weeklySchedule => model.WeeklySchedule(
        sunday: weeklySchedule.sunday,
        monday: weeklySchedule.monday,
        tuesday: weeklySchedule.tuesday,
        wednesday: weeklySchedule.wednesday,
        thursday: weeklySchedule.thursday,
        friday: weeklySchedule.friday,
        saturday: weeklySchedule.saturday,
        period: model.Period(
          begins: weeklySchedule.period.begins != null
              ? model.Date(
                  weeklySchedule.period.begins!.year,
                  weeklySchedule.period.begins!.month,
                  weeklySchedule.period.begins!.day)
              : model.Date.earliest,
          ends: weeklySchedule.period.ends != null
              ? model.Date(
                  weeklySchedule.period.ends!.year,
                  weeklySchedule.period.ends!.month,
                  weeklySchedule.period.ends!.day)
              : model.Date.latest,
        ),
      ),
    MonthlySchedule monthly => model.MonthlySchedule(
        offset: monthly.offset,
        period: model.Period(
          begins: monthly.period.begins != null
              ? model.Date(monthly.period.begins!.year,
                  monthly.period.begins!.month, monthly.period.begins!.day)
              : model.Date.earliest,
          ends: monthly.period.ends != null
              ? model.Date(monthly.period.ends!.year,
                  monthly.period.ends!.month, monthly.period.ends!.day)
              : model.Date.latest,
        ),
      ),
    AnnualSchedule annual => model.AnnualSchedule(
        originDate: model.Date(annual.originDate.year, annual.originDate.month,
            annual.originDate.day),
        period: model.Period(
          begins: annual.period.begins != null
              ? model.Date(annual.period.begins!.year,
                  annual.period.begins!.month, annual.period.begins!.day)
              : model.Date.earliest,
          ends: annual.period.ends != null
              ? model.Date(annual.period.ends!.year, annual.period.ends!.month,
                  annual.period.ends!.day)
              : model.Date.latest,
        ),
      ),
  };
  final plan = await model.Plan.create(
    modelSchedule,
    model.Price(amount: amount.toDouble(), currency: currency),
    description,
    category,
  );
  return plan.id;
}

Future<void> editPlan(
  int id,
  Schedule schedule,
  int amount, // price
  int currencyId, // price
  int categoryId, // category
  String description, // description
) async {
  final plan = await model.Plan.watch(id).first;
  final category = await model.Category.get(categoryId);
  final currency = await model.Currency.get(currencyId);
  if (category == null) {
    ErrorHandlingService.logException(
        Exception('category not found: $categoryId'));
    return;
  }
  if (currency == null) {
    ErrorHandlingService.logException(
        Exception('currency not found: $currencyId'));
    return;
  }
  if (plan == null) {
    ErrorHandlingService.logException(Exception('plan not found: $id'));
    return;
  }
  final model.Schedule modelSchedule = switch (schedule) {
    OneshotSchedule oneshot => model.OneshotSchedule(
        date:
            model.Date(oneshot.date.year, oneshot.date.month, oneshot.date.day),
      ),
    IntervalSchedule interval => model.IntervalSchedule(
        originDate: model.Date(interval.originDate.year,
            interval.originDate.month, interval.originDate.day),
        interval: interval.interval,
        period: model.Period(
          begins: interval.period.begins != null
              ? model.Date(interval.period.begins!.year,
                  interval.period.begins!.month, interval.period.begins!.day)
              : model.Date.earliest,
          ends: interval.period.ends != null
              ? model.Date(interval.period.ends!.year,
                  interval.period.ends!.month, interval.period.ends!.day)
              : model.Date.latest,
        ),
      ),
    WeeklySchedule weeklySchedule => model.WeeklySchedule(
        sunday: weeklySchedule.sunday,
        monday: weeklySchedule.monday,
        tuesday: weeklySchedule.tuesday,
        wednesday: weeklySchedule.wednesday,
        thursday: weeklySchedule.thursday,
        friday: weeklySchedule.friday,
        saturday: weeklySchedule.saturday,
        period: model.Period(
          begins: weeklySchedule.period.begins != null
              ? model.Date(
                  weeklySchedule.period.begins!.year,
                  weeklySchedule.period.begins!.month,
                  weeklySchedule.period.begins!.day)
              : model.Date.earliest,
          ends: weeklySchedule.period.ends != null
              ? model.Date(
                  weeklySchedule.period.ends!.year,
                  weeklySchedule.period.ends!.month,
                  weeklySchedule.period.ends!.day)
              : model.Date.latest,
        ),
      ),
    MonthlySchedule monthly => model.MonthlySchedule(
        offset: monthly.offset,
        period: model.Period(
          begins: monthly.period.begins != null
              ? model.Date(monthly.period.begins!.year,
                  monthly.period.begins!.month, monthly.period.begins!.day)
              : model.Date.earliest,
          ends: monthly.period.ends != null
              ? model.Date(monthly.period.ends!.year,
                  monthly.period.ends!.month, monthly.period.ends!.day)
              : model.Date.latest,
        ),
      ),
    AnnualSchedule annual => model.AnnualSchedule(
        originDate: model.Date(annual.originDate.year, annual.originDate.month,
            annual.originDate.day),
        period: model.Period(
          begins: annual.period.begins != null
              ? model.Date(annual.period.begins!.year,
                  annual.period.begins!.month, annual.period.begins!.day)
              : model.Date.earliest,
          ends: annual.period.ends != null
              ? model.Date(annual.period.ends!.year, annual.period.ends!.month,
                  annual.period.ends!.day)
              : model.Date.latest,
        ),
      ),
  };
  await plan.update(
    schedule: modelSchedule,
    price: model.Price(amount: amount.toDouble(), currency: currency),
    description: description,
    category: category,
  );
}

Future<void> deletePlan(int id) async {
  final plan = await model.Plan.watch(id).first;
  if (plan == null) {
    ErrorHandlingService.logException(Exception('plan not found: $id'));
    return;
  }
  await plan.delete();
}

// </for Plan>
// <for EstimationScheme>

/// {@template createEstimationScheme}
/// returns the id of the created estimation scheme
/// {@endtemplate}
Future<int> createEstimationScheme(
  OpenPeriod period,
  int categoryId,
  EstimationDisplayOption displayOption,
  int currencyId, // displayOption
) async {
  final currency = await model.Currency.get(currencyId);
  final category = await model.Category.get(categoryId);
  if (currency == null) {
    ErrorHandlingService.logException(
        Exception('currency not found: $currencyId'));
    return -1;
  }
  if (category == null) {
    ErrorHandlingService.logException(
        Exception('category not found: $categoryId'));
    return -1;
  }
  final estimationScheme = await model.EstimationScheme.create(
    model.Period(
      begins: model.Date(
          period.begins!.year, period.begins!.month, period.begins!.day),
      ends: model.Date(period.ends!.year, period.ends!.month, period.ends!.day),
    ),
    currency,
    displayOption,
    category,
  );
  return estimationScheme.id;
}

Future<void> editEstimationScheme(
  int id,
  OpenPeriod period,
  List<int> categoryIds,
  EstimationDisplayOption displayOption,
  int currencyId, // displayOption
) async {
  final estimationScheme = await model.EstimationScheme.watch(id).first;
  final currency = await model.Currency.get(currencyId);
  final category = await model.Category.get(categoryIds.first);
  if (currency == null) {
    ErrorHandlingService.logException(
        Exception('currency not found: $currencyId'));
    return;
  }
  if (category == null) {
    ErrorHandlingService.logException(
        Exception('category not found: ${categoryIds.first}'));
    return;
  }
  if (estimationScheme == null) {
    ErrorHandlingService.logException(Exception('estimationScheme not found'));
    return;
  }
  await estimationScheme.update(
    period: model.Period(
      begins: model.Date(
          period.begins!.year, period.begins!.month, period.begins!.day),
      ends: model.Date(period.ends!.year, period.ends!.month, period.ends!.day),
    ),
    currency: currency,
    displayOption: displayOption,
    category: category,
  );
}

Future<void> deleteEstimationScheme(int id) async {
  final estimationScheme = await model.EstimationScheme.watch(id).first;
  if (estimationScheme == null) {
    ErrorHandlingService.logException(Exception('estimationScheme not found'));
    return;
  }
  await estimationScheme.delete();
}

// </for EstimationScheme>
// <for MonitorScheme>

/// {@template createMonitorScheme}
/// returns the id of the created monitor scheme
/// {@endtemplate}
Future<int> createMonitorScheme(
  OpenPeriod period,
  List<int> categoryIds,
  MonitorDisplayOption displayOption,
  int currencyId,
) async {
  final currency = await model.Currency.get(currencyId);
  final model.CategoryCollection categories;
  if (categoryIds.isEmpty) {
    categories = model.CategoryCollection.phantomAll;
  } else {
    final categoryList = <model.Category>[];
    for (final categoryId in categoryIds) {
      final category = await model.Category.get(categoryId);
      if (category == null) {
        ErrorHandlingService.logException(
            Exception('category not found: $categoryId'));
        return -1;
      }
    }
    categories = model.CategoryCollection(categories: categoryList);
  }
  if (currency == null) {
    ErrorHandlingService.logException(
        Exception('currency not found: $currencyId'));
    return -1;
  }
  final monitorScheme = await model.MonitorScheme.create(
    model.Period(
      begins: model.Date(
          period.begins!.year, period.begins!.month, period.begins!.day),
      ends: model.Date(period.ends!.year, period.ends!.month, period.ends!.day),
    ),
    currency,
    displayOption,
    categories,
  );
  return monitorScheme.id;
}

Future<void> editMonitorScheme(
  int id,
  OpenPeriod period,
  List<int> categoryIds,
  MonitorDisplayOption displayOption,
  int currencyId,
) async {
  final monitorScheme = await model.MonitorScheme.watch(id).first;
  final currency = await model.Currency.get(currencyId);
  final model.CategoryCollection categories;
  if (categoryIds.isEmpty) {
    categories = model.CategoryCollection.phantomAll;
  } else {
    final categoryList = <model.Category>[];
    for (final categoryId in categoryIds) {
      final category = await model.Category.get(categoryId);
      if (category == null) {
        ErrorHandlingService.logException(
            Exception('category not found: $categoryId'));
        return;
      }
    }
    categories = model.CategoryCollection(categories: categoryList);
  }
  if (currency == null) {
    ErrorHandlingService.logException(
        Exception('currency not found: $currencyId'));
    return;
  }
  if (monitorScheme == null) {
    ErrorHandlingService.logException(Exception('monitorScheme not found'));
    return;
  }
  await monitorScheme.update(
    period: model.Period(
      begins: model.Date(
          period.begins!.year, period.begins!.month, period.begins!.day),
      ends: model.Date(period.ends!.year, period.ends!.month, period.ends!.day),
    ),
    currency: currency,
    displayOption: displayOption,
    categories: categories,
  );
}

Future<void> deleteMonitorScheme(int id) async {
  final monitorScheme = await model.MonitorScheme.watch(id).first;
  if (monitorScheme == null) {
    ErrorHandlingService.logException(Exception('monitorScheme not found'));
    return;
  }
  await monitorScheme.delete();
}

// </for MonitorScheme>
