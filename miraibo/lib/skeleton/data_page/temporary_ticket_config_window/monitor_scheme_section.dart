import 'package:miraibo/skeleton/data_page/shared.dart';
import 'package:miraibo/dto/dto.dart';

// <interface>
/// MonitorSchemeSection is a section to create a monitor scheme.
/// A monitor scheme consists of the following information:
///
/// - which categories should be counted
/// - what period should be counted
/// - how to display the monitor
///    - which display config does the ticket follow
///    - which currency does the ticket use
///

abstract interface class MonitorSchemeSection {
  // <states>
  TemporaryTicketScheme get initialScheme;
  set currentScheme(TemporaryTicketScheme value);
  // </states>

  // <presenters>
  /// categories counted should be specified.
  /// all of categories are shown as options.
  Future<List<Category>> getCategoryOptions();

  /// currency in which the ticket shown should be specified.
  /// all of currencies are shown as options.
  Future<List<Currency>> getCurrencyOptions();

  Future<TemporaryMonitorScheme> getInitialConfig();
  // </presenters>

  // <actions>
  Future<void> applyMonitorScheme(List<int> categoryIds, OpenPeriod period,
      MonitorDisplayConfig displayConfig, int currencyId);
  // </actions>
}
// </interface>

// <mock>
class MockMonitorSchemeSection implements MonitorSchemeSection {
  @override
  final TemporaryTicketScheme initialScheme;
  final Function(TemporaryTicketScheme) schemeSetter;
  @override
  set currentScheme(TemporaryTicketScheme value) => schemeSetter(value);

  static const List<Currency> currencyList = [
    Currency(id: 0, symbol: 'JPY'),
    Currency(id: 1, symbol: 'USD'),
    Currency(id: 2, symbol: 'EUR')
  ];

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
  Future<TemporaryMonitorScheme> getInitialConfig() async {
    if (initialScheme is TemporaryMonitorScheme) {
      return initialScheme as TemporaryMonitorScheme;
    }

    return TemporaryMonitorScheme(
        categories: categoryList,
        period: const OpenPeriod(begins: null, ends: null),
        displayConfig: MonitorDisplayConfig.meanInDays,
        currency: currencyList[0]);
  }

  @override
  Future<void> applyMonitorScheme(List<int> categoryIds, OpenPeriod period,
      MonitorDisplayConfig displayConfig, int currencyId) async {
    currentScheme = TemporaryMonitorScheme(
        categories: categoryIds.map((id) => categoryList[id]).toList(),
        period: period,
        displayConfig: displayConfig,
        currency: currencyList[currencyId]);
  }
}
// </mock>