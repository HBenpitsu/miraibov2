import 'package:miraibo/dto/dto.dart';

// <interface>
/// monitor scheme edit window is shown when user wants to edit monitor scheme.
///
/// monitor scheme consists of following information:
///
/// - which categories should be counted
/// - what period should be counted
/// - how to display monitor
///   - which display config does the ticket follow
///   - which currency does the ticket use
abstract interface class MonitorSchemeEditWindow {
  // <state>
  int get targetTicketId;
  // </state>

  // <presenters>
  /// categories counted should be specified.
  /// all of categories are shown as options.
  Future<List<Category>> getCategoryOptions();

  /// currency in which the ticket shown should be specified.
  /// all of currencies are shown as options.
  Future<List<Currency>> getCurrencyOptions();

  // here, we do not need default currency, because original monitor scheme already has currency.

  /// get original monitor scheme. original configuration should be supplied when users editing it.
  Future<MonitorScheme> getOriginalMonitorScheme();
  // </presenters>

  // <controllers>
  Future<void> updateMonitorScheme(List<int> categoryIds, OpenPeriod period,
      MonitorDisplayConfig displayConfig, int currencyId);

  Future<void> deleteMonitorScheme();
  // </controllers>
}
// </interface>

// <mock>
class MockMonitorSchemeEditWindow implements MonitorSchemeEditWindow {
  @override
  final int targetTicketId;
  final Sink<List<Ticket>> ticketsStream;
  final List<Ticket> tickets;

  static const List<Currency> currencyList = [
    Currency(id: 0, symbol: 'JPY'),
    Currency(id: 1, symbol: 'USD'),
    Currency(id: 2, symbol: 'EUR'),
  ];

  static List<Category> categoryList = [
    for (int i = 0; i < 20; i++) Category(id: i, name: 'category$i')
  ];

  MockMonitorSchemeEditWindow(
      this.targetTicketId, this.ticketsStream, this.tickets);

  @override
  Future<List<Category>> getCategoryOptions() async {
    return categoryList;
  }

  @override
  Future<List<Currency>> getCurrencyOptions() async {
    return currencyList;
  }

  @override
  Future<MonitorScheme> getOriginalMonitorScheme() {
    var today = DateTime.now();
    var twoWeeksLater = today.add(const Duration(days: 14));
    var twoWeeksAgo = today.subtract(const Duration(days: 14));
    return Future.value(MonitorScheme(
      id: targetTicketId,
      period: OpenPeriod(
        begins: Date(twoWeeksAgo.year, twoWeeksAgo.month, twoWeeksAgo.day),
        ends: Date(twoWeeksLater.year, twoWeeksLater.month, twoWeeksLater.day),
      ),
      currency: CurrencyConfig(id: 0, symbol: currencyList[0].symbol, ratio: 1),
      displayConfig: MonitorDisplayConfig.meanInDays,
      categories: categoryList.sublist(0, 5),
    ));
  }

  @override
  Future<void> updateMonitorScheme(List<int> categoryIds, OpenPeriod period,
      MonitorDisplayConfig displayConfig, int currencyId) async {
    List<Ticket> newTickets = [];
    while (tickets.isNotEmpty) {
      var ticket = tickets.removeAt(0);
      if (ticket is! MonitorTicket) {
        newTickets.add(ticket);
        continue;
      }
      if (ticket.id != targetTicketId) {
        newTickets.add(ticket);
        continue;
      }
      newTickets.add(MonitorTicket(
        id: targetTicketId,
        period: period,
        displayConfig: displayConfig,
        price: Price(amount: 1000, symbol: currencyList[currencyId].symbol),
        categoryNames: categoryList
            .where((element) => categoryIds.contains(element.id))
            .map((e) => e.name)
            .toList(),
      ));
    }
    tickets.addAll(newTickets);
    ticketsStream.add(tickets);
  }

  @override
  Future<void> deleteMonitorScheme() async {
    tickets.removeWhere(
        (element) => element is MonitorTicket && element.id == targetTicketId);
    ticketsStream.add(tickets);
  }
}
// </mock>
