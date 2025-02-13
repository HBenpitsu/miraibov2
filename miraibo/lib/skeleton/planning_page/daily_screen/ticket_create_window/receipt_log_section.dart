import 'dart:math' show Random;
import 'package:miraibo/dto/dto.dart';

// <interface>
/// ReceiptLogSection is a section to create a receipt log.
/// A receipt log consists of the following information:
///
/// - which category the receipt log belongs to
/// - what the receipt log is
/// - how much the receipt log costs
/// - when the receipt log was created
/// - whether the receipt log is confirmed
///
abstract interface class ReceiptLogSection {
  // <presenters>
  /// category to which the receipt log belongs should be specified.
  /// all of categories are shown as options.
  Future<List<Category>> getCategoryOptions();

  /// currency in which the receipt log costs should be specified.
  /// all of currencies are shown as options.
  Future<List<Currency>> getCurrencyOptions();

  /// for convenience, default currency should be supplied.
  Future<Currency> getDefaultCurrency();
  // </presenters>

  // <controllers>
  Future<void> createReceiptLog(int categoryId, String description, Price price,
      Date date, bool confirmed);
  // </controllers>
}
// </interface>

// <mock>
class MockReceiptLogSection implements ReceiptLogSection {
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

  MockReceiptLogSection(this.tickets, this.ticketsStream);

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
  Future<void> createReceiptLog(int categoryId, String description, Price price,
      Date date, bool confirmed) async {
    var id = DateTime.now().millisecondsSinceEpoch * 10 + random.nextInt(10);
    tickets.add(ReceiptLogTicket(
        id: id,
        price: price,
        date: date,
        description: description,
        categoryName: categoryList[categoryId].name,
        confirmed: confirmed));
    ticketsStream.add(tickets);
  }
}
// </mock>
