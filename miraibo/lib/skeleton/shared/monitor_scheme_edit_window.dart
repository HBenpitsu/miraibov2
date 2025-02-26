import 'package:miraibo/dto/dto.dart';

// <interface>
/// monitor scheme edit window is shown when user wants to edit monitor scheme.
///
/// monitor scheme consists of following information:
///
/// - which categories should be counted
/// - what period should be counted
/// - how to display monitor
///   - which display config does the ticket follow
///   - which currency does the ticket use
abstract interface class MonitorSchemeEditWindow {
  // <state>
  /// The ID of the monitor scheme to be edited.
  /// This is not changed during the lifecycle of the window.
  int get targetTicketId;
  // </state>

  // <presenters>
  /// categories counted should be specified.
  /// all of categories are shown as options.
  Future<List<Category>> getCategoryOptions();

  /// currency in which the ticket shown should be specified.
  /// all of currencies are shown as options.
  Future<List<Currency>> getCurrencyOptions();

  /// get original monitor scheme. original configuration should be supplied when users editing it.
  Future<MonitorScheme> getOriginalMonitorScheme();
  // </presenters>

  // <controllers>
  /// update the monitor scheme with the specified parameters.
  /// [targetTicketId] is used to identify the monitor scheme to be updated.
  Future<void> updateMonitorScheme(
      {required List<int> categoryIds,
      required OpenPeriod period,
      required MonitorDisplayOption displayOption,
      required int currencyId});

  /// delete the monitor scheme.
  /// [targetTicketId] is used to identify the monitor scheme to be deleted.
  Future<void> deleteMonitorScheme();
  // </controllers>

  // <navigators>
  /// should be called when this skeleton is no longer needed.
  void dispose();
  // </navigators>
}
// </interface>
