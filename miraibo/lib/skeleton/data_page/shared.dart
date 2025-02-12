import 'package:miraibo/dto/dto.dart';

// following complex states are shared within the data page.

// <ticket schemes>
sealed class TicketScheme {
  const TicketScheme();
}

class EstimationScheme extends TicketScheme {
  final List<int> categoryIds;
  final EstimationDisplayConfig displayConfig;
  final int currencyId;
  const EstimationScheme(this.categoryIds, this.displayConfig, this.currencyId);
}

class MonitorScheme extends TicketScheme {
  final OpenPeriod period;
  final List<int> categoryIds;
  final MonitorDisplayConfig displayConfig;
  final int currencyId;
  const MonitorScheme(
      this.categoryIds, this.period, this.displayConfig, this.currencyId);
}

class TicketSchemeUnspecified extends TicketScheme {
  const TicketSchemeUnspecified();
}
// </ticket schemes>

// <chart schemes>
sealed class ChartScheme {
  const ChartScheme();
}

class PieChartScheme extends ChartScheme {
  final int currencyId;
  final OpenPeriod analysisRange;
  final List<int> categoryIds;

  const PieChartScheme(this.currencyId, this.analysisRange, this.categoryIds);
}

class SubtotalChartScheme extends ChartScheme {
  final int currencyId;
  final ClosedPeriod viewportRange;
  final List<int> categoryIds;
  final int intervalInDays;

  const SubtotalChartScheme(this.currencyId, this.viewportRange,
      this.categoryIds, this.intervalInDays);
}

class AccumulationChartScheme extends ChartScheme {
  final int currencyId;
  final OpenPeriod analysisRange;
  final ClosedPeriod viewportRange;
  final List<int> categoryIds;
  final int intervalInDays;

  const AccumulationChartScheme(this.currencyId, this.analysisRange,
      this.viewportRange, this.categoryIds, this.intervalInDays);
}

class ChartSchemeUnspecified extends ChartScheme {
  const ChartSchemeUnspecified();
}
// </chart schemes>