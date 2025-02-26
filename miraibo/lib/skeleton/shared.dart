import 'package:miraibo/dto/dto.dart';

// <log edit window>
// <interface>
/// receipt log edit window is shown when user wants to edit receipt log.
///
/// receipt log consists of following information:
///
/// - which category the receipt log belongs to
/// - what the receipt log is
/// - how much the receipt log costs
/// - when the receipt log was created
/// - whether the receipt log is confirmed
///
abstract interface class ReceiptLogEditWindow {
  // <state>
  /// The ID of the receipt log to be edited.
  /// This is not changed during the lifecycle of the window.
  int get targetLogId;
  // </state>

  // <presenters>
  /// category to which the receipt log belongs should be specified.
  /// all of categories are shown as options.
  Future<List<Category>> getCategoryOptions();

  /// currency in which the receipt log costs should be specified.
  /// all of currencies are shown as options.
  Future<List<Currency>> getCurrencyOptions();

  // here, we do not need default currency, because original receipt log already has currency.

  /// get original receipt log. original configuration should be supplied when users editing it.
  Future<ReceiptLogScheme> getOriginalReceiptLog();
  // </presenters>

  // <controllers>
  /// update the receipt log with the specified parameters.
  /// [targetLogId] is used to identify the receipt log to be updated.
  Future<void> updateReceiptLog(
      {required int categoryId,
      required String description,
      required int amount,
      required int currencyId,
      required Date date});

  /// delete the receipt log.
  /// [targetLogId] is used to identify the receipt log to be deleted.
  Future<void> deleteReceiptLog();
  // </controllers>

  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}
// </interface>
// </log edit window>

// <log confirmation window>
// <interface>
/// The window shows the receipt log and the buttons to confirm/edit the receipt log.
abstract interface class ReceiptLogConfirmationWindow {
  // <states>
  /// the id of the receipt log to be confirmed.
  /// this is not changed during the lifecycle of the window.
  int get targetReceiptLogId;
  // </states>

  // <presenters>
  /// get the content of the receipt log.
  /// The content should be shown in the window.
  Future<ReceiptLogTicket> getLogContent();
  // </presenters>

  // <naviagtors>
  /// when user selects to edit the receipt log, the receipt log edit window opens
  /// shortly after this window is closed.
  ReceiptLogEditWindow openReceiptLogEditWindow();
  // </navigators>

  // <controllers>
  /// Mark the receipt log as confirmed. Only if the user cancels the confirmation, it is not confirmed.
  /// regardless user confirms or edits the receipt log, the receipt log is marked as confirmed.
  Future<void> confirmReceiptLog();
  // </controllers>

  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}
// </interface>
// </log confirmation window>

// <monitor scheme edit window>
// <interface>
/// monitor scheme edit window is shown when user wants to edit monitor scheme.
///
/// monitor scheme consists of following information:
///
/// - which categories should be counted
/// - what period should be counted
/// - how to display monitor
///   - which display config does the ticket follow
///   - which currency does the ticket use
abstract interface class MonitorSchemeEditWindow {
  // <state>
  /// The ID of the monitor scheme to be edited.
  /// This is not changed during the lifecycle of the window.
  int get targetTicketId;
  // </state>

  // <presenters>
  /// categories counted should be specified.
  /// all of categories are shown as options.
  Future<List<Category>> getCategoryOptions();

  /// currency in which the ticket shown should be specified.
  /// all of currencies are shown as options.
  Future<List<Currency>> getCurrencyOptions();

  /// get original monitor scheme. original configuration should be supplied when users editing it.
  Future<MonitorScheme> getOriginalMonitorScheme();
  // </presenters>

  // <controllers>
  /// update the monitor scheme with the specified parameters.
  /// [targetTicketId] is used to identify the monitor scheme to be updated.
  Future<void> updateMonitorScheme(
      {required List<int> categoryIds,
      required OpenPeriod period,
      required MonitorDisplayOption displayOption,
      required int currencyId});

  /// delete the monitor scheme.
  /// [targetTicketId] is used to identify the monitor scheme to be deleted.
  Future<void> deleteMonitorScheme();
  // </controllers>

  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}
// </interface>
// </monitor scheme edit window>
