import 'package:miraibo/dto/dto.dart';
import 'package:miraibo/skeleton/data_page/shared.dart';
export 'package:miraibo/skeleton/data_page/shared.dart';

// <window>
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
// </window>

// <sections>
// <accumulation chart section>

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
  Future<void> applyScheme(
      int currencyId,
      OpenPeriod analysisRange,
      ClosedPeriod viewportRange,
      List<int> categoryIds,
      bool isAllCategoriesIncluded,
      int intervalInDays);
  // </actions>

  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}

// </interface>
// </accumulation chart section>
// <pie chart section>
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
    int currencyId,
    OpenPeriod analysisRange,
    List<int> categoryIds,
    bool isAllCategoriesIncluded,
  );
  // </actions>

  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}

// </interface>
// </pie chart section>
// <subtotal chart section>
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
  Future<void> applyScheme(
    List<int> categoryIds,
    bool isAllCategoriesIncluded,
    int currencyId,
    ClosedPeriod viewportRange,
    int intervalInDays,
  );
  // </actions>

  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}
// </interface>
// </subtotal chart section>
// </sections>
