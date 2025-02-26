import 'dart:async';

import 'package:miraibo/dto/dto.dart';

// <shared skeletons>
// following compoents are used from shared.dart:
// - monitor scheme edit window
// - receipt log confirmation window
// - receipt log edit window
import 'package:miraibo/skeleton/shared.dart';
export 'package:miraibo/skeleton/shared.dart';
// </shared skeletons>

// <page>
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
// </page>

// <log create window>
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
// </log create window>
