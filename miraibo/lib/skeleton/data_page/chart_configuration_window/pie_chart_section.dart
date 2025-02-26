import 'package:miraibo/skeleton/data_page/shared.dart';
import 'package:miraibo/dto/dto.dart';

// <interface>

/// PieChartSection is a section to configure a pie chart.
/// A pie chart consists of the following information:
///
/// - multiple category selector
/// - currency selector
/// - range selector
///
/// There is a button to apply the scheme.
abstract interface class PieChartSection {
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
  Future<PieChartScheme> getInitialScheme();
  // </presenters>

  // <actions>
  Future<void> applyScheme(
      int currencyId, OpenPeriod analysisRange, List<int> categoryIds);
  // </actions>

  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}
// </interface>
