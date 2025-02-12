import 'package:miraibo/skeleton/planning_page/daily_screen/ticket_create_window/estimation_scheme_section.dart';
import 'package:miraibo/skeleton/planning_page/daily_screen/ticket_create_window/monitor_scheme_section.dart';
import 'package:miraibo/skeleton/planning_page/daily_screen/ticket_create_window/receipt_log_section.dart';
import 'package:miraibo/skeleton/planning_page/daily_screen/ticket_create_window/plan_section.dart';

// <interface>
abstract interface class TicketCreateWindow {
  /// ticket create window is shown when user wants to create a new ticket.

  // <naviagtors>
  PlanSection get planSection;
  EstimationSchemeSection get estimationSchemeSection;
  MonitorSchemeSection get monitorSchemeSection;
  ReceiptLogSection get receiptLogSection;
  // </navigators>
}

// </interface>