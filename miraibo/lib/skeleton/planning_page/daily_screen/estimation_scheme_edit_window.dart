import 'package:miraibo/dto/dto.dart';

// <interface>
/// EstimationSchemeEditWindow is shown when the user wants to edit an estimation scheme.
///
/// An estimation scheme consists of the following information:
/// - which categories should be counted
/// - what period should be counted
/// - how to display the estimation
///   - which display config the ticket follows
///   - which currency the ticket uses
///
abstract interface class EstimationSchemeEditWindow {
  // <states>
  /// The ID of the target estimation scheme.
  /// This is used to identify the estimation scheme to be edited.
  int get targetSchemeId;
  // </states>

  // <presenters>
  /// Categories counted should be specified.
  /// All categories are shown as options.
  Future<List<Category>> getCategoryOptions();

  /// The currency in which the ticket is shown should be specified.
  /// All currencies are shown as options.
  Future<List<Currency>> getCurrencyOptions();

  /// Get the original estimation scheme.
  /// The original configuration should be supplied when users are editing it.
  Future<EstimationScheme> getOriginalEstimationScheme();
  // </presenters>

  // <controllers>
  /// Update the estimation scheme with the specified parameters.
  /// [targetSchemeId] is used to identify the estimation scheme to be updated.
  Future<void> updateEstimationScheme(List<int> categoryIds, OpenPeriod period,
      EstimationDisplayConfig displayConfig, int currencyId);

  /// Delete the estimation scheme.
  /// [targetSchemeId] is used to identify the estimation scheme to be deleted.
  Future<void> deleteEstimationScheme();
  // </controllers>
  void dispose();
}
// </interface>

// <mock>
class MockEstimationSchemeEditWindow implements EstimationSchemeEditWindow {
  @override
  final int targetSchemeId;
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
  Future<EstimationScheme> getOriginalEstimationScheme() {
    var today = DateTime.now();
    var twoWeeksLater = today.add(const Duration(days: 14));
    var twoWeeksAgo = today.subtract(const Duration(days: 14));
    return Future.value(EstimationScheme(
      id: targetSchemeId,
      period: OpenPeriod(
        begins: Date(twoWeeksAgo.year, twoWeeksAgo.month, twoWeeksAgo.day),
        ends: Date(twoWeeksLater.year, twoWeeksLater.month, twoWeeksLater.day),
      ),
      currency: currencyList[0],
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

  @override
  void dispose() {}
}
// </mock>