import 'package:miraibo/dto/dto.dart';

import 'package:miraibo/skeleton/planning_page/daily_screen/ticket_create_window/estimation_scheme_section.dart';
import 'package:miraibo/skeleton/planning_page/daily_screen/ticket_create_window/monitor_scheme_section.dart';
import 'package:miraibo/skeleton/planning_page/daily_screen/ticket_create_window/receipt_log_section.dart';
import 'package:miraibo/skeleton/planning_page/daily_screen/ticket_create_window/plan_section.dart';

// <interface>
abstract interface class TicketCreateWindow {
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

  // <naviagtors>
  PlanSection get planSection;
  EstimationSchemeSection get estimationSchemeSection;
  MonitorSchemeSection get monitorSchemeSection;
  ReceiptLogSection get receiptLogSection;
  // </navigators>
}

// </interface>

// <mock>
class MockTicketCreateWindow implements TicketCreateWindow {
  @override
  late final PlanSection planSection;
  @override
  late final EstimationSchemeSection estimationSchemeSection;
  @override
  late final MonitorSchemeSection monitorSchemeSection;
  @override
  late final ReceiptLogSection receiptLogSection;

  MockTicketCreateWindow(List<Ticket> tickets, Sink ticketsStream) {
    planSection = MockPlanSection(tickets, ticketsStream);
    estimationSchemeSection =
        MockEstimationSchemeSection(tickets, ticketsStream);
    monitorSchemeSection = MockMonitorSchemeSection(tickets, ticketsStream);
    receiptLogSection = MockReceiptLogSection(tickets, ticketsStream);
  }
}
// </mock>
