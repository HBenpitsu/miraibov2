import 'package:miraibo/skeleton/planning_page/modal_window/monitor_scheme_edit_window.dart';
import 'package:miraibo/skeleton/planning_page/modal_window/receipt_log_edit_window.dart';
import 'package:miraibo/skeleton/planning_page/modal_window/estimation_scheme_edit_window.dart';
import 'package:miraibo/skeleton/planning_page/modal_window/plan_edit_window.dart';

class TicketEditWindowPresenter {
  final EstimationSchemeEditWindowPresenter
      estimationSchemeEditWindowPresenter =
      EstimationSchemeEditWindowPresenter();
  final MonitorSchemeEditWindowPresenter monitorSchemeEditWindowPresenter =
      MonitorSchemeEditWindowPresenter();
  final PlanEditWindowPresenter planEditWindowPresenter =
      PlanEditWindowPresenter();
  final ReceiptLogEditWindowPresenter receiptLogEditWindowPresenter =
      ReceiptLogEditWindowPresenter();
}

class TicketEditWindowController {
  final EstimationSchemeEditWindowController
      estimationSchemeEditWindowController =
      EstimationSchemeEditWindowController();
  final MonitorSchemeEditWindowController monitorSchemeEditWindowController =
      MonitorSchemeEditWindowController();
  final PlanEditWindowController planEditWindowController =
      PlanEditWindowController();
  final ReceiptLogEditWindowController receiptLogEditWindowController =
      ReceiptLogEditWindowController();
}
