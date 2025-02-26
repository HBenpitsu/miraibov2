import 'dart:async';

import 'package:miraibo/dto/dto.dart';

import 'package:miraibo/skeleton/planning_page/monthly_screen.dart';

// <shared skeletons>
// following skeletons are used in daily screen:
// - monitor scheme edit window
// - receipt log confirmation window
// - receipt log edit window
import 'package:miraibo/skeleton/shared.dart';
// </shared skeletons>

// <page>
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
// </page>

// <windows>
// <estimation scheme edit window>
// <interface>
/// EstimationSchemeEditWindow is shown when the user wants to edit an estimation scheme.
///
/// An estimation scheme consists of the following information:
/// - which categories should be counted
/// - what period should be counted
/// - how to display the estimation
///   - which display config the ticket follows
///   - which currency the ticket uses
///
abstract interface class EstimationSchemeEditWindow {
  // <states>
  /// The ID of the target estimation scheme.
  /// This is used to identify the estimation scheme to be edited.
  int get targetSchemeId;
  // </states>

  // <presenters>
  /// Categories counted should be specified.
  /// All categories are shown as options.
  Future<List<Category>> getCategoryOptions();

  /// The currency in which the ticket is shown should be specified.
  /// All currencies are shown as options.
  Future<List<Currency>> getCurrencyOptions();

  /// Get the original estimation scheme.
  /// The original configuration should be supplied when users are editing it.
  Future<EstimationScheme> getOriginalEstimationScheme();
  // </presenters>

  // <controllers>
  /// Update the estimation scheme with the specified parameters.
  /// [targetSchemeId] is used to identify the estimation scheme to be updated.
  Future<void> updateEstimationScheme(
      {required List<int> categoryIds,
      required OpenPeriod period,
      required EstimationDisplayOption displayOption,
      required int currencyId});

  /// Delete the estimation scheme.
  /// [targetSchemeId] is used to identify the estimation scheme to be deleted.
  Future<void> deleteEstimationScheme();
  // </controllers>

  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}
// </interface>
// </estimation scheme edit window>

// <plan edit window>
// <interface>
/// PlanEditWindow is a window to edit a plan.
/// A plan consists of the following information:
///
/// - which category the plan belongs to
/// - what the plan is
/// - how much the plan will cost
/// - when the plan will be executed
///
abstract interface class PlanEditWindow {
  // <states>
  /// This is used to identify the plan to be edited.
  /// This is not changed during the lifecycle of the window.
  int get targetPlanId;
  // </states>

  // <presenters>
  /// The category to which the plan belongs should be specified.
  /// All categories are shown as options.
  Future<List<Category>> getCategoryOptions();

  /// The currency in which the plan costs should be specified.
  /// All currencies are shown as options.
  Future<List<Currency>> getCurrencyOptions();

  /// Get the original plan.
  /// The original scheme of the plan should be supplied when users are editing it.
  Future<PlanScheme> getOriginalPlan();
  // </presenters>

  // <controllers>
  /// Update the plan with the specified parameters.
  /// [targetPlanId] is used to identify the plan to be updated.
  Future<void> updatePlan(
      {required int categoryId,
      required String description,
      required int amount,
      required int currencyId,
      required Schedule schedule});

  /// Delete the plan.
  /// [targetPlanId] is used to identify the plan to be deleted.
  Future<void> deletePlan();
  // </controllers>

  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}
// </interface>
// </plan edit window>
// <ticket create window>

// <window>
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
// </window>

// <sections>
// <estimation scheme section>
// <interface>
/// EstimationSchemeSection is a section to create an estimation scheme.
/// An estimation scheme consists of the following information:
///
/// - which categories should be counted
/// - what period should be counted
/// - how to display the estimation
///    - which display config does the ticket follow
///    - which currency does the ticket use
///
abstract interface class EstimationSchemeSection {
  // <presenters>
  /// categories counted should be specified.
  /// all of categories are shown as options.
  Future<List<Category>> getCategoryOptions();

