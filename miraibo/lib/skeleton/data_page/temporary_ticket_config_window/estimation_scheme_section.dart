import 'package:miraibo/skeleton/data_page/shared.dart';
import 'package:miraibo/dto/dto.dart';

// <interface>
abstract interface class EstimationSchemeSection {
  /// EstimationSchemeSection is a section to create an estimation scheme.
  /// An estimation scheme consists of the following information:
  ///
  /// - which categories should be counted
  /// - what period should be counted
  /// - how to display the estimation
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
      EstimationDisplayConfig displayConfig, int currencyId);
  // </actions>
}
// </interface>
