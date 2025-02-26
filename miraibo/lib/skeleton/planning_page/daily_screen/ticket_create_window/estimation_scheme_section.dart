import 'package:miraibo/dto/dto.dart';

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
