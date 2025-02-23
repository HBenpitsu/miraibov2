import 'package:miraibo/dto/dto.dart';
import 'dart:developer' show log;

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
  /// The ID of the monitor scheme to be edited.
  /// This is not changed during the lifecycle of the window.
  int get targetTicketId;
  // </state>

  // <presenters>
  /// categories counted should be specified.
  /// all of categories are shown as options.
  Future<List<Category>> getCategoryOptions();

  /// currency in which the ticket shown should be specified.
  /// all of currencies are shown as options.
  Future<List<Currency>> getCurrencyOptions();

  /// get original monitor scheme. original configuration should be supplied when users editing it.
  Future<MonitorScheme> getOriginalMonitorScheme();
  // </presenters>

  // <controllers>
  /// update the monitor scheme with the specified parameters.
  /// [targetTicketId] is used to identify the monitor scheme to be updated.
  Future<void> updateMonitorScheme(
      {required List<int> categoryIds,
      required OpenPeriod period,
      required MonitorDisplayOption displayOption,
      required int currencyId});

  /// delete the monitor scheme.
  /// [targetTicketId] is used to identify the monitor scheme to be deleted.
  Future<void> deleteMonitorScheme();
  // </controllers>

  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
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
    log('getCategoryOptions is called');
    return categoryList;
  }

  @override
  Future<List<Currency>> getCurrencyOptions() async {
    log('getCurrencyOptions is called');
    return currencyList;
  }

  @override
  Future<MonitorScheme> getOriginalMonitorScheme() {
    log('getOriginalMonitorScheme is called');
    final today = DateTime.now();
    final twoWeeksLater = today.add(const Duration(days: 14)).cutOffTime();
    final twoWeeksAgo = today.subtract(const Duration(days: 14)).cutOffTime();
    return Future.value(MonitorScheme(
      period: OpenPeriod(
        begins: twoWeeksAgo,
        ends: twoWeeksLater,
      ),
      currency: currencyList[0],
      displayOption: MonitorDisplayOption.meanInDays,
      categories: categoryList.sublist(0, 5),
    ));
  }

  @override
  Future<void> updateMonitorScheme(
      {required List<int> categoryIds,
      required OpenPeriod period,
      required MonitorDisplayOption displayOption,
      required int currencyId}) async {
    log('updateMonitorScheme is called with categoryIds: $categoryIds, period: $period, displayOption: $displayOption, currencyId: $currencyId');
    List<Ticket> newTickets = [];
    while (tickets.isNotEmpty) {
      final ticket = tickets.removeAt(0);
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
        displayOption: displayOption,
        price: Price(amount: 1000, symbol: currencyList[currencyId].symbol),
        categoryNames: categoryList
            .where((element) => categoryIds.contains(element.id))
            .map((e) => e.name)
            .toList(growable: false),
      ));
    }
    tickets.addAll(newTickets);
    ticketsStream.add(tickets);
  }

  @override
  Future<void> deleteMonitorScheme() async {
    log('deleteMonitorScheme is called with targetTicketId: $targetTicketId');
    tickets.removeWhere(
        (element) => element is MonitorTicket && element.id == targetTicketId);
    ticketsStream.add(tickets);
  }

  @override
  void dispose() {
    log('MonitorSchemeEditWindow is disposed');
  }
}
// </mock>
