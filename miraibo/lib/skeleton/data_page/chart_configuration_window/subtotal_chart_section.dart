import 'package:miraibo/skeleton/data_page/shared.dart';
import 'package:miraibo/dto/dto.dart';

// <interface>
abstract interface class SubtotalChartSection {
  /// subtotal chart section consists of:
  ///
  /// - multiple category selector
  /// - currency selector
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
  Future<void> applyScheme(List<int> categoryIds, int currencyId,
      ClosedPeriod viewportRange, int intervalInDays);
  // </actions>
}
// </interface>
