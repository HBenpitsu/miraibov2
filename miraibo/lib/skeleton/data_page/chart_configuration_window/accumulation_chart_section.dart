import 'package:miraibo/skeleton/data_page/shared.dart';
import 'package:miraibo/dto/dto.dart';

// <interface>
abstract interface class AccumulationChartSection {
  /// accumulation chart section consists of:
  ///
  /// - multiple category selector
  /// - currency selector
  /// - analysis range selector
  /// - viewport range selector
  /// - interval selector
  ///
  /// there is a button to apply the scheme.

  // <states>
  abstract ChartScheme currentChartScheme;
  // </states>

  // <presenters>
  Future<List<Category>> getCategoryOptions();
  Future<List<Currency>> getCurrencyOptions();
  Future<Currency> getDefaultCurrency();
  // </presenters>

  // <actions>
  Future<void> applyScheme(int currencyId, OpenPeriod analysisRange,
      ClosedPeriod viewportRange, List<int> categoryIds, int intervalInDays);
  // </actions>
}
// </interface>
