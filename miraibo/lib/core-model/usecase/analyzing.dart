import 'package:miraibo/dto/dto.dart';
import 'package:miraibo/shared/enumeration.dart';
import 'package:miraibo/core-model/entity/estimation_scheme.dart' as model;
import 'package:miraibo/core-model/value/period.dart' as model;
import 'package:miraibo/core-model/value/date.dart' as model;
import 'package:miraibo/core-model/entity/currency.dart' as model;
import 'package:miraibo/core-model/entity/monitor_scheme.dart' as model;
import 'package:miraibo/core-model/entity/category.dart' as model;
import 'package:miraibo/core-model/value/collection/category_collection.dart'
    as model;

/// {@template estimateWithScheme}
/// estimates the price of the given schedule with the given estimation scheme.
/// {@endtemplate}
Future<EstimationTicket> estimateWithScheme(int categoryId, int currencyId,
    EstimationDisplayOption displayOption) async {
  final temporaryEstimationScheme = model.EstimationScheme(
    id: 0,
    period: model.Period.entirePeriod,
    currency: (await model.Currency.get(currencyId))!,
    category: (await model.Category.get(categoryId))!,
    displayOption: displayOption,
  );
  final price = await temporaryEstimationScheme.scaledEstimation();
  return EstimationTicket(
    id: temporaryEstimationScheme.id,
    price: Price(amount: price.amount.toInt(), symbol: price.currency.symbol),
    displayOption: temporaryEstimationScheme.displayOption,
    categoryName: temporaryEstimationScheme.category.name,
    period: OpenPeriod(begins: null, ends: null),
  );
}

Stream<EstimationTicket> estimateFor(int estimationSchemeId) async* {
  final estimationScheme = model.EstimationScheme.watch(estimationSchemeId);
  await for (final scheme in estimationScheme) {
    if (scheme == null) {
      return;
    }
    final price = await scheme.scaledEstimation();
    yield EstimationTicket(
      id: scheme.id,
      price: Price(amount: price.amount.toInt(), symbol: price.currency.symbol),
      displayOption: scheme.displayOption,
      categoryName: scheme.category.name,
      period: OpenPeriod(
        begins: Date(
          scheme.period.begins.year,
          scheme.period.begins.month,
          scheme.period.begins.day,
        ),
        ends: Date(
          scheme.period.ends.year,
          scheme.period.ends.month,
          scheme.period.ends.day,
        ),
      ),
    );
  }
}

/// {@template monitorWithScheme}
/// return the price of the given monitor scheme.
/// {@endtemplate}
Future<MonitorTicket> monitorWithScheme(
    OpenPeriod period,
    List<int> categoryIds,
    MonitorDisplayOption displayOption,
    int currencyId) async {
  model.CategoryCollection categories;
  if (categoryIds.isEmpty) {
    categories = model.CategoryCollection.phantomAll;
  } else {
    List<model.Category> categoryList = [];
    for (final categoryId in categoryIds) {
      categoryList.add((await model.Category.get(categoryId))!);
    }
    categories = model.CategoryCollection(categories: categoryList);
  }
  final temporaryMonitorScheme = model.MonitorScheme(
    id: 0,
    period: model.Period(
      begins: period.begins != null
          ? model.Date(
              period.begins!.year, period.begins!.month, period.begins!.day)
          : model.Date.earliest,
      ends: period.ends != null
          ? model.Date(period.ends!.year, period.ends!.month, period.ends!.day)
          : model.Date.latest,
    ),
    currency: (await model.Currency.get(currencyId))!,
    displayOption: displayOption,
    categories: categories,
  );
  final price = await temporaryMonitorScheme.getValue();
  return MonitorTicket(
    id: temporaryMonitorScheme.id,
    price: Price(amount: price.amount.toInt(), symbol: price.currency.symbol),
    displayOption: temporaryMonitorScheme.displayOption,
    categoryNames:
        temporaryMonitorScheme.categories.list.map((e) => e.name).toList(),
    period: OpenPeriod(
      begins: Date(
        temporaryMonitorScheme.period.begins.year,
        temporaryMonitorScheme.period.begins.month,
        temporaryMonitorScheme.period.begins.day,
      ),
      ends: Date(
        temporaryMonitorScheme.period.ends.year,
        temporaryMonitorScheme.period.ends.month,
        temporaryMonitorScheme.period.ends.day,
      ),
    ),
  );
}

Stream<MonitorTicket> monitorFor(int monitorSchemeId) async* {
  final monitorScheme = model.MonitorScheme.watch(monitorSchemeId);
  await for (final scheme in monitorScheme) {
    if (scheme == null) {
      return;
    }
    final price = await scheme.getValue();
    yield MonitorTicket(
      id: scheme.id,
      price: Price(amount: price.amount.toInt(), symbol: price.currency.symbol),
      displayOption: scheme.displayOption,
      categoryNames: scheme.categories.list.map((e) => e.name).toList(),
      period: OpenPeriod(
        begins: Date(
          scheme.period.begins.year,
          scheme.period.begins.month,
          scheme.period.begins.day,
        ),
        ends: Date(
          scheme.period.ends.year,
          scheme.period.ends.month,
          scheme.period.ends.day,
        ),
      ),
    );
  }
}
