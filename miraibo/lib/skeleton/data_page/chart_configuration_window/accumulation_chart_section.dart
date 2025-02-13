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

// <mock>
class MockAccumulationChartSection implements AccumulationChartSection {
  @override
  final ChartScheme initialScheme;

  /// setter to implement set [currentScheme]
  final Function(ChartScheme) schemeSetter;
  @override
  set currentScheme(ChartScheme value) => schemeSetter(value);

  /// list of predefined currencies
  static const List<Currency> currencyList = [
    Currency(id: 0, symbol: 'JPY'),
    Currency(id: 1, symbol: 'USD'),
    Currency(id: 2, symbol: 'EUR')
  ];

  /// list of predefined categories
  static List<Category> categoryList = [
    for (int i = 0; i < 20; i++) Category(id: i, name: 'category$i')
  ];

  MockAccumulationChartSection(this.initialScheme, this.schemeSetter);

  @override
  Future<List<Category>> getCategoryOptions() async {
    return categoryList;
  }

  @override
  Future<List<Currency>> getCurrencyOptions() async {
    return currencyList;
  }

  @override
  Future<AccumulationChartScheme> getInitialScheme() async {
    if (initialScheme is AccumulationChartScheme) {
      return initialScheme as AccumulationChartScheme;
    }
    // make mock-default scheme
    // <prepare parameters>
    final now = DateTime.now();
    final twoWeeksAgo = now.subtract(const Duration(days: 14));
    final twoWeeksLater = now.add(const Duration(days: 14));
    final period = OpenPeriod(
        begins: Date(twoWeeksAgo.year, twoWeeksAgo.month, twoWeeksAgo.day),
        ends: Date(twoWeeksLater.year, twoWeeksLater.month, twoWeeksLater.day));
    final closedPeriod = ClosedPeriod(
        begins: Date(twoWeeksAgo.year, twoWeeksAgo.month, twoWeeksAgo.day),
        ends: Date(twoWeeksLater.year, twoWeeksLater.month, twoWeeksLater.day));
    // </prepare parameters>
    return AccumulationChartScheme(
        currency: currencyList[0],
        analysisRange: period,
        viewportRange: closedPeriod,
        categories: categoryList,
        intervalInDays: 1);
  }

  @override
  Future<void> applyScheme(
      int currencyId,
      OpenPeriod analysisRange,
      ClosedPeriod viewportRange,
      List<int> categoryIds,
      int intervalInDays) async {
    // cast bunch of parameters to AccumulationChartScheme and set it to currentScheme
    currentScheme = AccumulationChartScheme(
        currency: currencyList[currencyId],
        analysisRange: analysisRange,
        viewportRange: viewportRange,
        categories: categoryIds.map((id) => categoryList[id]).toList(),
        intervalInDays: intervalInDays);
  }

  @override
  void dispose() {}
}
// </mock>