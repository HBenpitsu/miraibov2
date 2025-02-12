import 'package:flutter/foundation.dart' show compute;
import 'package:miraibo/model/usecase/usecase.dart' as usecase;
import 'package:miraibo/dto/dto.dart';

Future<EstimationTicket> __estimateWithScheme(
    (List<int>, int, EstimationDisplayConfig) param) {
  return usecase.estimateWithScheme(param.$1, param.$2, param.$3);
}

/// {@macro estimateWithScheme}
Future<EstimationTicket> estimateWithScheme(List<int> categoryIds,
    int currencyId, EstimationDisplayConfig displayConfig) {
  return compute(
      __estimateWithScheme, (categoryIds, currencyId, displayConfig));
}

Future<MonitorTicket> __monitorWithScheme(
    (OpenPeriod, List<int>, MonitorDisplayConfig, int) param) {
  return usecase.monitorWithScheme(param.$1, param.$2, param.$3, param.$4);
}

/// {@macro monitorWithScheme}
Future<MonitorTicket> monitorWithScheme(OpenPeriod period,
    List<int> categoryIds, MonitorDisplayConfig displayConfig, int currencyId) {
  return compute(
      __monitorWithScheme, (period, categoryIds, displayConfig, currencyId));
}
