import 'package:flutter/foundation.dart' show compute;
import 'package:miraibo/model/usecase/usecase.dart' as usecase;
import 'package:miraibo/dto/dto.dart';

// <getValuesOfPieChart>
Future<List<PieChartChip>> __getValuesOfPieChart(
    (int, OpenPeriod, List<int>) param) {
  return usecase.getValuesOfPieChart(param.$1, param.$2, param.$3);
}

/// {@macro getValuesOfPieChart}
Future<List<PieChartChip>> getValuesOfPieChart(
    int currencyId, OpenPeriod analysisRange, List<int> categoryIds) {
  return compute(
      __getValuesOfPieChart, (currencyId, analysisRange, categoryIds));
}
// </getValuesOfPieChart>

// <getValuesOfAccumulationChart>
Future<List<AccumulatedBar>> __getValuesOfAccumulationChart(
    (int, OpenPeriod, ClosedPeriod, List<int>, int) param) {
  return usecase.getValuesOfAccumulationChart(
      param.$1, param.$2, param.$3, param.$4, param.$5);
}

/// {@macro getValuesOfAccumulationChart}
Future<List<AccumulatedBar>> getValuesOfAccumulationChart(
    int currencyId,
    OpenPeriod analysisRange,
    ClosedPeriod viewportRange,
    List<int> categoryIds,
    int intervalInDays) {
  return compute(__getValuesOfAccumulationChart,
      (currencyId, analysisRange, viewportRange, categoryIds, intervalInDays));
}
// </getValuesOfAccumulationChart>

// <getValuesOfSubtotalChart>
Future<List<SubtotalBar>> __getValuesOfSubtotalChart(
    (int, ClosedPeriod, List<int>, int) param) {
  return usecase.getValuesOfSubtotalChart(
      param.$1, param.$2, param.$3, param.$4);
}

/// {@macro getValuesOfSubtotalChart}
Future<List<SubtotalBar>> getValuesOfSubtotalChart(
    int currencyId,
    ClosedPeriod viewportRange,
    List<int> categoryIds,
    int intervalInDays) async {
  return compute(__getValuesOfSubtotalChart,
      (currencyId, viewportRange, categoryIds, intervalInDays));
}
// </getValuesOfSubtotalChart>
