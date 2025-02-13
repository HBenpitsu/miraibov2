import 'package:miraibo/dto/dto.dart';

// following complex states are shared within the data page.

// <ticket schemes>

sealed class TemporaryTicketScheme {
  const TemporaryTicketScheme();
}

class TemporaryEstimationScheme extends TemporaryTicketScheme {
  final OpenPeriod period;
  final Currency currency;
  final EstimationDisplayConfig displayConfig;
  final List<Category> categories;

  const TemporaryEstimationScheme(
      {required this.period,
      required this.currency,
      required this.displayConfig,
      required this.categories});
}

class TemporaryMonitorScheme extends TemporaryTicketScheme {
  final OpenPeriod period;
  final Currency currency;
  final MonitorDisplayConfig displayConfig;
  final List<Category> categories;

  const TemporaryMonitorScheme(
      {required this.period,
      required this.currency,
      required this.displayConfig,
      required this.categories});
}

class TemporaryTicketSchemeUnspecified extends TemporaryTicketScheme {
  const TemporaryTicketSchemeUnspecified();
}

// </ticket schemes>

// <chart schemes>
sealed class ChartScheme {
  const ChartScheme();
}

class PieChartScheme extends ChartScheme {
  final Currency currency;
  final OpenPeriod analysisRange;
  final List<Category> categories;

  const PieChartScheme(
      {required this.currency,
      required this.analysisRange,
      required this.categories});
}

class SubtotalChartScheme extends ChartScheme {
  final Currency currency;
  final ClosedPeriod viewportRange;
  final List<Category> categories;
  final int intervalInDays;

  const SubtotalChartScheme(
      {required this.currency,
      required this.viewportRange,
      required this.categories,
      required this.intervalInDays});
}

class AccumulationChartScheme extends ChartScheme {
  final Currency currency;
  final OpenPeriod analysisRange;
  final ClosedPeriod viewportRange;
  final List<Category> categories;
  final int intervalInDays;

  const AccumulationChartScheme(
      {required this.currency,
      required this.analysisRange,
      required this.viewportRange,
      required this.categories,
      required this.intervalInDays});
}

class ChartSchemeUnspecified extends ChartScheme {
  const ChartSchemeUnspecified();
}
// </chart schemes>