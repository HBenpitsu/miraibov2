import 'package:miraibo/dto/dto.dart';
import 'dart:developer' show log;

// <interface>
/// PlanEditWindow is a window to edit a plan.
/// A plan consists of the following information:
///
/// - which category the plan belongs to
/// - what the plan is
/// - how much the plan will cost
/// - when the plan will be executed
///
abstract interface class PlanEditWindow {
  // <states>
  /// This is used to identify the plan to be edited.
  /// This is not changed during the lifecycle of the window.
  int get targetPlanId;
  // </states>

  // <presenters>
  /// The category to which the plan belongs should be specified.
  /// All categories are shown as options.
  Future<List<Category>> getCategoryOptions();

  /// The currency in which the plan costs should be specified.
  /// All currencies are shown as options.
  Future<List<Currency>> getCurrencyOptions();

  /// Get the original plan.
  /// The original scheme of the plan should be supplied when users are editing it.
  Future<PlanScheme> getOriginalPlan();
  // </presenters>

  // <controllers>
  /// Update the plan with the specified parameters.
  /// [targetPlanId] is used to identify the plan to be updated.
  Future<void> updatePlan(
      {required int categoryId,
      required String description,
      required int amount,
      required int currencyId,
      required Schedule schedule});

  /// Delete the plan.
  /// [targetPlanId] is used to identify the plan to be deleted.
  Future<void> deletePlan();
  // </controllers>

  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}
// </interface>

// <mock>
class MockPlanEditWindow implements PlanEditWindow {
  @override
  final int targetPlanId;
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

  MockPlanEditWindow(this.targetPlanId, this.ticketsStream, this.tickets);

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
  Future<PlanScheme> getOriginalPlan() {
    log('getOriginalPlan is called with targetPlanId: $targetPlanId');
    final today = DateTime.now().cutOffTime();
    return Future.value(PlanScheme(
        category: categoryList[0],
        schedule: OneshotSchedule(date: today),
        price: ConfigureblePrice(
            amount: 1000,
            currencyId: 0,
            currencySymbol: currencyList[0].symbol),
        description: 'original description of the plan'));
  }

  @override
  Future<void> updatePlan(
      {required int categoryId,
      required String description,
      required int amount,
      required int currencyId,
      required Schedule schedule}) async {
    log('updatePlan is called with categoryId: $categoryId, description: $description, amount: $amount, currencyId: $currencyId, schedule: $schedule');
    List<Ticket> newTickets = [];
    while (tickets.isNotEmpty) {
      final ticket = tickets.removeAt(0);
      if (ticket is! PlanTicket) {
        newTickets.add(ticket);
        continue;
      }
      if (ticket.id != targetPlanId) {
        newTickets.add(ticket);
        continue;
      }
      newTickets.add(PlanTicket(
        id: targetPlanId,
        price: Price(amount: amount, symbol: currencyList[currencyId].symbol),
        schedule: schedule,
        description: description,
        categoryName: categoryList[categoryId].name,
      ));
    }
    tickets.addAll(newTickets);
    ticketsStream.add(tickets);
  }

  @override
  Future<void> deletePlan() async {
    log('deletePlan is called with targetPlanId: $targetPlanId');
    tickets.removeWhere(
        (element) => element is PlanTicket && element.id == targetPlanId);
    ticketsStream.add(tickets);
  }

  @override
  void dispose() {
    log('PlanEditWindow is disposed');
  }
}
// </mock>