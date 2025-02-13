import 'package:miraibo/skeleton/data_page/shared.dart';
import 'package:miraibo/dto/dto.dart';

// <interface>
/// EstimationSchemeSection is a section to create an estimation scheme.
/// An estimation scheme consists of the following information:
///
/// - which categories should be counted
/// - what period should be counted
/// - how to display the estimation
///    - which display config does the ticket follow
///    - which currency does the ticket use
///

abstract interface class EstimationSchemeSection {
  // <states>
  /// The initial temporary ticket scheme.
  /// This will not be changed while the section is alive.
  TemporaryTicketScheme get initialScheme;

  /// The current temporary ticket scheme.
  /// This will be changed on the end of the section-lifecycle.
  set currentScheme(TemporaryTicketScheme value);
  // </states>

  // <presenters>
  /// categories counted should be specified.
  /// all of categories are shown as options.
  Future<List<Category>> getCategoryOptions();

  /// currency in which the ticket shown should be specified.
  /// all of currencies are shown as options.
  Future<List<Currency>> getCurrencyOptions();

  /// Get the initial configuration of the temporary estimation scheme.
  /// If [initialScheme] is not [TemporaryEstimationScheme], this method provides a default scheme.
  Future<TemporaryEstimationScheme> getInitialScheme();
  // </presenters>

  // <actions>
  Future<void> applyMonitorScheme(List<int> categoryIds, OpenPeriod period,
      EstimationDisplayConfig displayConfig, int currencyId);
  // </actions>
  void dispose();
}
// </interface>

// <mock>
class MockEstimationSchemeSection implements EstimationSchemeSection {
  @override
  final TemporaryTicketScheme initialScheme;

  /// setter to implement set [currentScheme]
  final Function(TemporaryTicketScheme) schemeSetter;
  @override
  set currentScheme(TemporaryTicketScheme value) => schemeSetter(value);

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

  MockEstimationSchemeSection(this.initialScheme, this.schemeSetter);

  @override
  Future<List<Category>> getCategoryOptions() async {
    return categoryList;
  }

  @override
  Future<List<Currency>> getCurrencyOptions() async {
    return currencyList;
  }

  @override
  Future<TemporaryEstimationScheme> getInitialScheme() async {
    if (initialScheme is TemporaryEstimationScheme) {
      return initialScheme as TemporaryEstimationScheme;
    }
    // provide a mock-default scheme
    return TemporaryEstimationScheme(
        categories: categoryList,
        currency: currencyList[0],
        displayConfig: EstimationDisplayConfig.perMonth,
        period: const OpenPeriod(begins: null, ends: null));
  }

  @override
  Future<void> applyMonitorScheme(List<int> categoryIds, OpenPeriod period,
      EstimationDisplayConfig displayConfig, int currencyId) async {
    // cast bunch of parameters to the temporary estimation scheme
    currentScheme = TemporaryEstimationScheme(
        categories: categoryList
            .where((element) => categoryIds.contains(element.id))
            .toList(),
        currency: currencyList[currencyId],
        displayConfig: displayConfig,
        period: period);
  }

  @override
  void dispose() {}
}
// </mock>
