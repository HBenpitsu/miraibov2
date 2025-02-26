import 'package:miraibo/dto/dto.dart';

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
