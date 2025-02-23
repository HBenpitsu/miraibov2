import 'dart:math' show Random;

import 'package:miraibo/dto/dto.dart';

import 'dart:developer' show log;

// <interface>
/// ReceiptLogWindow is a window to create a receipt log.
/// A receipt log consists of the following information:
///
/// - which category the receipt log belongs to
/// - what the receipt log is
/// - how much the receipt log costs
/// - when the receipt log was created
/// - whether the receipt log is confirmed
///
/// Although this window is virtually the same as [ReceiptLogSection],
/// the difference is that they are window and section(not window).
/// This difference keep [ReceiptLogSection] and [ReceiptLogCreateWindow] separate.
abstract interface class ReceiptLogCreateWindow {
  // <presenters>
  /// category to which the receipt log belongs should be specified.
  /// all of categories are shown as options.
  Future<List<Category>> getCategoryOptions();

  /// currency in which the receipt log costs should be specified.
  /// all of currencies are shown as options.
  Future<List<Currency>> getCurrencyOptions();

  /// initial scheme should be supplied.
  Future<ReceiptLogScheme> getInitialScheme();

  /// for convenience, presets for the receipt log should be supplied.
  Future<List<ReceiptLogSchemePreset>> getPresets();

  // </presenters>

  // <controllers>
  /// create the receipt log with the specified scheme.
  Future<void> createReceiptLog(
      {required int categoryId,
      required String description,
      required int amount,
      required int currencyId,
      required Date date});
  // </controllers>

  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}
// </interface>

// <mock>
class MockReceiptLogCreateWindow implements ReceiptLogCreateWindow {
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

  MockReceiptLogCreateWindow(this.tickets, this.ticketsStream);

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
  Future<ReceiptLogScheme> getInitialScheme() async {
    log('getDefaultCurrency is called');
    return ReceiptLogScheme(
        date: DateTime.now().cutOffTime(),
        price: ConfigureblePrice(
            amount: 0, currencyId: 0, currencySymbol: currencyList[0].symbol),
        description: '',
        category: categoryList[0],
        confirmed: true);
  }

  @override
  Future<List<ReceiptLogSchemePreset>> getPresets() async {
    log('getPresets is called');
    return [
      ReceiptLogSchemePreset(
        price: ConfigureblePrice(
            amount: 100, currencyId: 0, currencySymbol: currencyList[0].symbol),
        description:
            'preset1 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
        category: Category(id: 0, name: categoryList[0].name),
      ),
      ReceiptLogSchemePreset(
        price: ConfigureblePrice(
            amount: 100, currencyId: 1, currencySymbol: currencyList[1].symbol),
        description: 'preset2',
        category: Category(id: 0, name: categoryList[0].name),
      ),
      ReceiptLogSchemePreset(
        price: ConfigureblePrice(
            amount: 100, currencyId: 1, currencySymbol: currencyList[1].symbol),
        description: '',
        category: Category(id: 0, name: categoryList[0].name),
      ),
      ReceiptLogSchemePreset(
        price: ConfigureblePrice(
            amount: 100, currencyId: 1, currencySymbol: currencyList[1].symbol),
        description: '',
        category: Category(id: 0, name: categoryList[0].name),
      ),
      ReceiptLogSchemePreset(
        price: ConfigureblePrice(
            amount: 100, currencyId: 1, currencySymbol: currencyList[1].symbol),
        description: 'preset5',
        category: Category(id: 0, name: categoryList[0].name),
      ),
    ];
  }

  @override
  Future<void> createReceiptLog(
      {required int categoryId,
      required String description,
      required int amount,
      required int currencyId,
      required Date date}) async {
    log('createReceiptLog is called with categoryId: $categoryId, description: $description, amount: $amount, currencyId: $currencyId, date: $date');
    final id = DateTime.now().millisecondsSinceEpoch * 10 + random.nextInt(10);
    tickets.add(ReceiptLogTicket(
        id: id,
        date: date,
        price: Price(amount: amount, symbol: currencyList[currencyId].symbol),
        description: description,
        categoryName: categoryList[categoryId].name,
        confirmed: true));
    ticketsStream.add(tickets);
  }

  @override
  void dispose() {
    log('MockReceiptLogCreateWindow is disposed');
  }
}
// </mock>
