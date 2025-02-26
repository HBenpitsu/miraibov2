import 'package:miraibo/skeleton/data_page/shared.dart';
import 'package:miraibo/dto/dto.dart';

// <interface>
/// SubtotalChartSection is a section to configure a subtotal chart.
/// A subtotal chart consists of the following information:
///
/// - multiple category selector
/// - currency selector
/// - viewport range selector
/// - interval selector
///
/// There is a button to apply the scheme.
abstract interface class SubtotalChartSection {
  // <states>
  /// The chart scheme when the section is created.
  /// This will not be changed while the section is alive.
  ChartScheme get initialScheme;

  /// This may be changed on the end of the section-lifecycle.
  set currentScheme(ChartScheme value);
  // </states>

  // <presenters>
  Future<List<Category>> getCategoryOptions();
  Future<List<Currency>> getCurrencyOptions();
  Future<SubtotalChartScheme> getInitialScheme();
  // </presenters>

  // <actions>
  Future<void> applyScheme(List<int> categoryIds, int currencyId,
      ClosedPeriod viewportRange, int intervalInDays);
  // </actions>

  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}
// </interface>
