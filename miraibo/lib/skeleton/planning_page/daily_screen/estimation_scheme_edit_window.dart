import 'package:miraibo/dto/dto.dart';

// <interface>
abstract interface class EstimationSchemeEditWindow {
  /// estimation scheme edit window is shown when user wants to edit estimation scheme.
  ///
  /// estimation scheme consists of following information:
  ///
  /// - which categories should be counted
  /// - what period should be counted
  /// - how to display estimation
  ///    - which display config does the ticket follow
  ///    - which currency does the ticket use
  ///

  // <states>
  int get targetSchemeId;
  // </states>

  // <presenters>
  /// categories counted should be specified.
  /// all of categories are shown as options.
  Future<List<Category>> getCategoryOptions();

  /// currency in which the ticket shown should be specified.
  /// all of currencies are shown as options.
  Future<List<Currency>> getCurrencyOptions();

  // here, we do not need default currency, because original estimation scheme already has currency.

  /// get original estimation scheme. original configuration should be supplied when users editing it.
  Future<RawEstimationScheme> getOriginalEstimationScheme();
  // </presenters>

  // <controllers>
  Future<void> updateEstimationScheme(List<int> categoryIds, OpenPeriod period,
      EstimationDisplayConfig displayConfig, int currencyId);

  Future<void> deleteEstimationScheme();
  // </controllers>
}
// </interface>

// <mock>
class MockEstimationSchemeEditWindow implements EstimationSchemeEditWindow {
  @override
  final int targetSchemeId;
  final Sink ticketsStream;
  final List<Ticket> tickets;

  static const List<Currency> currencyList = [
    Currency(id: 0, symbol: 'JPY'),
    Currency(id: 1, symbol: 'USD'),
    Currency(id: 2, symbol: 'EUR'),
  ];

  static List<Category> categoryList = [
    for (int i = 0; i < 20; i++) Category(id: i, name: 'category$i')
  ];

  MockEstimationSchemeEditWindow(
      this.targetSchemeId, this.ticketsStream, this.tickets);

  @override
  Future<List<Category>> getCategoryOptions() async {
    return categoryList;
  }

  @override
  Future<List<Currency>> getCurrencyOptions() async {
    return currencyList;
  }

  @override
  Future<RawEstimationScheme> getOriginalEstimationScheme() {
    var today = DateTime.now();
    var twoWeeksLater = today.add(const Duration(days: 14));
    var twoWeeksAgo = today.subtract(const Duration(days: 14));
    return Future.value(RawEstimationScheme(
      id: targetSchemeId,
      period: OpenPeriod(
        begins: Date(twoWeeksAgo.year, twoWeeksAgo.month, twoWeeksAgo.day),
        ends: Date(twoWeeksLater.year, twoWeeksLater.month, twoWeeksLater.day),
      ),
      price:
          const PriceInfo(amount: 1000, currencyId: 0, currencySymbol: 'JPY'),
      displayConfig: EstimationDisplayConfig.perWeek,
      categories: categoryList.sublist(0, 5),
    ));
  }

  @override
  Future<void> updateEstimationScheme(List<int> categoryIds, OpenPeriod period,
      EstimationDisplayConfig displayConfig, int currencyId) async {
    List<Ticket> newTickets = [];
    while (tickets.isNotEmpty) {
      var ticket = tickets.removeAt(0);
      if (ticket is! EstimationTicket) {
        newTickets.add(ticket);
        continue;
      }
      if (ticket.id != targetSchemeId) {
        newTickets.add(ticket);
        continue;
      }
      newTickets.add(EstimationTicket(
        id: targetSchemeId,
        period: period,
        price: Price(amount: 1000, symbol: currencyList[currencyId].symbol),
        displayConfig: displayConfig,
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
  Future<void> deleteEstimationScheme() async {
    tickets.removeWhere((element) =>
        element is EstimationTicket && element.id == targetSchemeId);
    ticketsStream.add(tickets);
  }
}
// </mock>