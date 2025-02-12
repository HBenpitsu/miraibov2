import 'package:miraibo/dto/dto.dart';

// <interface>
abstract interface class MonitorSchemeEditWindow {
  /// monitor scheme edit window is shown when user wants to edit monitor scheme.
  ///
  /// monitor scheme consists of following information:
  ///
  /// - which categories should be counted
  /// - what period soulde be counted
  /// - how to display monitor
  ///   - which display config does the ticket follow
  ///   - which currency does the ticket use

  // <state>
  abstract int targetTicketId;
  // </state>

  // <presenters>
  /// categories counted should be specified.
  /// all of categories are shown as options.
  Future<List<Category>> getCategoryOptions();

  /// currency in which the ticket shown should be specified.
  /// all of currencies are shown as options.
  Future<List<Currency>> getCurrencyOptions();

  // here, we do not need default currency, because original monitor scheme already has currency.

  /// get original monitor scheme. original configuration should be supplied when users editing it.
  Future<RawMonitorScheme> getOriginalMonitorScheme();
  // </presenters>

  // <controllers>
  Future<void> updateMonitorScheme(int categoryId, OpenPeriod period,
      MonitorDisplayConfig displayConfig, int currencyId);

  Future<void> deleteMonitorScheme();
  // </controllers>
}
// </interface>