  /// currency in which the ticket shown should be specified.
  /// all of currencies are shown as options.
  Future<List<Currency>> getCurrencyOptions();

  /// initial scheme should be supplied.
  Future<EstimationScheme> getInitialScheme();
  // </presenters>

  // <controllers>
  /// create the estimation scheme with the specified scheme.
  Future<void> createEstimationScheme(
      {required List<int> categoryIds,
      required OpenPeriod period,
      required EstimationDisplayOption displayOption,
      required int currencyId});
  // </controllers>

  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}
// </interface>
// </estimation scheme section>

// <monitor scheme section>
// <interface>
/// MonitorSchemeSection is a section to create a monitor scheme.
/// A monitor scheme consists of the following information:
///
/// - which categories should be counted
/// - what period should be counted
/// - how to display the monitor
///    - which display config does the ticket follow
///    - which currency does the ticket use
///

abstract interface class MonitorSchemeSection {
  // <presenters>
  /// categories counted should be specified.
  /// all of categories are shown as options.
  Future<List<Category>> getCategoryOptions();

  /// currency in which the ticket shown should be specified.
  /// all of currencies are shown as options.
  Future<List<Currency>> getCurrencyOptions();

  /// initial scheme should be supplied.
  Future<MonitorScheme> getInitialScheme();
  // </presenters>

  // <controllers>
  /// create the monitor scheme with the specified scheme.
  Future<void> createMonitorScheme(
      {required List<int> categoryIds,
      required OpenPeriod period,
      required MonitorDisplayOption displayOption,
      required int currencyId});
  // </controllers>

  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}
// </interface>
// </monitor scheme section>

// <receipt log section>

// <interface>
/// ReceiptLogSection is a section to create a receipt log.
/// A receipt log consists of the following information:
///
/// - which category the receipt log belongs to
/// - what the receipt log is
/// - how much the receipt log costs
/// - when the receipt log was created
/// - whether the receipt log is confirmed
///
/// Although this window is virtually the same as [ReceiptLogCreateWindow],
/// the difference is that they are window and section(not window).
/// This difference keep [ReceiptLogSection] and [ReceiptLogCreateWindow] separate.
abstract interface class ReceiptLogSection {
  // <presenters>
  /// category to which the receipt log belongs should be specified.
  /// all of categories are shown as options.
  Future<List<Category>> getCategoryOptions();

  /// currency in which the receipt log costs should be specified.
  /// all of currencies are shown as options.
  Future<List<Currency>> getCurrencyOptions();

  /// initial scheme should be supplied.
  Future<ReceiptLogScheme> getInitialScheme();

  /// for convenience, presets for the receipt log should be supplied.
  Future<List<ReceiptLogSchemePreset>> getPresets();
  // </presenters>

  // <controllers>
  /// create the receipt log with the specified scheme.
  Future<void> createReceiptLog(
      {required int categoryId,
      required String description,
      required int amount,
      required int currencyId,
      required Date date});
  // </controllers>

  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}
// </interface>
// </receipt log section>

// <plan section>
// <interface>
/// PlanSection is a section to create a plan.
/// A plan consists of following information:
///
/// - which category the plan belongs to
/// - what the plan is
/// - how much the plan will cost
/// - when the plan will be executed
///

abstract interface class PlanSection {
  // <presenters>
  /// category to which the plan belongs should be specified.
  /// all of categories are shown as options.
  Future<List<Category>> getCategoryOptions();

  /// currency in which the plan costs should be specified.
  /// all of currencies are shown as options.
  Future<List<Currency>> getCurrencyOptions();

  /// initial scheme should be supplied.
  Future<PlanScheme> getInitialScheme();
  // </presenters>

  // <controllers>
  /// create the plan with the specified scheme.
  Future<void> createPlan(
      {required int categoryId,
      required String description,
      required int amount,
      required int currencyId,
      required Schedule schedule});
  // </controllers>

  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}
// </interface>
// </plan section>
// </sections>

// </ticket create window>
// </windows>
