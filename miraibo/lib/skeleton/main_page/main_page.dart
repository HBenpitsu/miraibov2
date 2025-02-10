import 'package:miraibo/skeleton/main_page/monitor_scheme_edit_window.dart';
import 'package:miraibo/skeleton/main_page/receipt_log_confirmation_window.dart';
import 'package:miraibo/skeleton/main_page/receipt_log_create_window.dart';
import 'package:miraibo/skeleton/main_page/receipt_log_edit_window.dart';

// <interface>
abstract interface class MainPagePresenter {
  MonitorSchemeEditWindowPresenter get monitorSchemeEditWindowPresenter;
  ReceiptLogCreateWindowPresenter get receiptLogCreateWindowPresenter;
  ReceiptLogEditWindowPresenter get receiptLogEditWindowPresenter;
  ReceiptLogConfirmationWindowPresenter
      get receiptLogConfirmationWindowPresenter;
}

abstract interface class MainPageController {
  MonitorSchemeEditWindowController get monitorSchemeEditWindowController;
  ReceiptLogCreateWindowController get receiptLogCreateWindowController;
  ReceiptLogEditWindowController get receiptLogEditWindowController;
  ReceiptLogConfirmationWindowController
      get receiptLogConfirmationWindowController;
}
// </inteface>