import 'package:miraibo/dto/dto.dart';
import 'package:miraibo/core-model/value/collection/record_collection.dart'
    as model;
import 'package:miraibo/core-model/entity/category.dart' as model;
import 'package:miraibo/core-model/value/collection/category_collection.dart'
    as model;
import 'package:miraibo/core-model/value/date.dart' as model;
import 'package:miraibo/core-model/value/period.dart' as model;
import 'package:miraibo/core-model/entity/currency.dart' as model;

/// {@template getValuesOfPieChart}
/// returns the values to make a pie chart.
///
/// [currencyId] is the id of the currency to convert all currencies to.
///
/// [analysisRange] is the range to analyze.
/// Records in the range are summed up by category.
///
/// [categoryIds] is the list of category ids to analyze.
/// If it is not empty, only records whose category is in the given list are counted.
/// If it is empty, all categories are counted.
/// {@endtemplate}
Future<List<RatioValue>> getValuesOfPieChart(
    int currencyId, OpenPeriod analysisRange, List<int> categoryIds) async {
  final currency = (await model.Currency.get(currencyId))!;
  List<model.Category> categories;
  if (categoryIds.isEmpty) {
    categories = await model.CategoryCollection.getAll();
  } else {
    categories = [];
    for (final categoryId in categoryIds) {
      categories.add((await model.Category.get(categoryId))!);
    }
  }
  final buffer = <(String, double)>[];
  for (final category in categories) {
    final records = await model.RecordCollection.get(
        model.Period(
          begins: analysisRange.begins != null
              ? model.Date(
                  analysisRange.begins!.year,
                  analysisRange.begins!.month,
                  analysisRange.begins!.day,
                )
              : model.Date.earliest,
          ends: analysisRange.ends != null
              ? model.Date(
                  analysisRange.ends!.year,
                  analysisRange.ends!.month,
                  analysisRange.ends!.day,
                )
              : model.Date.latest,
        ),
        model.CategoryCollection.single(category));
    buffer.add((category.name, records.total(currency).amount));
  }
  final total =
      buffer.fold(0.0, (previousValue, element) => previousValue + element.$2);
  final result = <RatioValue>[];
  for (final pair in buffer) {
    result.add(RatioValue(
      categoryName: pair.$1,
      amount: pair.$2,
      ratio: pair.$2 / total,
    ));
  }
  return result;
}

/// {@template getValuesOfAccumulationChart}
/// returns the values to make a accumulation chart.
///
/// [currencyId] is the id of the currency to convert all currencies to.
///
/// [analysisRange] is the range to analyze.
/// Records in the range are accumulated by day.
/// [viewportRange] is the range to display.
/// The difference between [analysisRange] and [viewportRange] is that
/// [analysisRange] is for analysis and [viewportRange] is for display.
/// [viewportRange] should be contained in [analysisRange].
/// If [viewportRange] equals to [analysisRange], the beggining of the chart is 0.
/// If [viewportRange] is shorter than [analysisRange], the chart is zoomed in.
/// That is reflected to the return value, only AccumulatedBars whose date is in [viewportRange] are returned.
///
/// [categoryIds] is the list of category ids to analyze.
/// If it is not empty, only records whose category is in the given list are counted.
/// If it is empty, all categories are counted.
///
/// [intervalInDays] is the interval of the chart in days. This should be greater than 0.
///
/// Example:
/// When [viewportRange] is from 2021-01-01 to 2021-01-31, and when [intervalInDays] is 7,
/// x-axis of the chart is 2021-01-03, 2021-01-10, 2021-01-17, 2021-01-24, 2021-01-31.
///
/// When [viewportRange] is from 2021-01-01 to 2021-01-04, and when [intervalInDays] is 1,
/// x-axis of the chart is 2021-01-01,2021-01-02,2021-01-03,2021-01-04.
///
/// The end of the chart is often more important than the beginning. So, the end of the chart is always the end of [viewportRange].
/// {@endtemplate}
Future<List<AccumulatedValue>> getValuesOfAccumulationChart(
    int currencyId,
    OpenPeriod analysisRange,
    ClosedPeriod viewportRange,
    List<int> categoryIds,
    int intervalInDays) async {
  final currency = (await model.Currency.get(currencyId))!;
  model.CategoryCollection categories;
  if (categoryIds.isEmpty) {
    categories = model.CategoryCollection.phantomAll;
  } else {
    final categoryList = <model.Category>[];
    for (final categoryId in categoryIds) {
      categoryList.add((await model.Category.get(categoryId))!);
    }
    categories = model.CategoryCollection(categories: categoryList);
  }
  final residure =
      viewportRange.asDateTimeRange().duration.inDays % intervalInDays;
  model.Date ends = model.Date(viewportRange.begins.year,
      viewportRange.begins.month, viewportRange.begins.day + residure);
  final result = <AccumulatedValue>[];
  while (viewportRange.ends.asDateTime().isAfter(ends.toDateTime())) {
    final records = await model.RecordCollection.get(
        model.Period(
          begins: analysisRange.begins != null
              ? model.Date(
                  analysisRange.begins!.year,
                  analysisRange.begins!.month,
                  analysisRange.begins!.day,
                )
              : model.Date.earliest,
          ends: ends,
        ),
        categories);
    ends = ends.withDelta(days: intervalInDays);
    result.add(AccumulatedValue(
      date: Date(ends.year, ends.month, ends.day),
      amount: records.total(currency).amount,
    ));
  }
  return result;
}

