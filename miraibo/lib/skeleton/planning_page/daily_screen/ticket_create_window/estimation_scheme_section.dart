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

  // <controllers>
  Future<void> createEstimationScheme(List<int> categoryIds, OpenPeriod period,
      EstimationDisplayConfig displayConfig, int currencyId);
  // </controllers>
}
// </interface>
