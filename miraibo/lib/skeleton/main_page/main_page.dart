import 'package:miraibo/dto/dto.dart';
import 'package:miraibo/skeleton/main_page/monitor_scheme_edit_window.dart';
import 'package:miraibo/skeleton/main_page/receipt_log_confirmation_window.dart';
import 'package:miraibo/skeleton/main_page/receipt_log_create_window.dart';
import 'package:miraibo/skeleton/main_page/receipt_log_edit_window.dart';

// <interface>
abstract interface class MainPage {
  /// main page consists of a row of tickets and a button to create a new receipt-log.
  /// The tickets in main page are Log Tickets and Monitor Tickets.
  /// Each ticket navigates to the ticket edit window.
  /// But, the unconfirmed receipt-log navigates to the receipt-log confirmation window.
  /// The button to create a new receipt-log navigates to the receipt-log create window.

  // <states>
  abstract Date today;
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