/// {@template getValuesOfSubtotalChart}
/// returns the values to make a subtotal chart.
///
/// [currencyId] is the id of the currency to convert all currencies to.
///
/// [viewportRange] is the range to display.
/// SubtotalBars whose date is in [viewportRange] are returned.
///
/// [categoryIds] is the list of category ids to analyze.
/// If it is not empty, only records whose category is in the given list are counted.
/// If it is empty, all categories are counted.
///
/// [intervalInDays] is the interval of the chart in days. This should be greater than 0.
///
/// Example:
/// When [viewportRange] is from 2021-01-01 to 2021-01-31, and when [intervalInDays] is 7,
/// x-axis of the chart is 2021-01-03, 2021-01-10, 2021-01-17, 2021-01-24, 2021-01-31.
/// Each bar represents the sum of the records in 2021-02-25 to 2021-01-03, 2021-01-04 to 2021-01-10, ...
/// the day of the bar - 7 + 1 to the day of the bar.
///
/// When [viewportRange] is from 2021-01-01 to 2021-01-04, and when [intervalInDays] is 1,
/// x-axis of the chart is 2021-01-01,2021-01-02,2021-01-03,2021-01-04.
/// Each bar represents the sum of the records in the day of the bar.
///
/// The end of the chart is often more important than the beginning. So, the end of the chart is always the end of [viewportRange].
/// {@endtemplate}
Future<List<SubtotalValue>> getValuesOfSubtotalChart(
    int currencyId,
    ClosedPeriod viewportRange,
    List<int> categoryIds,
    int intervalInDays) async {
  final currency = (await model.Currency.get(currencyId))!;
  model.CategoryCollection categories;
  if (categoryIds.isEmpty) {
    categories = model.CategoryCollection.phantomAll;
  } else {
    final categoryList = <model.Category>[];
    for (final categoryId in categoryIds) {
      categoryList.add((await model.Category.get(categoryId))!);
    }
    categories = model.CategoryCollection(categories: categoryList);
  }
  final residure =
      viewportRange.asDateTimeRange().duration.inDays % intervalInDays;
  model.Date ends = model.Date(viewportRange.begins.year,
      viewportRange.begins.month, viewportRange.begins.day + residure);
  final result = <SubtotalValue>[];
  while (viewportRange.ends.asDateTime().isAfter(ends.toDateTime())) {
    final records = await model.RecordCollection.get(
        model.Period(
          begins: ends.withDelta(days: -intervalInDays + 1),
          ends: ends,
        ),
        categories);
    ends = ends.withDelta(days: intervalInDays);
    result.add(SubtotalValue(
      date: Date(ends.year, ends.month, ends.day),
      amount: records.total(currency).amount,
    ));
  }
  return result;
}
