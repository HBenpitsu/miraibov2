import 'package:flutter/foundation.dart' show compute;
import 'package:miraibo/model/usecase/usecase.dart' as usecase;
import 'package:miraibo/dto/dto.dart';
import 'package:miraibo/shared/enumeration.dart';

Future<EstimationTicket> __estimateWithScheme(
    (List<int>, int, EstimationDisplayOption) param) {
  return usecase.estimateWithScheme(param.$1, param.$2, param.$3);
}

/// {@macro estimateWithScheme}
Future<EstimationTicket> estimateWithScheme(List<int> categoryIds,
    int currencyId, EstimationDisplayOption displayOption) {
  return compute(
      __estimateWithScheme, (categoryIds, currencyId, displayOption));
}

Future<MonitorTicket> __monitorWithScheme(
    (OpenPeriod, List<int>, MonitorDisplayOption, int) param) {
  return usecase.monitorWithScheme(param.$1, param.$2, param.$3, param.$4);
}

/// {@macro monitorWithScheme}
Future<MonitorTicket> monitorWithScheme(OpenPeriod period,
    List<int> categoryIds, MonitorDisplayOption displayOption, int currencyId) {
  return compute(
      __monitorWithScheme, (period, categoryIds, displayOption, currencyId));
}
