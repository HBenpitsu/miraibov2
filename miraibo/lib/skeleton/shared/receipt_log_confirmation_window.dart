import 'package:miraibo/dto/dto.dart';
import 'package:miraibo/skeleton/shared/receipt_log_edit_window.dart';

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

// <mock>
// </mock>
