import 'package:miraibo/skeleton/data_page/shared.dart';
import 'package:miraibo/dto/dto.dart';

// <interface>
abstract interface class MonitorSchemeSection {
  /// MonitorSchemeSection is a section to create a monitor scheme.
  /// A monitor scheme consists of the following information:
  ///
  /// - which categories should be counted
  /// - what period should be counted
  /// - how to display the monitor
  ///    - which display config does the ticket follow
  ///    - which currency does the ticket use
  ///

  // <states>
  abstract TicketScheme currentTicketScheme;
  // </states>

  // <presenters>
  /// categories counted should be specified.
  /// all of categories are shown as options.
  Future<List<Category>> getCategoryOptions();

  /// currency in which the ticket shown should be specified.
  /// all of currencies are shown as options.
  Future<List<Currency>> getCurrencyOptions();

  /// for convenience, default currency should be supplied.
  Future<Currency> getDefaultCurrency();
  // </presenters>

  // <actions>
  Future<void> applyMonitorScheme(List<int> categoryIds, OpenPeriod period,
      MonitorDisplayConfig displayConfig, int currencyId);
  // </actions>
}
// </interface>
