import 'package:miraibo/dto/dto.dart';

// class below is view-model for scheme edit window.
// it also used as types for the states.
// Because they are shared between the page and windows on the page,
// They are exploited into this `shared.dart` file.

// <ticket schemes>

/// ticket scheme is a set of configurations for ticket display.
sealed class TemporaryTicketScheme {
  const TemporaryTicketScheme();
}

class TemporaryEstimationScheme extends TemporaryTicketScheme {
  final OpenPeriod period;
  final Currency currency;
  final EstimationdisplayOption displayOption;
  final List<Category> categories;

  const TemporaryEstimationScheme(
      {required this.period,
      required this.currency,
      required this.displayOption,
      required this.categories});
}

class TemporaryMonitorScheme extends TemporaryTicketScheme {
  final OpenPeriod period;
  final Currency currency;
  final MonitordisplayOption displayOption;
  final List<Category> categories;

  const TemporaryMonitorScheme(
      {required this.period,
      required this.currency,
      required this.displayOption,
      required this.categories});
}

class TemporaryTicketSchemeUnspecified extends TemporaryTicketScheme {
  const TemporaryTicketSchemeUnspecified();
}

// </ticket schemes>

// <chart schemes>
/// chart scheme is a set of configurations for chart display.
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
