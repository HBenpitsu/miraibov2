import 'dart:async';

import 'package:miraibo/skeleton/planning_page/daily_screen/estimation_scheme_edit_window.dart';
import 'package:miraibo/skeleton/planning_page/daily_screen/monitor_scheme_edit_window.dart';
import 'package:miraibo/skeleton/planning_page/daily_screen/receipt_log_edit_window.dart';
import 'package:miraibo/skeleton/planning_page/daily_screen/plan_edit_window.dart';
import 'package:miraibo/skeleton/planning_page/daily_screen/ticket_create_window/ticket_create_window.dart';
import 'package:miraibo/dto/dto.dart';
import 'package:miraibo/skeleton/planning_page/monthly_screen.dart';

// <interface>
/// Daily screen consists of infinite set of tickets.
/// But, the tickets are grouped by the date.
///
/// Each ticket (Monitor Ticket, Estimation Ticket, Plan Ticket or Log Ticket)
/// navigates to the ticket edit window.
///
/// Also, following components are also included:
/// - A button to create a new ticket.
/// - A label to show which date is centered and to navigate to Monthly Screen.
///
/// The daily screen is scrollable horizontally. So, the centered date can be changed.
/// It should be notified to the [DailyScreen] through [setOffset] to update the state and the Label.

abstract interface class DailyScreen {
  // <states>
  /// The [initiallyCenteredDate] serves as a reference point for the daily screen, determining what index-0 represents.
  /// shownDate should not be mutated during the lifecycle of the daily screen.
  Date get initiallyCenteredDate;

  /// the offset is a offset of currently centered date from the [initiallyCenteredDate].
  abstract int offset;
  // </states>

  // <presenters>
  /// The origin of the [index] is [initiallyCenteredDate].
  /// When [initiallyCenteredDate] is 2022-02-01, the [index] of 2022-02-01 is `0`,
  /// the [index] of 2022-02-02 is `1`, the [index] of 2022-01-31 is `-1`.
  Stream<List<Ticket>> getTicketsOn(int index);

  Stream<Date> getLabel();
  // </presenters>

  // <navigators>
  // label
  MonthlyScreen navigateToMonthlyScreen();

  // tickets
  MonitorSchemeEditWindow openMonitorSchemeEditWindow(int targetTicketId);
  PlanEditWindow openPlanEditWindow(int targetTicketId);
  EstimationSchemeEditWindow openEstimationSchemeEditWindow(int targetTicketId);
  ReceiptLogEditWindow openReceiptLogEditWindow(int targetTicketId);

  // button
  TicketCreateWindow openTicketCreateWindow();
  // </navigators>

  // <actions>
  /// the offset is a offset of currently centered date from the [initiallyCenteredDate].
  /// This should be updated properly to show proper date on `Label`, `ticketCreateWindow`, and `ticketEditWindow`.
  Future<void> setOffset(int offset);
  // </actions>
}

// </interface>

// <mock>
class MockDailyScreen implements DailyScreen {
  @override
  late final Date initiallyCenteredDate;

  @override
  int offset = 0;

