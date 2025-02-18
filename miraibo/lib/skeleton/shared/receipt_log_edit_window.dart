import 'package:miraibo/dto/dto.dart';

// <interface>
/// receipt log edit window is shown when user wants to edit receipt log.
///
/// receipt log consists of following information:
///
/// - which category the receipt log belongs to
/// - what the receipt log is
/// - how much the receipt log costs
/// - when the receipt log was created
/// - whether the receipt log is confirmed
///
abstract interface class ReceiptLogEditWindow {
  // <state>
  /// The ID of the receipt log to be edited.
  /// This is not changed during the lifecycle of the window.
  int get targetLogId;
  // </state>

  // <presenters>
  /// category to which the receipt log belongs should be specified.
  /// all of categories are shown as options.
  Future<List<Category>> getCategoryOptions();

  /// currency in which the receipt log costs should be specified.
  /// all of currencies are shown as options.
  Future<List<Currency>> getCurrencyOptions();

  // here, we do not need default currency, because original receipt log already has currency.

  /// get original receipt log. original configuration should be supplied when users editing it.
  Future<ReceiptLogScheme> getOriginalReceiptLog();
  // </presenters>

  // <controllers>
  /// update the receipt log with the specified parameters.
  /// [targetLogId] is used to identify the receipt log to be updated.
  Future<void> updateReceiptLog(
      {required int categoryId,
      required String description,
      required int amount,
      required int currencyId,
      required Date date});

  /// delete the receipt log.
  /// [targetLogId] is used to identify the receipt log to be deleted.
  Future<void> deleteReceiptLog();
  // </controllers>

  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}
// </interface>

// <mock>
class MockReceiptLogEditWindow implements ReceiptLogEditWindow {
  @override
  final int targetLogId;
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

  MockReceiptLogEditWindow(this.targetLogId, this.ticketsStream, this.tickets);

  @override
  Future<List<Category>> getCategoryOptions() async {
    return categoryList;
  }

  @override
  Future<List<Currency>> getCurrencyOptions() async {
    return currencyList;
  }

  @override
  Future<ReceiptLogScheme> getOriginalReceiptLog() {
    final today = DateTime.now().cutOffTime();
    return Future.value(ReceiptLogScheme(
      category: categoryList[0],
      date: today,
      price: const ConfigureblePrice(
          amount: 1000, currencyId: 0, currencySymbol: 'JPY'),
      description: 'original description of the receipt log',
      confirmed: false,
    ));
  }

  @override
  Future<void> updateReceiptLog(
      {required int categoryId,
      required String description,
      required int amount,
      required int currencyId,
      required Date date}) async {
    List<Ticket> newTickets = [];
    while (tickets.isNotEmpty) {
      final ticket = tickets.removeAt(0);
      if (ticket is! ReceiptLogTicket) {
        newTickets.add(ticket);
        continue;
      }
      if (ticket.id != targetLogId) {
        newTickets.add(ticket);
        continue;
      }
      newTickets.add(ReceiptLogTicket(
        id: targetLogId,
        price: Price(amount: amount, symbol: currencyList[currencyId].symbol),
        date: date,
        description: description,
        categoryName: categoryList[categoryId].name,
        confirmed: true,
      ));
    }
    tickets.addAll(newTickets);
    ticketsStream.add(tickets);
  }

  @override
  Future<void> deleteReceiptLog() async {
    tickets.removeWhere(
        (element) => element is ReceiptLogTicket && element.id == targetLogId);
    ticketsStream.add(tickets);
  }

  @override
  void dispose() {}
}
// </mock>

