import 'package:miraibo/dto/dto.dart';

// <interface>
/// PlanEditWindow is a window to edit a plan.
/// A plan consists of following information:
///
/// - which category the plan belongs to
/// - what the plan is
/// - how much the plan will cost
/// - when the plan will be executed
///

abstract interface class PlanEditWindow {
  // <states>
  int get targetPlanId;
  // </states>

  // <presenters>
  /// category to which the plan belongs should be specified.
  /// all of categories are shown as options.
  Future<List<Category>> getCategoryOptions();

  /// currency in which the plan costs should be specified.
  /// all of currencies are shown as options.
  Future<List<Currency>> getCurrencyOptions();

  // here, we do not need default currency, because original plan already has currency.

  /// get original plan. original configuration should be supplied when users editing it.
  Future<PlanScheme> getOriginalPlan();
  // </presenters>

  // <controllers>
  Future<void> updatePlan(
      int categoryId, String description, Price price, Schedule schedule);

  Future<void> deletePlan();
  // </controllers>
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
    return categoryList;
  }

  @override
  Future<List<Currency>> getCurrencyOptions() async {
    return currencyList;
  }

  @override
  Future<PlanScheme> getOriginalPlan() {
    var today = DateTime.now();
    return Future.value(PlanScheme(
        id: targetPlanId,
        category: categoryList[0],
        schedule:
            OneshotSchedule(date: Date(today.year, today.month, today.day)),
        price: PriceConfig(
            amount: 1000,
            currencyId: 0,
            currencySymbol: currencyList[0].symbol),
        description: 'original discription of the plan'));
  }

  @override
  Future<void> updatePlan(int categoryId, String description, Price price,
      Schedule schedule) async {
    List<Ticket> newTickets = [];
    while (tickets.isNotEmpty) {
      var ticket = tickets.removeAt(0);
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
        price: price,
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
    tickets.removeWhere(
        (element) => element is PlanTicket && element.id == targetPlanId);
    ticketsStream.add(tickets);
  }
}
// </mock>