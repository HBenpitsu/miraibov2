import 'dart:async';

import 'package:miraibo/skeleton/planning_page/daily_screen/estimation_scheme_edit_window.dart';
export 'package:miraibo/skeleton/planning_page/daily_screen/estimation_scheme_edit_window.dart';
import 'package:miraibo/skeleton/planning_page/daily_screen/monitor_scheme_edit_window.dart';
export 'package:miraibo/skeleton/planning_page/daily_screen/monitor_scheme_edit_window.dart';
import 'package:miraibo/skeleton/planning_page/daily_screen/receipt_log_edit_window.dart';
export 'package:miraibo/skeleton/planning_page/daily_screen/receipt_log_edit_window.dart';
import 'package:miraibo/skeleton/planning_page/daily_screen/plan_edit_window.dart';
export 'package:miraibo/skeleton/planning_page/daily_screen/plan_edit_window.dart';
import 'package:miraibo/skeleton/planning_page/daily_screen/ticket_create_window/ticket_create_window.dart';
export 'package:miraibo/skeleton/planning_page/daily_screen/ticket_create_window/ticket_create_window.dart';
import 'package:miraibo/skeleton/planning_page/daily_screen/receipt_log_confirmation_window.dart';
export 'package:miraibo/skeleton/planning_page/daily_screen/receipt_log_confirmation_window.dart';
import 'package:miraibo/skeleton/planning_page/monthly_screen.dart';
import 'package:miraibo/dto/dto.dart';

// <interface>
/// Daily screen consists of infinite set of tickets.
/// But, the tickets are grouped by the date.
///
/// Each ticket (Monitor Ticket, Estimation Ticket, Plan Ticket or Log Ticket)
/// navigates to the ticket edit window.
///
/// Also, following components are also included:
/// - A button to create a new ticket.
/// - A label to show which date is centered and to navigate to Monthly Screen.
///
/// The daily screen is scrollable horizontally. So, the centered date can be changed.
/// It should be notified to the [DailyScreen] through [setOffset] to update the state and the Label.

abstract interface class DailyScreen {
  // <states>
  /// The [initiallyCenteredDate] serves as a reference point for the daily screen, determining what index-0 represents.
  /// shownDate should not be mutated during the lifecycle of the daily screen.
  Date get initiallyCenteredDate;

  /// the offset is a offset of currently centered date from the [initiallyCenteredDate].
  abstract int offset;
  // </states>

  // <presenters>
  /// Get the tickets which belongs to the date which the specified [index] represents.
  ///
  /// The origin of the [index] is [initiallyCenteredDate].
  /// When [initiallyCenteredDate] is 2022-02-01, the [index] of 2022-02-01 is `0`,
  /// the [index] of 2022-02-02 is `1`, the [index] of 2022-01-31 is `-1`.
  Stream<List<Ticket>> getTicketsOn(int index);

  /// Get the label of the currently centered date.
  /// It is calculatedd by [initiallyCenteredDate] + [offset].
  Stream<Date> getLabel();
  // </presenters>

  // <navigators>
  // label
  /// When the label which shows the centered date is tapped, navigate to the monthly screen.
  MonthlyScreen navigateToMonthlyScreen();

  // tickets
  /// When the monitor ticket is tapped, open the monitor scheme edit window.
  MonitorSchemeEditWindow openMonitorSchemeEditWindow(int targetTicketId);

  /// When the plan ticket is tapped, open the plan edit window.
  PlanEditWindow openPlanEditWindow(int targetTicketId);

  /// When the estimation ticket is tapped, open the estimation scheme edit window.
  EstimationSchemeEditWindow openEstimationSchemeEditWindow(int targetTicketId);

  /// When the confirmed receipt log ticket is tapped, open the receipt log edit window.
  ReceiptLogEditWindow openReceiptLogEditWindow(int targetTicketId);

  /// When the unconfirmed receipt log ticket is tapped, open the receipt log confirmation window.
  ReceiptLogConfirmationWindow openReceiptLogConfirmationWindow(
      int targetTicketId);

  // button
  /// When the ticket create button is tapped, open the ticket create window.
  TicketCreateWindow openTicketCreateWindow();

  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>

  // <actions>
  /// the offset is a offset of currently centered date from the [initiallyCenteredDate].
  /// This should be updated properly to show proper date on `Label`, `ticketCreateWindow`, and `ticketEditWindow`.
  Future<void> setOffset(int offset);
  // </actions>
}

// </interface>
