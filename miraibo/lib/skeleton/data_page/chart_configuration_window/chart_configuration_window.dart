import 'package:miraibo/skeleton/data_page/chart_configuration_window/accumulation_chart_section.dart';
import 'package:miraibo/skeleton/data_page/chart_configuration_window/pie_chart_section.dart';
import 'package:miraibo/skeleton/data_page/chart_configuration_window/subtotal_chart_section.dart';

// <interface>
abstract interface class ChartConfigurationWindowPresenter {
  AccumulationChartSectionPresenter get accumulationChartSectionPresenter;
  PieChartSectionPresenter get pieChartSectionPresenter;
  SubtotalChartSectionPresenter get subtotalChartSectionPresenter;
}

abstract interface class ChartConfigurationWindowController {
  AccumulationChartSectionController get accumulationChartSectionController;
  PieChartSectionController get pieChartSectionController;
  SubtotalChartSectionController get subtotalChartSectionController;
}
// </interface>
