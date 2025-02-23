import 'package:miraibo/skeleton/data_page/shared.dart';
import 'package:miraibo/dto/dto.dart';
import 'dart:developer' show log;

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

// <mock>
class MockSubtotalChartSection implements SubtotalChartSection {
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

  MockSubtotalChartSection(this.initialScheme, this.schemeSetter);

  @override
  Future<List<Category>> getCategoryOptions() async {
    log('MockSubtotalChartSection: getCategoryOptions called');
    return categoryList;
  }

  @override
  Future<List<Currency>> getCurrencyOptions() async {
    log('MockSubtotalChartSection: getCurrencyOptions called');
    return currencyList;
  }

  @override
  Future<SubtotalChartScheme> getInitialScheme() async {
    log('MockSubtotalChartSection: getInitialScheme called');
    if (initialScheme is SubtotalChartScheme) {
      return initialScheme as SubtotalChartScheme;
    }
    // make mock-default scheme
    // <prepare parameters>
    final now = DateTime.now();
    final twoWeeksAgo = now.subtract(const Duration(days: 14));
    final twoWeeksLater = now.add(const Duration(days: 14));
    final closedPeriod = ClosedPeriod(
        begins: twoWeeksAgo.cutOffTime(), ends: twoWeeksLater.cutOffTime());
    // </prepare parameters>
    return SubtotalChartScheme(
        currency: currencyList[0],
        viewportRange: closedPeriod,
        intervalInDays: 7,
        categories: categoryList);
  }

  @override
  Future<void> applyScheme(List<int> categoryIds, int currencyId,
      ClosedPeriod viewportRange, int intervalInDays) async {
    log('MockSubtotalChartSection: applyScheme called with categoryIds: $categoryIds, currencyId: $currencyId, viewportRange: $viewportRange, intervalInDays: $intervalInDays');
    // cast bunch of parameters to SubtotalChartScheme and set it to currentScheme
    currentScheme = SubtotalChartScheme(
        currency: currencyList[currencyId],
        viewportRange: viewportRange,
        categories:
            categoryIds.map((id) => categoryList[id]).toList(growable: false),
        intervalInDays: intervalInDays);
  }

  @override
  void dispose() {
    log('MockSubtotalChartSection: dispose called');
  }
}
// </mock>
