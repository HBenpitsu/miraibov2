import 'package:miraibo/skeleton/main_page/modal_window/monitor_scheme_edit_window.dart';
import 'package:miraibo/skeleton/main_page/modal_window/receipt_log_confirm_window.dart';
import 'package:miraibo/skeleton/main_page/modal_window/receipt_log_create_window.dart';
import 'package:miraibo/skeleton/main_page/modal_window/receipt_log_edit_window.dart';

class MainPagePresenter {
  final MonitorSchemeEditWindowPresenter monitorSchemeEditWindowPresenter =
      MonitorSchemeEditWindowPresenter();
  final ReceiptLogConfirmWindowPresenter receiptLogConfirmWindowPresenter =
      ReceiptLogConfirmWindowPresenter();
  final ReceiptLogCreateWindowPresenter receiptLogCreateWindowPresenter =
      ReceiptLogCreateWindowPresenter();
  final ReceiptLogEditWindowPresenter receiptLogEditWindowPresenter =
      ReceiptLogEditWindowPresenter();
}

class MainPageController {
  final MonitorSchemeEditWindowController monitorSchemeEditWindowController =
      MonitorSchemeEditWindowController();
  final ReceiptLogConfirmWindowController receiptLogConfirmWindowController =
      ReceiptLogConfirmWindowController();
  final ReceiptLogCreateWindowController receiptLogCreateWindowController =
      ReceiptLogCreateWindowController();
  final ReceiptLogEditWindowController receiptLogEditWindowController =
      ReceiptLogEditWindowController();
}
