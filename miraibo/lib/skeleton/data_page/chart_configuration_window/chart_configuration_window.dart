import 'package:miraibo/skeleton/data_page/shared.dart';
import 'package:miraibo/skeleton/data_page/chart_configuration_window/accumulation_chart_section.dart';
import 'package:miraibo/skeleton/data_page/chart_configuration_window/pie_chart_section.dart';
import 'package:miraibo/skeleton/data_page/chart_configuration_window/subtotal_chart_section.dart';

// <interface>
abstract interface class ChartConfigurationWindow {
  /// There are three types of charts: accumulation, pie, and subtotal.
  /// This window is shown when user wants to configure the chart.
  /// There are three sections for each type of chart.

  // <states>
  abstract ChartScheme currentChartScheme;
  // </states>

  // <navigators>
  AccumulationChartSection get accumulationChartSection;
  PieChartSection get pieChartSection;
  SubtotalChartSection get subtotalChartSection;
  // </navigators>
}
// </interface>
