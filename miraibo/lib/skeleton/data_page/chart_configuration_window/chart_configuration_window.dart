import 'package:miraibo/skeleton/data_page/shared.dart';
import 'package:miraibo/skeleton/data_page/chart_configuration_window/accumulation_chart_section.dart';
import 'package:miraibo/skeleton/data_page/chart_configuration_window/pie_chart_section.dart';
import 'package:miraibo/skeleton/data_page/chart_configuration_window/subtotal_chart_section.dart';

// <interface>
/// There are three types of charts: accumulation, pie, and subtotal.
/// This window is shown when user wants to configure the chart.
/// There are three sections for each type of chart.
abstract interface class ChartConfigurationWindow {
  // <states>
  ChartScheme get initialScheme;
  set currentScheme(ChartScheme value);
  // </states>

  // <navigators>
  AccumulationChartSection get accumulationChartSection;
  PieChartSection get pieChartSection;
  SubtotalChartSection get subtotalChartSection;
  // </navigators>
}
// </interface>

// <mock>
class MockChartConfigurationWindow implements ChartConfigurationWindow {
  @override
  final ChartScheme initialScheme;
  final Function(ChartScheme) schemeSetter;
  @override
  set currentScheme(ChartScheme value) => schemeSetter(value);

  MockChartConfigurationWindow(this.initialScheme, this.schemeSetter) {
    accumulationChartSection =
        MockAccumulationChartSection(initialScheme, schemeSetter);
    pieChartSection = MockPieChartSection(initialScheme, schemeSetter);
    subtotalChartSection =
        MockSubtotalChartSection(initialScheme, schemeSetter);
  }

  @override
  late final AccumulationChartSection accumulationChartSection;

  @override
  late final PieChartSection pieChartSection;

  @override
  late final SubtotalChartSection subtotalChartSection;
}
// </mock>