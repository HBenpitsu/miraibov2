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
  Future<void> updateReceiptLog(int categoryId, String description, Price price,
      Date date, bool confirmed);

  Future<void> deleteReceiptLog();
  // </controllers>
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
    var today = DateTime.now();
    return Future.value(ReceiptLogScheme(
      id: targetLogId,
      category: categoryList[0],
      date: Date(today.year, today.month, today.day),
      price:
          const PriceConfig(amount: 1000, currencyId: 0, currencySymbol: 'JPY'),
      description: 'original description of the receipt log',
      confirmed: false,
    ));
  }

  @override
  Future<void> updateReceiptLog(int categoryId, String description, Price price,
      Date date, bool confirmed) async {
    List<Ticket> newTickets = [];
    while (tickets.isNotEmpty) {
      var ticket = tickets.removeAt(0);
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
        price: price,
        date: date,
        description: description,
        categoryName: categoryList[categoryId].name,
        confirmed: confirmed,
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
}
// </mock>

