import 'package:miraibo/skeleton/data_page/shared.dart';
import 'package:miraibo/dto/dto.dart';

// <interface>
abstract interface class PieChartSection {
  /// pie chart section consists of selectors to make a chart scheme.

  // <states>
  abstract ChartScheme currentChartScheme;
  // </states>

  // <presenters>
  Future<List<Category>> getCategoryOptions();
  Future<List<Currency>> getCurrencyOptions();
  Future<Currency> getDefaultCurrency();
  // </presenters>

  // <actions>
  Future<void> applyScheme(
      int currencyId, OpenPeriod analysisRange, List<int> categoryIds);
  // </actions>
}
// </interface>
