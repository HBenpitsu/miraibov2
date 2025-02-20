import 'dart:async';

import 'package:miraibo/dto/dto.dart';
import 'package:miraibo/skeleton/main_page/monitor_scheme_edit_window.dart';
export 'package:miraibo/skeleton/main_page/monitor_scheme_edit_window.dart';
import 'package:miraibo/skeleton/main_page/receipt_log_confirmation_window.dart';
export 'package:miraibo/skeleton/main_page/receipt_log_confirmation_window.dart';
import 'package:miraibo/skeleton/main_page/receipt_log_create_window.dart';
export 'package:miraibo/skeleton/main_page/receipt_log_create_window.dart';
import 'package:miraibo/skeleton/main_page/receipt_log_edit_window.dart';

import 'dart:developer' show log;

// <interface>
/// main page consists of a row of tickets and a button to create a new receipt-log.
/// The tickets in main page are Log Tickets and Monitor Tickets.
/// Each ticket navigates to the ticket edit window.
/// But, the unconfirmed receipt-log navigates to the receipt-log confirmation window.
/// The button to create a new receipt-log navigates to the receipt-log create window.
abstract interface class MainPage {
  // <states>
  /// today is the date of the day when the main page is shown.
  /// Although 'today' can be calculated with ease, it is provided as a state to make this class testable.
  /// If it is not provided as a state, 'today' can be canged during the lifecycle of the page.
  /// For example, when the page is shown at 23:59 and the page is still building at 00:00,
  /// 'today' is changed during the process. That can cause a bug and inconsistent contents.
  Date get today;
  // </states>

  // <presenters>
  /// main page shows a row of tickets. So, the tickets should be provided.
  Stream<List<Ticket>> getTickets();
  // </presenters>

  // <navigators>
  // tickets
  /// monitor scheme edit window is shown when a monitor ticket is tapped.
  MonitorSchemeEditWindow openMonitorSchemeEditWindow(int targetTicketId);

  /// receipt log edit window is shown when a confirmed receipt log is tapped.
  ReceiptLogEditWindow openReceiptLogEditWindow(int targetTicketId);

  /// receipt log confirmation window is shown when a unconfirmed receipt log is tapped.
  ReceiptLogConfirmationWindow openReceiptLogConfirmationWindow(
      int targetTicketId);

  // button
  /// receipt log create window is shown when the button to create a new receipt log is tapped.
  ReceiptLogCreateWindow openReceiptLogCreateWindow();

  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}

// </inteface>

// <mock>
class MockMainPage implements MainPage {
  @override
  late final Date today;
  late final List<Ticket> tickets;
  late final Stream<List<Ticket>> ticketsStream;
  late final Sink<List<Ticket>> ticketsSink;

  MockMainPage() {
    log('MockMainPage is constructed');
    // <prepare parameters>
    final now = DateTime.now();
    today = now.cutOffTime();
    final twoMonthAgo = now.subtract(const Duration(days: 2 * 31)).cutOffTime();
    final twoMonthLater = now.add(const Duration(days: 2 * 31)).cutOffTime();
    final startlessPeriod = OpenPeriod(begins: null, ends: twoMonthLater);
    final endlessPeriod = OpenPeriod(begins: twoMonthAgo, ends: null);
    final closedPeriod = OpenPeriod(begins: twoMonthAgo, ends: twoMonthLater);
    const price = Price(amount: 1000, symbol: 'JPY');
    // </prepare parameters>

    // <make mock tickets to show>
    tickets = [
      MonitorTicket(
          id: 0,
          period: startlessPeriod,
          price: price,
          displayOption: MonitorDisplayOption.meanInDays,
          categoryNames: ['list of categories']),
      MonitorTicket(
          id: 1,
          period: endlessPeriod,
          price: price,
          displayOption: MonitorDisplayOption.quartileMeanInDays,
          categoryNames: ['category1', 'category2']),
      MonitorTicket(
          id: 2,
          period: closedPeriod,
          price: price,
          displayOption: MonitorDisplayOption.summation,
          categoryNames: []),
      ReceiptLogTicket(
          id: 16,
          date: today,
          price: price,
          description: 'this is a description of the receipt log.',
          categoryName: 'category0',
          confirmed: true),
      ReceiptLogTicket(
          id: 17,
          date: today,
          price: price,
          description: 'this is a description of the receipt log.',
          categoryName: 'category0',
          confirmed: false)
    ];
    // </make mock tickets to show>

    // <initialize stream>
    final ticketsStreamController = StreamController<List<Ticket>>.broadcast();
    ticketsStream = ticketsStreamController.stream;
    ticketsSink = ticketsStreamController.sink;

    ticketsSink.add(tickets);
    // </initialize stream>
  }

  @override
  Stream<List<Ticket>> getTickets() {
    log('getTickets is called');
    final returnStreamController = StreamController<List<Ticket>>();
    returnStreamController.add(tickets);
    returnStreamController.addStream(ticketsStream);
    return returnStreamController.stream;
  }

  @override
  MonitorSchemeEditWindow openMonitorSchemeEditWindow(int targetTicketId) {
    log('openMonitorSchemeEditWindow is called with targetTicketId: $targetTicketId');
    return MockMonitorSchemeEditWindow(targetTicketId, ticketsSink, tickets);
  }

  @override
  ReceiptLogEditWindow openReceiptLogEditWindow(int targetTicketId) {
    log('openReceiptLogEditWindow is called with targetTicketId: $targetTicketId');
    return MockReceiptLogEditWindow(targetTicketId, ticketsSink, tickets);
  }

  @override
  ReceiptLogConfirmationWindow openReceiptLogConfirmationWindow(
      int targetTicketId) {
    log('openReceiptLogConfirmationWindow is called with targetTicketId: $targetTicketId');
    return MockReceiptLogConfirmationWindow(
        targetTicketId, tickets, ticketsSink);
  }

  @override
  ReceiptLogCreateWindow openReceiptLogCreateWindow() {
    log('openReceiptLogCreateWindow is called');
    return MockReceiptLogCreateWindow(tickets, ticketsSink);
  }

  @override
  void dispose() {
    log('MockMainPage is disposed');
  }
}
// </mock>
