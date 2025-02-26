import 'package:miraibo/skeleton/planning_page/daily_screen/ticket_create_window/estimation_scheme_section.dart';
export 'package:miraibo/skeleton/planning_page/daily_screen/ticket_create_window/estimation_scheme_section.dart';
import 'package:miraibo/skeleton/planning_page/daily_screen/ticket_create_window/monitor_scheme_section.dart';
export 'package:miraibo/skeleton/planning_page/daily_screen/ticket_create_window/monitor_scheme_section.dart';
import 'package:miraibo/skeleton/planning_page/daily_screen/ticket_create_window/receipt_log_section.dart';
export 'package:miraibo/skeleton/planning_page/daily_screen/ticket_create_window/receipt_log_section.dart';
import 'package:miraibo/skeleton/planning_page/daily_screen/ticket_create_window/plan_section.dart';
export 'package:miraibo/skeleton/planning_page/daily_screen/ticket_create_window/plan_section.dart';

// <interface>
/// ticket create window is shown when user wants to create a new ticket.
///
/// The window consists of the following sections:
///
/// - Plan Section
/// - Estimation Scheme Section
/// - Monitor Scheme Section
/// - Receipt Log Section
///
/// Each sections are shown as tabs.
abstract interface class TicketCreateWindow {
  // <naviagtors>
  /// a tab of the window.
  PlanSection get planSection;

  /// a tab of the window.
  EstimationSchemeSection get estimationSchemeSection;

  /// a tab of the window.
  MonitorSchemeSection get monitorSchemeSection;

  /// a tab of the window.
  ReceiptLogSection get receiptLogSection;
  // </navigators>
  void dispose();
}

// </interface>
