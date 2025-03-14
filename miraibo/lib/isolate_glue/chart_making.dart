import 'package:flutter/foundation.dart' show compute;
import 'package:miraibo/core-model/usecase/usecase.dart' as usecase;
import 'package:miraibo/dto/dto.dart';
import 'package:miraibo/repository/impl.dart' as repository;

// <getValuesOfPieChart>
Future<List<RatioValue>> __getValuesOfPieChart(
    (int, OpenPeriod, List<int>) param) {
  repository.bind();
  return usecase.getValuesOfPieChart(param.$1, param.$2, param.$3);
}

/// {@macro getValuesOfPieChart}
Future<List<RatioValue>> getValuesOfPieChart(
    int currencyId, OpenPeriod analysisRange, List<int> categoryIds) {
  return compute(
      __getValuesOfPieChart, (currencyId, analysisRange, categoryIds));
}
// </getValuesOfPieChart>

// <getValuesOfAccumulationChart>
Future<List<AccumulatedValue>> __getValuesOfAccumulationChart(
    (int, OpenPeriod, ClosedPeriod, List<int>, int) param) {
  repository.bind();
  return usecase.getValuesOfAccumulationChart(
      param.$1, param.$2, param.$3, param.$4, param.$5);
}

/// {@macro getValuesOfAccumulationChart}
Future<List<AccumulatedValue>> getValuesOfAccumulationChart(
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
Future<List<SubtotalValue>> __getValuesOfSubtotalChart(
    (int, ClosedPeriod, List<int>, int) param) {
  repository.bind();
  return usecase.getValuesOfSubtotalChart(
      param.$1, param.$2, param.$3, param.$4);
}

/// {@macro getValuesOfSubtotalChart}
Future<List<SubtotalValue>> getValuesOfSubtotalChart(
    int currencyId,
    ClosedPeriod viewportRange,
    List<int> categoryIds,
    int intervalInDays) async {
  return compute(__getValuesOfSubtotalChart,
      (currencyId, viewportRange, categoryIds, intervalInDays));
}
// </getValuesOfSubtotalChart>
