import 'package:miraibo/dto/dto.dart';

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