  final StreamController<Date> _labelStream = StreamController();
  late final List<Ticket> tickets;
  final StreamController<List<Ticket>> ticketStreams = StreamController();
  MockDailyScreen(int year, int month, int day) {
    initiallyCenteredDate = Date(year, month, day);
    _labelStream.add(initiallyCenteredDate);

    // <make mock tickets>

    var today = DateTime(year, month, day);
    var twoMonthAgo = today.subtract(const Duration(days: 2 * 31));
    var twoMonthLater = today.add(const Duration(days: 2 * 31));
    var startlessPeriod = OpenPeriod(
        begins: null,
        ends: Date(twoMonthLater.year, twoMonthLater.month, twoMonthLater.day));
    var endlessPeriod = OpenPeriod(
        begins: Date(twoMonthAgo.year, twoMonthAgo.month, twoMonthAgo.day),
        ends: null);
    var closedPeriod = OpenPeriod(
        begins: Date(twoMonthAgo.year, twoMonthAgo.month, twoMonthAgo.day),
        ends: Date(twoMonthLater.year, twoMonthLater.month, twoMonthLater.day));
    var price = const Price(amount: 1000, symbol: 'JPY');

    tickets = [
      MonitorTicket(
          id: 0,
          period: startlessPeriod,
          price: price,
          displayConfig: MonitorDisplayConfig.meanInDays,
          categoryNames: ['list of categories']),
      MonitorTicket(
          id: 1,
          period: endlessPeriod,
          price: price,
          displayConfig: MonitorDisplayConfig.quartileMeanInDays,
          categoryNames: ['category1', 'category2']),
      MonitorTicket(
          id: 2,
          period: closedPeriod,
          price: price,
          displayConfig: MonitorDisplayConfig.summation,
          categoryNames: []),
      PlanTicket(
          id: 3,
          schedule: OneshotSchedule(date: Date(year, month, day)),
          price: price,
          description: 'this is a description of the plan.',
          categoryName: 'category'),
      PlanTicket(
          id: 4,
          schedule: IntervalSchedule(
              originDate: Date(year, month, day),
              period: const OpenPeriod(),
              interval: 1),
          price: price,
          description: 'this is a description of the plan.',
          categoryName: 'category'),
      PlanTicket(
          id: 5,
          schedule: IntervalSchedule(
              originDate: Date(year, month, day),
              period: OpenPeriod(
                  begins: Date(
                      twoMonthAgo.year, twoMonthAgo.month, twoMonthAgo.day)),
              interval: 1),
          price: price,
          description: 'this is a description of the plan.',
          categoryName: 'category'),
      PlanTicket(
          id: 6,
          schedule: IntervalSchedule(
              originDate: Date(year, month, day),
              period: OpenPeriod(
                  ends: Date(twoMonthLater.year, twoMonthLater.month,
                      twoMonthLater.day)),
              interval: 3),
          price: price,
          description: 'this is a description of the plan.',
          categoryName: 'category'),
      PlanTicket(
          id: 7,
          schedule: IntervalSchedule(
              originDate: Date(year, month, day),
              period: OpenPeriod(
                  begins: Date(
                      twoMonthAgo.year, twoMonthAgo.month, twoMonthAgo.day),
                  ends: Date(twoMonthLater.year, twoMonthLater.month,
                      twoMonthLater.day)),
              interval: 1),
          price: price,
          description: 'this is a description of the plan.',
          categoryName: 'category'),
      PlanTicket(
          id: 8,
          schedule: WeeklySchedule(
              period: closedPeriod,
              sunday: true,
              monday: false,
              tuesday: false,
              wednesday: false,
              thursday: true,
              friday: false,
              saturday: false),
          price: price,
          description: 'this is a description of the plan.',
          categoryName: 'category'),
      PlanTicket(
          id: 9,
          schedule: MonthlySchedule(period: closedPeriod, offset: 1),
          price: price,
          description: 'this is a description of the plan.',
          categoryName: 'category'),
      PlanTicket(
          id: 10,
          schedule: MonthlySchedule(period: closedPeriod, offset: -1),
          price: price,
          description: 'this is a description of the plan.',
          categoryName: 'category'),
      PlanTicket(
          id: 11,
          schedule: AnnualSchedule(
              period: closedPeriod, originDate: Date(year, month, day)),
          price: price,
          description: 'this is a description of the plan.',
          categoryName: 'category'),
      EstimationTicket(
          id: 12,
          period: startlessPeriod,
          price: price,
          displayConfig: EstimationDisplayConfig.perDay,
          categoryNames: ['list of categories']),
      EstimationTicket(
          id: 13,
          period: endlessPeriod,
          price: price,
          displayConfig: EstimationDisplayConfig.perMonth,
          categoryNames: ['category1', 'category2']),
      EstimationTicket(
          id: 14,
          period: closedPeriod,
          price: price,
          displayConfig: EstimationDisplayConfig.perWeek,
          categoryNames: []),
      EstimationTicket(
          id: 15,
          period: closedPeriod,
          price: price,
          displayConfig: EstimationDisplayConfig.perYear,
          categoryNames: []),
      ReceiptLogTicket(
          id: 16,
          date: Date(year, month, day),
          price: price,
          description: 'this is a description of the receipt log.',
          categoryName: 'category0',
          confirmed: true),
      ReceiptLogTicket(
          id: 17,
          date: Date(year, month, day),
          price: price,
          description: 'this is a description of the receipt log.',
          categoryName: 'category0',
          confirmed: false)
    ];

    // </make mock tickets>

    ticketStreams.add(tickets);
  }

  @override
  Stream<List<Ticket>> getTicketsOn(int index) {
    return ticketStreams.stream;
  }

  @override
  Stream<Date> getLabel() {
    return _labelStream.stream;
  }

  @override
  MonthlyScreen navigateToMonthlyScreen() {
    var currentDate = DateTime(initiallyCenteredDate.year,
        initiallyCenteredDate.month, initiallyCenteredDate.day + offset);
    return MockMonthlyScreen(
        Date(currentDate.year, currentDate.month, currentDate.day));
  }

  @override
  MonitorSchemeEditWindow openMonitorSchemeEditWindow(int targetTicketId) {
    return MockMonitorSchemeEditWindow(
        targetTicketId, ticketStreams.sink, tickets);
  }

  @override
  PlanEditWindow openPlanEditWindow(int targetTicketId) {
    return MockPlanEditWindow(targetTicketId, ticketStreams.sink, tickets);
  }

  @override
  EstimationSchemeEditWindow openEstimationSchemeEditWindow(
      int targetTicketId) {
    return MockEstimationSchemeEditWindow(
        targetTicketId, ticketStreams.sink, tickets);
  }

  @override
  ReceiptLogEditWindow openReceiptLogEditWindow(int targetTicketId) {
    return MockReceiptLogEditWindow(
        targetTicketId, ticketStreams.sink, tickets);
  }

  @override
  TicketCreateWindow openTicketCreateWindow() {
    return MockTicketCreateWindow(tickets, ticketStreams.sink);
  }

  @override
  Future<void> setOffset(int offset) async {
    this.offset = offset;
    var centeredDate = DateTime(initiallyCenteredDate.year,
        initiallyCenteredDate.month, initiallyCenteredDate.day + offset);
    _labelStream
        .add(Date(centeredDate.year, centeredDate.month, centeredDate.day));
  }
}
// </mock>