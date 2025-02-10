import 'package:miraibo/skeleton/planning_page/daily_screen/estimation_scheme_edit_window.dart';
import 'package:miraibo/skeleton/planning_page/daily_screen/monitor_scheme_edit_window.dart';
import 'package:miraibo/skeleton/planning_page/daily_screen/receipt_log_edit_window.dart';
import 'package:miraibo/skeleton/planning_page/daily_screen/plan_edit_window.dart';
import 'package:miraibo/skeleton/planning_page/daily_screen/ticket_create_window/ticket_create_window.dart';

// <interface>
abstract interface class DailyScreenPresenter {
  PlanEditWindowPresenter get planEditWindowPresenter;
  ReceiptLogEditWindowPresenter get receiptLogEditWindowPresenter;
  EstimationSchemeEditWindowPresenter get estimationSchemeEditWindowPresenter;
  MonitorSchemeEditWindowPresenter get monitorSchemeEditWindowPresenter;
  TicketCreateWindowPresenter get ticketCreateWindowPresenter;
}

abstract interface class DailyScreenController {
  PlanEditWindowController get planEditWindowController;
  ReceiptLogEditWindowController get receiptLogEditWindowController;
  EstimationSchemeEditWindowController get estimationSchemeEditWindowController;
  MonitorSchemeEditWindowController get monitorSchemeEditWindowController;
  TicketCreateWindowController get ticketCreateWindowController;
}
// </interface>