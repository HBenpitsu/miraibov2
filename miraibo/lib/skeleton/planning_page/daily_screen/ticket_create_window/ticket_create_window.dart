import 'package:miraibo/skeleton/planning_page/daily_screen/ticket_create_window/estimation_scheme_section.dart';
import 'package:miraibo/skeleton/planning_page/daily_screen/ticket_create_window/monitor_scheme_section.dart';
import 'package:miraibo/skeleton/planning_page/daily_screen/ticket_create_window/receipt_log_section.dart';
import 'package:miraibo/skeleton/planning_page/daily_screen/ticket_create_window/plan_section.dart';

// <interface>
abstract interface class TicketCreateWindowPresenter {
  PlanSectionPresenter get planSectionPresenter;
  ReceiptLogSectionPresenter get receiptLogSectionPresenter;
  EstimationSchemeSectionPresenter get estimationSchemeSectionPresenter;
  MonitorSchemeSectionPresenter get monitorSchemeSectionPresenter;
}

abstract interface class TicketCreateWindowController {
  PlanSectionController get planSectionController;
  ReceiptLogSectionController get receiptLogSectionController;
  EstimationSchemeSectionController get estimationSchemeSectionController;
  MonitorSchemeSectionController get monitorSchemeSectionController;
}
// </interface>