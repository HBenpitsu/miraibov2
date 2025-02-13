import 'dart:async';

import 'package:miraibo/dto/dto.dart';
import 'package:miraibo/skeleton/main_page/monitor_scheme_edit_window.dart';
import 'package:miraibo/skeleton/main_page/receipt_log_confirmation_window.dart';
import 'package:miraibo/skeleton/main_page/receipt_log_create_window.dart';
import 'package:miraibo/skeleton/main_page/receipt_log_edit_window.dart';

// <interface>
/// main page consists of a row of tickets and a button to create a new receipt-log.
/// The tickets in main page are Log Tickets and Monitor Tickets.
/// Each ticket navigates to the ticket edit window.
/// But, the unconfirmed receipt-log navigates to the receipt-log confirmation window.
/// The button to create a new receipt-log navigates to the receipt-log create window.
abstract interface class MainPage {
  // <states>
  Date get today;
  // </states>

  // <presenters>
  /// main page shows a row of tickets. So, the tickets should be provided.
  Stream<List<ReceiptLogAndMonitorTicket>> getTickets();
  // </presenters>

  // <navigators>
  // tickets
  MonitorSchemeEditWindow openMonitorSchemeEditWindow(int targetTicketId);
  ReceiptLogEditWindow openReceiptLogEditWindow(int targetTicketId);
  ReceiptLogConfirmationWindow openReceiptLogConfirmationWindow(
      int targetTicketId);

  // button
  ReceiptLogCreateWindow openReceiptLogCreateWindow();
  // </navigators>
}

// </inteface>

// <mock>
class MockMainPage implements MainPage {
  @override
  late final Date today;
  late final List<ReceiptLogAndMonitorTicket> tickets;
  final StreamController<List<ReceiptLogAndMonitorTicket>> ticketsStream =
      StreamController();

  MockMainPage() {
    var now = DateTime.now();
    today = Date(now.year, now.month, now.day);

    var twoMonthAgo = now.subtract(const Duration(days: 2 * 31));
    var twoMonthLater = now.add(const Duration(days: 2 * 31));
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
    ticketsStream.add(tickets);
  }

  @override
  Stream<List<ReceiptLogAndMonitorTicket>> getTickets() {
    return ticketsStream.stream;
  }

  @override
  MonitorSchemeEditWindow openMonitorSchemeEditWindow(int targetTicketId) {
    return MockMonitorSchemeEditWindow(targetTicketId, ticketsStream, tickets);
  }

  @override
  ReceiptLogEditWindow openReceiptLogEditWindow(int targetTicketId) {
    return MockReceiptLogEditWindow(targetTicketId, ticketsStream, tickets);
  }

  @override
  ReceiptLogConfirmationWindow openReceiptLogConfirmationWindow(
      int targetTicketId) {
    return MockReceiptLogConfirmationWindow(
        targetTicketId, tickets, ticketsStream);
  }

  @override
  ReceiptLogCreateWindow openReceiptLogCreateWindow() {
    return MockReceiptLogCreateWindow(tickets, ticketsStream);
  }
}
// </mock>