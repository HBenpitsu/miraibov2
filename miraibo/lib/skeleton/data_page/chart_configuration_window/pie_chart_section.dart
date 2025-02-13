import 'package:miraibo/skeleton/data_page/shared.dart';
import 'package:miraibo/dto/dto.dart';

// <interface>
/// pie chart section consists of:
///
/// - multiple category selector
/// - currency selector
/// - range selector
///
/// there is a button to apply the scheme.
abstract interface class PieChartSection {
  // <states>
  ChartScheme get initialScheme;
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
}
// </interface>

// <mock>
class MockPieChartSection implements PieChartSection {
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

  MockPieChartSection(this.initialScheme, this.schemeSetter);

  @override
  Future<List<Category>> getCategoryOptions() async {
    return categoryList;
  }

  @override
  Future<List<Currency>> getCurrencyOptions() async {
    return currencyList;
  }

  @override
  Future<PieChartScheme> getInitialScheme() async {
    if (initialScheme is PieChartScheme) {
      return initialScheme as PieChartScheme;
    }
    var now = DateTime.now();
    var twoWeeksAgo = now.subtract(const Duration(days: 14));
    var twoWeeksLater = now.add(const Duration(days: 14));
    var period = OpenPeriod(
        begins: Date(twoWeeksAgo.year, twoWeeksAgo.month, twoWeeksAgo.day),
        ends: Date(twoWeeksLater.year, twoWeeksLater.month, twoWeeksLater.day));
    return PieChartScheme(
        currency: currencyList[0],
        analysisRange: period,
        categories: categoryList);
  }

  @override
  Future<void> applyScheme(
      int currencyId, OpenPeriod period, List<int> categoryIds) async {
    currentScheme = PieChartScheme(
        currency: currencyList[currencyId],
        analysisRange: period,
        categories: categoryIds.map((id) => categoryList[id]).toList());
  }
}
// </mock>