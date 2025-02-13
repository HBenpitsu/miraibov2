import 'package:miraibo/skeleton/data_page/shared.dart';
import 'package:miraibo/dto/dto.dart';

// <interface>
/// MonitorSchemeSection is a section to create a monitor scheme.
/// A monitor scheme consists of the following information:
///
/// - which categories should be counted
/// - what period should be counted
/// - how to display the monitor
///    - which display config the ticket follows
///    - which currency the ticket uses
///
abstract interface class MonitorSchemeSection {
  // <states>
  /// The initial temporary ticket scheme.
  /// This will not be changed while the section is alive.
  TemporaryTicketScheme get initialScheme;

  /// The current temporary ticket scheme.
  /// This will be changed on the end of the section-lifecycle.
  set currentScheme(TemporaryTicketScheme value);
  // </states>

  // <presenters>
  /// Categories counted should be specified.
  /// All categories are shown as options.
  Future<List<Category>> getCategoryOptions();

  /// The currency in which the ticket is shown should be specified.
  /// All currencies are shown as options.
  Future<List<Currency>> getCurrencyOptions();

  /// Get the initial configuration of the temporary monitor scheme.
  /// If [initialScheme] is not [TemporaryMonitorScheme], this method provides a default scheme.
  Future<TemporaryMonitorScheme> getInitialScheme();
  // </presenters>

  // <actions>
  /// Apply the specified monitor scheme to [currentScheme].
  Future<void> applyMonitorScheme(List<int> categoryIds, OpenPeriod period,
      MonitorDisplayConfig displayConfig, int currencyId);
  // </actions>
  void dispose();
}
// </interface>

// <mock>
class MockMonitorSchemeSection implements MonitorSchemeSection {
  @override
  final TemporaryTicketScheme initialScheme;
  final Function(TemporaryTicketScheme) schemeSetter;
  @override
  set currentScheme(TemporaryTicketScheme value) => schemeSetter(value);

  // List of predefined currencies
  static const List<Currency> currencyList = [
    Currency(id: 0, symbol: 'JPY'),
    Currency(id: 1, symbol: 'USD'),
    Currency(id: 2, symbol: 'EUR')
  ];

  // List of predefined categories
  static List<Category> categoryList = [
    for (int i = 0; i < 20; i++) Category(id: i, name: 'category$i')
  ];

  MockMonitorSchemeSection(this.initialScheme, this.schemeSetter);

  @override
  Future<List<Category>> getCategoryOptions() async {
    return categoryList;
  }

  @override
  Future<List<Currency>> getCurrencyOptions() async {
    return currencyList;
  }

  @override
  Future<TemporaryMonitorScheme> getInitialScheme() async {
    if (initialScheme is TemporaryMonitorScheme) {
      return initialScheme as TemporaryMonitorScheme;
    }
    // provide a default scheme
    return TemporaryMonitorScheme(
        categories: categoryList,
        period: const OpenPeriod(begins: null, ends: null),
        displayConfig: MonitorDisplayConfig.meanInDays,
        currency: currencyList[0]);
  }

  @override
  Future<void> applyMonitorScheme(List<int> categoryIds, OpenPeriod period,
      MonitorDisplayConfig displayConfig, int currencyId) async {
    // cast bunch of parameters to the temporary monitor scheme
    currentScheme = TemporaryMonitorScheme(
        categories: categoryIds.map((id) => categoryList[id]).toList(),
        period: period,
        displayConfig: displayConfig,
        currency: currencyList[currencyId]);
  }

  @override
  void dispose() {}
}
// </mock>