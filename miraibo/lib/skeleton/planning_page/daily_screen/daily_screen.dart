import 'package:miraibo/skeleton/planning_page/daily_screen/estimation_scheme_edit_window.dart';
import 'package:miraibo/skeleton/planning_page/daily_screen/monitor_scheme_edit_window.dart';
import 'package:miraibo/skeleton/planning_page/daily_screen/receipt_log_edit_window.dart';
import 'package:miraibo/skeleton/planning_page/daily_screen/plan_edit_window.dart';
import 'package:miraibo/skeleton/planning_page/daily_screen/ticket_create_window/ticket_create_window.dart';
import 'package:miraibo/dto/dto.dart';
import 'package:miraibo/skeleton/planning_page/monthly_screen.dart';

// <interface>
abstract interface class DailyScreen {
  /// Daily screen consists of infinite set of tickets.
  /// But, the tickets are grouped by the date.
  ///
  /// Each ticket (Monitor Ticket, Estimation Ticket, Plan Ticket or Log Ticket)
  /// navigates to the ticket edit window.
  ///
  /// Also, following components are also included:
  /// - A button to create a new ticket.
  /// - A label to show which date is centered and navigate to Monthly Screen.
  ///
  /// The daily screen is scrollable horizontally. So, the centered date can be changed.
  /// It should be notified to the [DailyScreen] to update the Label and so on.

  // <states>
  /// The [centeredDate] serves as a reference point for the daily screen, determining what index-0 represents.
  /// shownDate should not be mutated during the lifecycle of the daily screen.
  abstract Date centeredDate;

  /// the offset is a offset of currently centered date from the [centeredDate].
  abstract Date offset;
  // </states>

  // <presenters>
  /// The origin of the [index] is [centeredDate].
  /// When [centeredDate] is 2022-02-01, the [index] of 2022-02-01 is `0`,
  /// the [index] of 2022-02-02 is `1`, the [index] of 2022-01-31 is `-1`.
  Stream<List<Ticket>> getTicketsOn(int index);

  Stream<Date> getLabel();
  // </presenters>

  // <navigators>
  // label
  MonthlyScreen navigateToMonthlyScreen();

  // tickets
  MonitorSchemeEditWindow openMonitorSchemeEditWindow(int targetTicketId);
  PlanEditWindow openPlanEditWindow(int targetTicketId);
  EstimationSchemeEditWindow openEstimationSchemeEditWindow(int targetTicketId);
  ReceiptLogEditWindow openReceiptLogEditWindow(int targetTicketId);

  // button
  TicketCreateWindow openTicketCreateWindow();
  // </navigators>

  // <actions>
  /// the offset is a offset of currently centered date from the [centeredDate].
  /// This should be updated properly to show proper date on `Label`, `ticketCreateWindow`, and `ticketEditWindow`.
  Future<void> setOffset(int offset);
  // </actions>
}

// </interface>
