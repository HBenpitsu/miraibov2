import 'dart:math' show Random;
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
  // <presenters>
  /// categories counted should be specified.
  /// all of categories are shown as options.
  Future<List<Category>> getCategoryOptions();

  /// currency in which the ticket shown should be specified.
  /// all of currencies are shown as options.
  Future<List<Currency>> getCurrencyOptions();

  /// for convenience, default currency should be supplied.
  Future<Currency> getDefaultCurrency();
  // </presenters>

  // <controllers>
  /// create the monitor scheme with the specified scheme.
  Future<void> createMonitorScheme(List<int> categoryIds, OpenPeriod period,
      MonitordisplayOption displayOption, int currencyId);
  // </controllers>

  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}
// </interface>

// <mock>
class MockMonitorSchemeSection implements MonitorSchemeSection {
  final List<Ticket> tickets;
  final Sink<List<Ticket>> ticketsStream;
  final Random random = Random();

  static const List<Currency> currencyList = [
    Currency(id: 0, symbol: 'JPY'),
    Currency(id: 1, symbol: 'USD'),
    Currency(id: 2, symbol: 'EUR')
  ];

  static List<Category> categoryList = [
    for (int i = 0; i < 20; i++) Category(id: i, name: 'category$i')
  ];

  MockMonitorSchemeSection(this.tickets, this.ticketsStream);

  @override
  Future<List<Category>> getCategoryOptions() async {
    return categoryList;
  }

  @override
  Future<List<Currency>> getCurrencyOptions() async {
    return currencyList;
  }

  @override
  Future<Currency> getDefaultCurrency() async {
    return currencyList[0];
  }

  @override
  Future<void> createMonitorScheme(List<int> categoryIds, OpenPeriod period,
      MonitordisplayOption displayOption, int currencyId) async {
    final id = DateTime.now().millisecondsSinceEpoch * 10 + random.nextInt(10);
    tickets.add(MonitorTicket(
        id: id,
        period: period,
        price: Price(amount: 1000, symbol: currencyList[currencyId].symbol),
        displayOption: displayOption,
        categoryNames:
            categoryIds.map((id) => categoryList[id].name).toList()));
    ticketsStream.add(tickets);
  }

  @override
  void dispose() {}
}
// </mock>
