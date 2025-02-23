import 'package:miraibo/dto/dto.dart';

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
  throw UnimplementedError();
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
  throw UnimplementedError();
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
  throw UnimplementedError();
}
