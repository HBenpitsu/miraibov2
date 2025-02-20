import 'dart:math' show Random;
import 'package:miraibo/dto/dto.dart';

import 'dart:developer' show log;

// <interface>
/// PlanSection is a section to create a plan.
/// A plan consists of following information:
///
/// - which category the plan belongs to
/// - what the plan is
/// - how much the plan will cost
/// - when the plan will be executed
///

abstract interface class PlanSection {
  // <presenters>
  /// category to which the plan belongs should be specified.
  /// all of categories are shown as options.
  Future<List<Category>> getCategoryOptions();

  /// currency in which the plan costs should be specified.
  /// all of currencies are shown as options.
  Future<List<Currency>> getCurrencyOptions();

  /// for convenience, default currency should be supplied.
  Future<Currency> getDefaultCurrency();
  // </presenters>

  // <controllers>
  /// create the plan with the specified scheme.
  Future<void> createPlan(
      {required int categoryId,
      required String description,
      required int amount,
      required int currencyId,
      required Schedule schedule});
  // </controllers>

  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}
// </interface>

// <mock>
class MockPlanSection implements PlanSection {
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

  MockPlanSection(this.tickets, this.ticketsStream);

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
  Future<Currency> getDefaultCurrency() async {
    log('getDefaultCurrency is called');
    return currencyList[0];
  }

  @override
  Future<void> createPlan(
      {required int categoryId,
      required String description,
      required int amount,
      required int currencyId,
      required Schedule schedule}) async {
    log('createPlan is called');
    final id = DateTime.now().millisecondsSinceEpoch * 10 + random.nextInt(10);
    tickets.add(PlanTicket(
        id: id,
        price: Price(amount: amount, symbol: currencyList[currencyId].symbol),
        schedule: schedule,
        description: description,
        categoryName: categoryList[categoryId].name));
    ticketsStream.add(tickets);
  }

  @override
  void dispose() {
    log('dispose is called');
  }
}
// </mock>
