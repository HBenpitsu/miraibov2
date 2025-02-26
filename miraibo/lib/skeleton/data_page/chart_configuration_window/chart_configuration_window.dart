import 'package:miraibo/skeleton/data_page/shared.dart';
export 'package:miraibo/skeleton/data_page/shared.dart';
import 'package:miraibo/skeleton/data_page/chart_configuration_window/accumulation_chart_section.dart';
export 'package:miraibo/skeleton/data_page/chart_configuration_window/accumulation_chart_section.dart';
import 'package:miraibo/skeleton/data_page/chart_configuration_window/pie_chart_section.dart';
export 'package:miraibo/skeleton/data_page/chart_configuration_window/pie_chart_section.dart';
import 'package:miraibo/skeleton/data_page/chart_configuration_window/subtotal_chart_section.dart';
export 'package:miraibo/skeleton/data_page/chart_configuration_window/subtotal_chart_section.dart';

import 'dart:developer' show log;

// <interface>
/// There are three types of charts: accumulation, pie, and subtotal.
/// This window is shown when user wants to configure the chart.
/// There are three sections for each type of chart.
abstract interface class ChartConfigurationWindow {
  // <states>
  /// The chart scheme when the window is created.
  /// This will not be changed while the window is alive.
  /// And this will be shared with the sections.
  ChartScheme get initialScheme;

  /// This will be changed on the end of the window-lifecycle.
  set currentScheme(ChartScheme value);
  // </states>

  // <presenter>
  Future<ChartScheme> getInitialScheme();
  // </presenter>

  // <navigators>
  /// A tab of the window.
  AccumulationChartSection get accumulationChartSection;

  /// A tab of the window.
  PieChartSection get pieChartSection;

  /// A tab of the window.
  SubtotalChartSection get subtotalChartSection;

  /// should be called when this skeleton is no longer needed.
  void dispose();
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

  @override
  late final AccumulationChartSection accumulationChartSection;

  @override
  late final PieChartSection pieChartSection;

  @override
  late final SubtotalChartSection subtotalChartSection;

  MockChartConfigurationWindow(this.initialScheme, this.schemeSetter) {
    log('MockChartConfigurationWindow: constructed');
    accumulationChartSection =
        MockAccumulationChartSection(initialScheme, schemeSetter);
    pieChartSection = MockPieChartSection(initialScheme, schemeSetter);
    subtotalChartSection =
        MockSubtotalChartSection(initialScheme, schemeSetter);
  }

  @override
  Future<ChartScheme> getInitialScheme() async {
    return initialScheme;
  }

  @override
  void dispose() {
    log('MockChartConfigurationWindow: dispose called');
    accumulationChartSection.dispose();
    pieChartSection.dispose();
    subtotalChartSection.dispose();
  }
}
// </mock>
