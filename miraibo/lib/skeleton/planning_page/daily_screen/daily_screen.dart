import 'dart:async';

import 'package:miraibo/skeleton/planning_page/daily_screen/estimation_scheme_edit_window.dart';
export 'package:miraibo/skeleton/planning_page/daily_screen/estimation_scheme_edit_window.dart';
import 'package:miraibo/skeleton/planning_page/daily_screen/monitor_scheme_edit_window.dart';
export 'package:miraibo/skeleton/planning_page/daily_screen/monitor_scheme_edit_window.dart';
import 'package:miraibo/skeleton/planning_page/daily_screen/receipt_log_edit_window.dart';
export 'package:miraibo/skeleton/planning_page/daily_screen/receipt_log_edit_window.dart';
import 'package:miraibo/skeleton/planning_page/daily_screen/plan_edit_window.dart';
export 'package:miraibo/skeleton/planning_page/daily_screen/plan_edit_window.dart';
import 'package:miraibo/skeleton/planning_page/daily_screen/ticket_create_window/ticket_create_window.dart';
export 'package:miraibo/skeleton/planning_page/daily_screen/ticket_create_window/ticket_create_window.dart';
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
  /// Get the tickets which belongs to the date which the specified [index] represents.
  ///
  /// The origin of the [index] is [initiallyCenteredDate].
  /// When [initiallyCenteredDate] is 2022-02-01, the [index] of 2022-02-01 is `0`,
  /// the [index] of 2022-02-02 is `1`, the [index] of 2022-01-31 is `-1`.
  Stream<List<Ticket>> getTicketsOn(int index);

  /// Get the label of the currently centered date.
  /// It is calculatedd by [initiallyCenteredDate] + [offset].
  Stream<Date> getLabel();
  // </presenters>

  // <navigators>
  // label
  /// When the label which shows the centered date is tapped, navigate to the monthly screen.
  MonthlyScreen navigateToMonthlyScreen();

  // tickets
  /// When the monitor ticket is tapped, open the monitor scheme edit window.
  MonitorSchemeEditWindow openMonitorSchemeEditWindow(int targetTicketId);

  /// When the plan ticket is tapped, open the plan edit window.
  PlanEditWindow openPlanEditWindow(int targetTicketId);

  /// When the estimation ticket is tapped, open the estimation scheme edit window.
  EstimationSchemeEditWindow openEstimationSchemeEditWindow(int targetTicketId);

  /// When the receipt log ticket is tapped, open the receipt log edit window.
  ReceiptLogEditWindow openReceiptLogEditWindow(int targetTicketId);

  // button
  /// When the ticket create button is tapped, open the ticket create window.
  TicketCreateWindow openTicketCreateWindow();

  /// should be called when this skeleton is no longer needed.
  void dispose();
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

  late final Stream<Date> labelStream;
  late final Sink<Date> labelSink;
  late final List<Ticket> tickets;
  late final Stream<List<Ticket>> ticketStream;
  late final Sink<List<Ticket>> ticketSink;
  MockDailyScreen(int year, int month, int day) {
    initiallyCenteredDate = Date(year, month, day);

    // <prepare parameters>
    final today = DateTime(year, month, day);
    final twoMonthAgo = today.subtract(const Duration(days: 2 * 31));
    final twoMonthLater = today.add(const Duration(days: 2 * 31));
    final startlessPeriod = OpenPeriod(
        begins: null,
        ends: Date(twoMonthLater.year, twoMonthLater.month, twoMonthLater.day));
    final endlessPeriod = OpenPeriod(
        begins: Date(twoMonthAgo.year, twoMonthAgo.month, twoMonthAgo.day),
        ends: null);
    final closedPeriod = OpenPeriod(
        begins: Date(twoMonthAgo.year, twoMonthAgo.month, twoMonthAgo.day),
        ends: Date(twoMonthLater.year, twoMonthLater.month, twoMonthLater.day));
    const price = Price(amount: 1000, symbol: 'JPY');
    // </prepare parameters>

    // <make mock tickets>
    tickets = [
      MonitorTicket(
          id: 0,
          period: startlessPeriod,
          price: price,
          displayOption: MonitordisplayOption.meanInDays,
          categoryNames: ['list of categories']),
      MonitorTicket(
          id: 1,
          period: endlessPeriod,
          price: price,
          displayOption: MonitordisplayOption.quartileMeanInDays,
          categoryNames: ['category1', 'category2']),
      MonitorTicket(
          id: 2,
          period: closedPeriod,
          price: price,
          displayOption: MonitordisplayOption.summation,
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
          displayOption: EstimationdisplayOption.perDay,
          categoryNames: ['list of categories']),
      EstimationTicket(
          id: 13,
          period: endlessPeriod,
          price: price,
          displayOption: EstimationdisplayOption.perMonth,
          categoryNames: ['category1', 'category2']),
      EstimationTicket(
          id: 14,
          period: closedPeriod,
          price: price,
          displayOption: EstimationdisplayOption.perWeek,
          categoryNames: []),
      EstimationTicket(
          id: 15,
          period: closedPeriod,
          price: price,
          displayOption: EstimationdisplayOption.perYear,
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

    // <initialize streams>
    final labelStreamController = StreamController<Date>();
    labelStream = labelStreamController.stream;
    labelSink = labelStreamController.sink;
    labelSink.add(initiallyCenteredDate);
    final ticketStreamController = StreamController<List<Ticket>>.broadcast();
    ticketStream = ticketStreamController.stream;
    ticketSink = ticketStreamController.sink;
    // </initialize streams>
  }

  @override
  Stream<List<Ticket>> getTicketsOn(int index) {
    ticketSink.add(tickets);
    return ticketStream;
  }

  @override
  Stream<Date> getLabel() {
    return labelStream;
  }

  @override
  MonthlyScreen navigateToMonthlyScreen() {
    final currentDate = DateTime(initiallyCenteredDate.year,
        initiallyCenteredDate.month, initiallyCenteredDate.day + offset);
    return MockMonthlyScreen(
        Date(currentDate.year, currentDate.month, currentDate.day));
  }

  @override
  MonitorSchemeEditWindow openMonitorSchemeEditWindow(int targetTicketId) {
    return MockMonitorSchemeEditWindow(targetTicketId, ticketSink, tickets);
  }

  @override
  PlanEditWindow openPlanEditWindow(int targetTicketId) {
    return MockPlanEditWindow(targetTicketId, ticketSink, tickets);
  }

  @override
  EstimationSchemeEditWindow openEstimationSchemeEditWindow(
      int targetTicketId) {
    return MockEstimationSchemeEditWindow(targetTicketId, ticketSink, tickets);
  }

  @override
  ReceiptLogEditWindow openReceiptLogEditWindow(int targetTicketId) {
    return MockReceiptLogEditWindow(targetTicketId, ticketSink, tickets);
  }

  @override
  TicketCreateWindow openTicketCreateWindow() {
    return MockTicketCreateWindow(tickets, ticketSink);
  }

  @override
  Future<void> setOffset(int offset) async {
    this.offset = offset;
    final centeredDate = DateTime(initiallyCenteredDate.year,
        initiallyCenteredDate.month, initiallyCenteredDate.day + offset);
    labelSink
        .add(Date(centeredDate.year, centeredDate.month, centeredDate.day));
  }

  @override
  void dispose() {
    labelSink.close();
    ticketSink.close();
  }
}
// </mock>
