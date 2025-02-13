import 'package:miraibo/skeleton/data_page/shared.dart';
import 'package:miraibo/dto/dto.dart';

// <interface>
/// accumulation chart section consists of:
///
/// - multiple category selector
/// - currency selector
/// - analysis range selector
/// - viewport range selector
/// - interval selector
///
/// there is a button to apply the scheme.
abstract interface class AccumulationChartSection {
  // <states>
  ChartScheme get initialScheme;
  set currentScheme(ChartScheme value);
  // </states>

  // <presenters>
  Future<List<Category>> getCategoryOptions();
  Future<List<Currency>> getCurrencyOptions();
  Future<AccumulationChartScheme> getInitialScheme();
  // </presenters>

  // <actions>
  Future<void> applyScheme(int currencyId, OpenPeriod analysisRange,
      ClosedPeriod viewportRange, List<int> categoryIds, int intervalInDays);
  // </actions>
}
// </interface>

// <mock>
class MockAccumulationChartSection implements AccumulationChartSection {
  @override
  final ChartScheme initialScheme;
  final Function(ChartScheme) schemeSetter;
  @override
  set currentScheme(ChartScheme value) => schemeSetter(value);

  static const List<Currency> currencyList = [
    Currency(id: 0, symbol: 'JPY'),
    Currency(id: 1, symbol: 'USD'),
    Currency(id: 2, symbol: 'EUR')
  ];

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
    var now = DateTime.now();
    var twoWeeksAgo = now.subtract(const Duration(days: 14));
    var twoWeeksLater = now.add(const Duration(days: 14));
    var period = OpenPeriod(
        begins: Date(twoWeeksAgo.year, twoWeeksAgo.month, twoWeeksAgo.day),
        ends: Date(twoWeeksLater.year, twoWeeksLater.month, twoWeeksLater.day));
    var closedPeriod = ClosedPeriod(
        begins: Date(twoWeeksAgo.year, twoWeeksAgo.month, twoWeeksAgo.day),
        ends: Date(twoWeeksLater.year, twoWeeksLater.month, twoWeeksLater.day));
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
    currentScheme = AccumulationChartScheme(
        currency: currencyList[currencyId],
        analysisRange: analysisRange,
        viewportRange: viewportRange,
        categories: categoryIds.map((id) => categoryList[id]).toList(),
        intervalInDays: intervalInDays);
  }
}
// </mock>