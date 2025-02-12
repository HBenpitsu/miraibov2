import 'package:miraibo/dto/dto.dart';

// <interface>
abstract interface class EstimationSchemeEditWindow {
  /// estimation scheme edit window is shown when user wants to edit estimation scheme.
  ///
  /// estimation scheme consists of following information:
  ///
  /// - which categories should be counted
  /// - what period should be counted
  /// - how to display estimation
  ///    - which display config does the ticket follow
  ///    - which currency does the ticket use
  ///

  // <states>
  abstract int targetSchemeId;
  // </states>

  // <presenters>
  /// categories counted should be specified.
  /// all of categories are shown as options.
  Future<List<Category>> getCategoryOptions();

  /// currency in which the ticket shown should be specified.
  /// all of currencies are shown as options.
  Future<List<Currency>> getCurrencyOptions();

  // here, we do not need default currency, because original estimation scheme already has currency.

  /// get original estimation scheme. original configuration should be supplied when users editing it.
  Future<RawEstimationScheme> getOriginalEstimationScheme();
  // </presenters>

  // <controllers>
  Future<void> updateEstimationScheme(List<int> categoryIds, OpenPeriod period,
      EstimationDisplayConfig displayConfig, int currencyId);

  Future<void> deleteEstimationScheme();
  // </controllers>
}
// </interface>

