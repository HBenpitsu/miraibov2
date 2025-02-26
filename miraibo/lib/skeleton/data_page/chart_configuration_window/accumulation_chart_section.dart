import 'package:miraibo/skeleton/data_page/shared.dart';
import 'package:miraibo/dto/dto.dart';

// <interface>
/// AccumulationChartSection is a section to configure an accumulation chart.
/// An accumulation chart consists of the following information:
///
/// - multiple category selector
/// - currency selector
/// - analysis range selector
/// - viewport range selector
/// - interval selector
///
/// There is a button to apply the scheme.
abstract interface class AccumulationChartSection {
  // <states>
  /// The chart scheme when the section is created.
  /// This will not be changed while the section is alive.
  ChartScheme get initialScheme;

  /// This may be changed on the end of the section-lifecycle.
  set currentScheme(ChartScheme value);
  // </states>

  // <presenters>
  /// Get the list of category options.
  /// All categories are shown as options.
  Future<List<Category>> getCategoryOptions();

  /// Get the list of currency options.
  /// All currencies are shown as options.
  Future<List<Currency>> getCurrencyOptions();

  /// Get the initial chart scheme configuration.
  /// If [initialScheme] is not [AccumulationChartScheme], this method provides a default scheme.
  /// Otherwise, it provides the [initialScheme].
  Future<AccumulationChartScheme> getInitialScheme();
  // </presenters>

  // <actions>
  /// Apply the specified accumulation chart scheme to [currentScheme].
  Future<void> applyScheme(int currencyId, OpenPeriod analysisRange,
      ClosedPeriod viewportRange, List<int> categoryIds, int intervalInDays);
  // </actions>

  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}
// </interface>
