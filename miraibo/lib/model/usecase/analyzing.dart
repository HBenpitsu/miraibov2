import 'package:miraibo/dto/dto.dart';

/// {@template estimateWithScheme}
/// estimates the price of the given schedule with the given estimation scheme.
/// {@endtemplate}
Future<EstimationTicket> estimateWithScheme(List<int> categoryIds,
    int currencyId, EstimationDisplayOption displayOption) {
  throw UnimplementedError();
}

/// {@template monitorWithScheme}
/// return the price of the given monitor scheme.
/// {@endtemplate}
Future<MonitorTicket> monitorWithScheme(OpenPeriod period,
    List<int> categoryIds, MonitorDisplayOption displayOption, int currencyId) {
  throw UnimplementedError();
}
