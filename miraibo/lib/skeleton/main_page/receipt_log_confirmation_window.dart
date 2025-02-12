import 'package:miraibo/dto/dto.dart';
import 'package:miraibo/skeleton/main_page/receipt_log_edit_window.dart';

// <interface>
abstract interface class ReceiptLogConfirmationWindow {
  /// receipt log confirmation window is shown when a unconfirmed receipt log is selected.
  /// The window shows the receipt log and the button to confirm/edit the receipt log.

  // <states>
  abstract int targetReceiptLogId;
  // </states>

  // <presenters>
  Future<ReceiptLogTicket> getLogContent();
  // </presenters>

  // <naviagtors>
  /// when user selects to edit the receipt log, the receipt log edit window opens.
  ReceiptLogEditWindow openReceiptLogEditWindow();
  // </navigators>

  // <controllers>
  /// regardless user confirms or edits the receipt log, the receipt log is marked as confirmed.
  Future<void> confirmReceiptLog();
  // </controllers>
}
// </interface>
